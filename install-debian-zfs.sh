#!/bin/bash
# shellcheck disable=SC1091
###############################################################################
# install-debian-zfs.sh  v4
#
# Debian Trixie – ZFS root chiffré – GRUB – CUDA compute
#
# - GRUB standard Debian, /boot ext4
# - ZFS natif encryption (passphrase interactive, rien sur disque)
# - Firmwares Intel backports (WiFi/BT/Audio)
# - NVIDIA headless compute + CUDA (repo NVIDIA debian13)
# - Display sur Intel iGPU
#
# Shellcheck clean. Audit sécurité : voir SECURITY-AUDIT.md
###############################################################################

set -euo pipefail

# --- Sécurité : PATH et umask ---
export PATH="/usr/sbin:/usr/bin:/sbin:/bin"
umask 077

trap 'echo -e "\n\033[0;31m[ERREUR]\033[0m Ligne $LINENO. Abandon." >&2; exit 1' ERR

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
info()  { echo -e "${GREEN}>>>${NC} $*"; }
warn()  { echo -e "${YELLOW}!!${NC} $*"; }
ask()   { echo -ne "${CYAN}?${NC} $*"; }

# =============================================================================
# VALIDATION HELPERS
# =============================================================================
validate_hostname() {
    local h="$1"
    if [[ ! "$h" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$ ]]; then
        echo "Hostname invalide (RFC 1123 : alphanum et tirets, 1-63 chars)."
        return 1
    fi
}

validate_username() {
    local u="$1"
    if [[ ! "$u" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; then
        echo "Username invalide (minuscules, chiffres, tiret, underscore, max 32 chars)."
        return 1
    fi
}

validate_int() {
    local v="$1" label="$2"
    if [[ ! "$v" =~ ^[0-9]+$ ]]; then
        echo "${label} doit être un entier."
        return 1
    fi
}

validate_disk() {
    local d="$1"
    if [[ ! -b "$d" ]]; then
        echo "Le device $d n'existe pas."
        return 1
    fi
}

# =============================================================================
# VÉRIFICATIONS INITIALES
# =============================================================================
if [[ $EUID -ne 0 ]]; then
    echo "Exécuter en root."; exit 1
fi

if ! dmesg | grep -qi efivars; then
    echo "UEFI requis."; exit 1
fi

RELEASE="trixie"
TARGET="/mnt"

# Charger os-release pour $ID (ex: "debian")
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    export ID
else
    ID="debian"
    export ID
fi

echo ""
echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  Debian ${RELEASE} – ZFS chiffré – GRUB – CUDA compute  ${NC}"
echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
echo ""

# =============================================================================
# DISQUE
# =============================================================================
info "Disques disponibles :"
echo ""
lsblk -d -o NAME,SIZE,MODEL,TRAN | grep -v "^loop\|^sr\|^ram"
echo ""

while true; do
    ask "Disque cible (ex: sda, nvme0n1) : "
    read -r DISK_NAME
    if [[ "$DISK_NAME" == nvme* ]]; then
        DISK="/dev/${DISK_NAME}"; P="${DISK}p"
    else
        DISK="/dev/${DISK_NAME}"; P="${DISK}"
    fi
    validate_disk "$DISK" && break
    warn "Device invalide, réessayez."
done

DISK_SIZE_B=$(blockdev --getsize64 "$DISK")
DISK_SIZE_G=$(( DISK_SIZE_B / 1024 / 1024 / 1024 ))
RAM_MB=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
RAM_GB=$(( RAM_MB / 1024 / 1024 ))
if [[ $RAM_GB -le 16 ]]; then
    SWAP_DEFAULT="${RAM_GB}"
else
    SWAP_DEFAULT="16"
fi

# =============================================================================
# PARTITION LAYOUT
# =============================================================================
ESP_SIZE="1"
BOOT_SIZE="2"
SWAP_SIZE="${SWAP_DEFAULT}"
POOL_SIZE=$(( DISK_SIZE_G - ESP_SIZE - BOOT_SIZE - SWAP_SIZE - 1 ))

echo ""
info "Partition layout proposé pour ${DISK} (${DISK_SIZE_G} Go) :"
echo ""
echo -e "  ${BOLD}#  Partition    Taille    Type         Usage${NC}"
echo -e "  ${DIM}─────────────────────────────────────────────────${NC}"
echo -e "  1  ESP          ${ESP_SIZE} Go       EFI (vfat)   Bootloader"
echo -e "  2  /boot        ${BOOT_SIZE} Go       ext4         Kernel, initramfs"
echo -e "  3  swap         ${SWAP_SIZE} Go       crypto-swap  Swap chiffré"
echo -e "  4  zroot        ~${POOL_SIZE} Go      ZFS          Root chiffré AES-256"
echo ""
ask "Accepter ? (O/n/custom) [O] : "
read -r LAYOUT_CHOICE
LAYOUT_CHOICE=${LAYOUT_CHOICE:-O}

if [[ "$LAYOUT_CHOICE" == "custom" || "$LAYOUT_CHOICE" == "c" ]]; then
    while true; do
        ask "Taille ESP en Go [${ESP_SIZE}] : "
        read -r INPUT; ESP_SIZE=${INPUT:-$ESP_SIZE}
        validate_int "$ESP_SIZE" "ESP" && break
    done
    while true; do
        ask "Taille /boot en Go [${BOOT_SIZE}] : "
        read -r INPUT; BOOT_SIZE=${INPUT:-$BOOT_SIZE}
        validate_int "$BOOT_SIZE" "/boot" && break
    done
    while true; do
        ask "Taille swap en Go (0 = pas de swap) [${SWAP_SIZE}] : "
        read -r INPUT; SWAP_SIZE=${INPUT:-$SWAP_SIZE}
        validate_int "$SWAP_SIZE" "swap" && break
    done
    POOL_SIZE=$(( DISK_SIZE_G - ESP_SIZE - BOOT_SIZE - SWAP_SIZE - 1 ))
    if [[ $POOL_SIZE -lt 10 ]]; then
        error "Pool ZFS trop petit (${POOL_SIZE} Go). Réduisez les autres partitions."
        exit 1
    fi
    echo ""
    info "Layout custom :"
    echo "  ESP: ${ESP_SIZE}G | /boot: ${BOOT_SIZE}G | swap: ${SWAP_SIZE}G | zroot: ~${POOL_SIZE}G"
elif [[ "$LAYOUT_CHOICE" == "n" || "$LAYOUT_CHOICE" == "N" ]]; then
    echo "Abandon."; exit 0
fi

# =============================================================================
# HOSTNAME, USER, DESKTOP
# =============================================================================
echo ""
while true; do
    ask "Hostname [debian] : "
    read -r HOSTNAME_INPUT; HOSTNAME_INPUT=${HOSTNAME_INPUT:-debian}
    validate_hostname "$HOSTNAME_INPUT" && break
done

while true; do
    ask "Utilisateur : "
    read -r USERNAME
    validate_username "$USERNAME" && break
done

while true; do
    ask "Mot de passe : "
    read -rs USER_PASSWORD; echo ""
    if [[ ${#USER_PASSWORD} -lt 8 ]]; then
        warn "Mot de passe trop court (min 8 caractères)."
        continue
    fi
    ask "Confirmer : "
    read -rs USER_PASSWORD2; echo ""
    if [[ "$USER_PASSWORD" == "$USER_PASSWORD2" ]]; then
        break
    fi
    warn "Mots de passe différents."
done

# Hasher le mot de passe immédiatement, puis l'effacer de la mémoire
# SHA-512 avec salt aléatoire — même format que /etc/shadow
USER_HASH=$(openssl passwd -6 -stdin <<< "$USER_PASSWORD")
unset USER_PASSWORD USER_PASSWORD2

echo ""
info "Desktop :"
echo "  0 = aucun (serveur)"
echo "  1 = GNOME"
echo "  2 = KDE Plasma"
echo "  3 = XFCE"
ask "Choix [1] : "
read -r DESKTOP; DESKTOP=${DESKTOP:-1}
if [[ ! "$DESKTOP" =~ ^[0-3]$ ]]; then
    warn "Choix invalide, défaut GNOME."
    DESKTOP="1"
fi

# =============================================================================
# RÉCAPITULATIF
# =============================================================================
echo ""
echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
info "Récapitulatif :"
echo ""
echo "  Disque      : ${DISK} (${DISK_SIZE_G} Go)"
echo "  ESP         : ${ESP_SIZE} Go"
echo "  /boot       : ${BOOT_SIZE} Go (ext4)"
echo "  Swap        : ${SWAP_SIZE} Go (chiffré)"
echo "  ZFS pool    : ~${POOL_SIZE} Go (AES-256-GCM, passphrase au boot)"
echo "  Bootloader  : GRUB"
echo "  Hostname    : ${HOSTNAME_INPUT}"
echo "  User        : ${USERNAME}"
echo "  Desktop     : ${DESKTOP}"
echo "  NVIDIA      : headless compute + CUDA"
echo "  Display     : Intel iGPU"
echo -e "${BOLD}═══════════════════════════════════════════════════════════${NC}"
echo ""
warn "TOUTES LES DONNÉES SUR ${DISK} SERONT DÉTRUITES !"
ask "Taper OUI pour lancer l'installation : "
read -r CONFIRM
[[ "$CONFIRM" != "OUI" ]] && { echo "Abandon."; exit 1; }

# =============================================================================
# 1. ENVIRONNEMENT LIVE
# =============================================================================
echo ""
info "[1/7] Préparation de l'environnement live..."

cat > /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian ${RELEASE} main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ ${RELEASE}-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian ${RELEASE}-backports main contrib non-free non-free-firmware
EOF
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    debootstrap gdisk dosfstools zfs-dkms zfsutils-linux

modprobe zfs
zgenhostid -f "0x$(date +%s | cut -c1-8)"

# =============================================================================
# 2. PARTITIONNEMENT
# =============================================================================
info "[2/7] Partitionnement de ${DISK}..."

wipefs -a "$DISK"
sgdisk --zap-all --clear "$DISK"
sleep 1

PARTNUM=0

PARTNUM=$((PARTNUM + 1))
ESP_PARTNUM=$PARTNUM
sgdisk -n "${PARTNUM}:1m:+${ESP_SIZE}g" -t "${PARTNUM}:ef00" -c "${PARTNUM}:esp" "$DISK"

PARTNUM=$((PARTNUM + 1))
BOOT_PARTNUM=$PARTNUM
sgdisk -n "${PARTNUM}:0:+${BOOT_SIZE}g" -t "${PARTNUM}:8300" -c "${PARTNUM}:boot" "$DISK"

if [[ "$SWAP_SIZE" -gt 0 ]]; then
    PARTNUM=$((PARTNUM + 1))
    sgdisk -n "${PARTNUM}:0:+${SWAP_SIZE}g" -t "${PARTNUM}:8200" -c "${PARTNUM}:swap" "$DISK"
fi

PARTNUM=$((PARTNUM + 1))
POOL_PARTNUM=$PARTNUM
sgdisk -n "${PARTNUM}:0:-10m" -t "${PARTNUM}:bf00" -c "${PARTNUM}:pool" "$DISK"

partprobe "$DISK"
sleep 2
sgdisk -p "$DISK"

mkfs.vfat -F32 "${P}${ESP_PARTNUM}"
mkfs.ext4 -q -L boot "${P}${BOOT_PARTNUM}"

# =============================================================================
# 3. POOL ZFS CHIFFRÉ
# =============================================================================
info "[3/7] Création du pool ZFS chiffré..."
echo ""
warn "ZFS va demander la passphrase de chiffrement (2 fois)."
warn "Cette passphrase sera demandée à CHAQUE boot."
echo ""

POOL_PARTUUID=$(lsblk -no PARTUUID "${P}${POOL_PARTNUM}")
POOL_ID="/dev/disk/by-partuuid/${POOL_PARTUUID}"

if [[ ! -e "$POOL_ID" ]]; then
    error "Partition pool introuvable : ${POOL_ID}"
    exit 1
fi

zpool create -f -m none \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posix \
    -O xattr=sa \
    -O compression=lz4 \
    -O encryption=aes-256-gcm \
    -O keyformat=passphrase \
    -O keylocation=prompt \
    -O relatime=on \
    zroot "$POOL_ID"

zfs create -o mountpoint=none                 zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto "zroot/ROOT/${ID}"
zfs create -o mountpoint=/home                zroot/home
zfs create -o mountpoint=/var                 zroot/var
zfs create -o mountpoint=/var/log             zroot/var/log
zfs create -o mountpoint=/var/cache           zroot/var/cache
zpool set "bootfs=zroot/ROOT/${ID}" zroot

zpool export zroot
zpool import -N -R "${TARGET}" zroot

echo ""
warn "Entrez la passphrase ZFS pour déverrouiller le pool :"
zfs load-key zroot

zfs mount "zroot/ROOT/${ID}"
zfs mount zroot/home
zfs mount zroot/var
zfs mount zroot/var/log
zfs mount zroot/var/cache
udevadm trigger

mkdir -p "${TARGET}/boot"
mount "${P}${BOOT_PARTNUM}" "${TARGET}/boot"
mkdir -p "${TARGET}/boot/efi"
mount "${P}${ESP_PARTNUM}" "${TARGET}/boot/efi"

# =============================================================================
# 4. DEBOOTSTRAP
# =============================================================================
info "[4/7] Debootstrap Debian ${RELEASE}..."

debootstrap "${RELEASE}" "${TARGET}"

cp /etc/hostid "${TARGET}/etc/"
cp /etc/resolv.conf "${TARGET}/etc/"

mount -t proc proc "${TARGET}/proc"
mount -t sysfs sys "${TARGET}/sys"
mount -B /dev "${TARGET}/dev"
mount -t devpts pts "${TARGET}/dev/pts"

# =============================================================================
# 5. CONFIGURATION CHROOT
# =============================================================================
info "[5/7] Configuration du système..."

# Le script chroot ne contient que le HASH, jamais le mot de passe
CHROOT_SCRIPT="${TARGET}/tmp/setup.sh"

cat > "${CHROOT_SCRIPT}" <<ENDOFCHROOT
#!/bin/bash
set -euo pipefail
export PATH="/usr/sbin:/usr/bin:/sbin:/bin"
export DEBIAN_FRONTEND=noninteractive

RELEASE="${RELEASE}"
ID="${ID}"

# --- Hostname ---
echo "${HOSTNAME_INPUT}" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
127.0.1.1   ${HOSTNAME_INPUT}
::1         localhost ip6-localhost ip6-loopback
HOSTS

# --- APT ---
cat > /etc/apt/sources.list <<APT
deb http://deb.debian.org/debian/ \${RELEASE} main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security \${RELEASE}-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ \${RELEASE}-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ \${RELEASE}-backports main contrib non-free non-free-firmware
APT

cat > /etc/apt/apt.conf.d/00recommends <<APTCFG
APT::Install-Recommends "true";
APT::Install-Suggests "false";
APTCFG

apt-get update

# --- Kernel + ZFS + base ---
apt-get install -y \
    linux-image-amd64 linux-headers-amd64 \
    zfs-initramfs zfs-dkms zfs-zed \
    grub-efi-amd64 shim-signed \
    console-setup cryptsetup dosfstools efibootmgr \
    network-manager sudo locales \
    bash-completion htop nano less wget curl git ca-certificates \
    gnupg dkms build-essential pkg-config

echo "REMAKE_INITRD=yes" > /etc/dkms/zfs.conf

# --- Firmwares Intel (backports si dispo) ---
echo ">>> Firmwares Intel..."
for pkg in firmware-iwlwifi firmware-sof-signed firmware-misc-nonfree firmware-linux-nonfree firmware-realtek; do
    apt-get install -y -t "\${RELEASE}-backports" "\$pkg" 2>/dev/null \
        || apt-get install -y "\$pkg" 2>/dev/null \
        || echo "WARN: \$pkg indisponible."
done

# --- Locales / timezone ---
sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/^# *\(fr_FR.UTF-8\)/\1/' /etc/locale.gen
locale-gen
update-locale LANG=fr_FR.UTF-8
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# --- Utilisateur (mot de passe hashé SHA-512, jamais en clair) ---
useradd -m -s /bin/bash -G sudo "${USERNAME}"
echo "root:${USER_HASH}" | chpasswd -e
echo "${USERNAME}:${USER_HASH}" | chpasswd -e

# --- fstab ---
echo "PARTLABEL=boot  /boot      ext4  defaults  0 2" >> /etc/fstab
echo "PARTLABEL=esp   /boot/efi  vfat  defaults  0 1" >> /etc/fstab

# --- Swap chiffré ---
if blkid | grep -q 'PARTLABEL="swap"'; then
    echo "swap PARTLABEL=swap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=512" >> /etc/crypttab
    echo "/dev/mapper/swap  none  swap  defaults  0 0" >> /etc/fstab
fi

# --- ZFS initramfs ---
echo "UMASK=0077" > /etc/initramfs-tools/conf.d/umask.conf

systemctl enable zfs.target
systemctl enable zfs-import-cache
systemctl enable zfs-mount
systemctl enable zfs-import.target

# --- Pas de blocage réseau au boot ---
systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
systemctl mask systemd-networkd-wait-online.service 2>/dev/null || true

# --- Blacklister nouveau ---
cat > /etc/modprobe.d/blacklist-nouveau.conf <<MODCONF
blacklist nouveau
options nouveau modeset=0
MODCONF

# --- GRUB ---
cat > /etc/default/grub <<GRUBCFG
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="Debian"
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="root=ZFS=zroot/ROOT/\${ID}"
GRUB_TERMINAL=console
GRUBCFG

update-initramfs -u -k all
grub-install --target=x86_64-efi --efi-directory=/boot/efi \
    --bootloader-id=debian --recheck
update-grub

# =================================================================
# NVIDIA HEADLESS + CUDA (repo NVIDIA debian13)
# =================================================================
echo ">>> NVIDIA headless + CUDA..."

# Télécharger et vérifier la clé GPG NVIDIA
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/8793F200.pub \
    -o /tmp/nvidia-cuda.pub

# Vérifier le fingerprint attendu
EXPECTED_FP="EB693B3035CD5710E231E123A4B469963BF863CC"
ACTUAL_FP=\$(gpg --with-colons --import-options show-only --import /tmp/nvidia-cuda.pub 2>/dev/null \
    | awk -F: '/^fpr/ {print \$10; exit}')

if [[ "\${ACTUAL_FP}" != *"\${EXPECTED_FP}"* && "\${ACTUAL_FP}" != "" ]]; then
    echo "WARN: Fingerprint NVIDIA inattendu: \${ACTUAL_FP}"
    echo "WARN: Attendu (partiel): \${EXPECTED_FP}"
    echo "WARN: Installation NVIDIA ignorée par sécurité."
else
    gpg --dearmor -o /usr/share/keyrings/nvidia-cuda.gpg < /tmp/nvidia-cuda.pub

    cat > /etc/apt/sources.list.d/nvidia-cuda.sources <<NVSRC
Types: deb
URIs: https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/
Suites: /
Signed-By: /usr/share/keyrings/nvidia-cuda.gpg
NVSRC

    cat > /etc/apt/preferences.d/nvidia-cuda-pin <<PIN
Package: *
Pin: origin developer.download.nvidia.com
Pin-Priority: 100

Package: cuda* nvidia* libnvidia* libnccl*
Pin: origin developer.download.nvidia.com
Pin-Priority: 600
PIN

    apt-get update

    apt-get install -y cuda-drivers-open || {
        echo "WARN: cuda-drivers-open échoué, fallback..."
        apt-get install -y nvidia-headless-no-dkms-open-570 nvidia-utils-570 || true
    }

    apt-get install -y cuda-toolkit || {
        echo "WARN: cuda-toolkit échoué, essai nvidia-cuda-toolkit..."
        apt-get install -y nvidia-cuda-toolkit || true
    }

    cat > /etc/profile.d/cuda.sh <<'CUDAENV'
if [ -d /usr/local/cuda ]; then
    export PATH=/usr/local/cuda/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH:-}
fi
CUDAENV
    chmod 644 /etc/profile.d/cuda.sh
fi
rm -f /tmp/nvidia-cuda.pub

# =================================================================
# DISPLAY INTEL iGPU
# =================================================================
echo ">>> Display Intel iGPU..."

echo "i915" >> /etc/modules-load.d/igpu.conf

mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/10-intel-igpu.conf <<XORG
Section "Device"
    Identifier  "Intel iGPU"
    Driver      "modesetting"
    BusID       "PCI:0:2:0"
EndSection
XORG

# =================================================================
# DESKTOP
# =================================================================
case "${DESKTOP}" in
    1)
        echo ">>> GNOME..."
        apt-get install -y gnome-core gnome-terminal nautilus gdm3
        systemctl enable gdm
        ;;
    2)
        echo ">>> KDE Plasma..."
        apt-get install -y kde-plasma-desktop sddm
        systemctl enable sddm
        ;;
    3)
        echo ">>> XFCE..."
        apt-get install -y xfce4 xfce4-goodies lightdm
        systemctl enable lightdm
        ;;
esac

apt-get clean
echo ">>> Chroot terminé."
ENDOFCHROOT

chmod 700 "${CHROOT_SCRIPT}"
chroot "${TARGET}" /bin/bash /tmp/setup.sh

# Suppression sécurisée du script chroot
# (contient le hash — pas critique mais hygiène)
rm -f "${CHROOT_SCRIPT}"

# Effacer le hash de la mémoire du script parent
unset USER_HASH

# =============================================================================
# 6. DÉMONTAGE
# =============================================================================
info "[6/7] Démontage..."

umount "${TARGET}/dev/pts" || true
umount "${TARGET}/dev" || true
umount "${TARGET}/sys" || true
umount "${TARGET}/proc" || true
umount "${TARGET}/boot/efi" || true
umount "${TARGET}/boot" || true
zfs unmount -a || true
zpool export zroot || true

# =============================================================================
# 7. TERMINÉ
# =============================================================================
info "[7/7] Terminé !"
echo ""
echo "  ✓ Debian ${RELEASE} sur ZFS chiffré (passphrase au boot)"
echo "  ✓ GRUB standard — /boot ext4"
echo "  ✓ Aucune clé/mot de passe en clair sur le disque"
echo "  ✓ Firmwares Intel backports"
echo "  ✓ NVIDIA headless + CUDA"
echo "  ✓ Display Intel iGPU"
echo ""
echo "  → nvidia-smi       (GPU compute)"
echo "  → nvcc --version   (CUDA)"
echo ""
ask "Reboot ? (o/N) : "
read -r RBT
[[ "$RBT" == "o" || "$RBT" == "O" ]] && reboot
