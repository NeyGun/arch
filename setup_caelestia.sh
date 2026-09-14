cat << 'EOF' > ~/setup_caelestia.sh
#!/usr/bin/env bash
set -e

echo "=== [1/5] SAO LƯU & DỌN SẠCH CẤU HÌNH CŨ ==="
mkdir -p ~/dotfiles_backup_$(date +%Y%m%d_%H%M%S)
cp -r ~/.config/hypr ~/.config/waybar ~/.config/ags ~/.config/rofi ~/.config/wofi ~/.config/kitty ~/dotfiles_backup_*/ 2>/dev/null || true

# Xóa triệt để các config và cache gây xung đột keybind
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/ags ~/.config/rofi ~/.config/wofi ~/.config/kitty ~/.config/foot ~/.config/caelestia
rm -rf ~/.cache/ags ~/.cache/hypr*

echo "=== [2/5] CẬP NHẬT GÓI NỀN TẢNG ==="
sudo pacman -S --needed --noconfirm git base-devel rustup kitty jq socat

echo "=== [3/5] CLONE CAELESTIA DOTFILES ==="
git clone --depth=1 https://github.com/caelestia-dots/caelestia.git ~/.config/caelestia

echo "=== [4/5] CHẠY BỘ CÀI CAELESTIA ==="
cd ~/.config/caelestia
if [ -f "install.sh" ]; then
    chmod +x install.sh
    ./install.sh
elif [ -f "setup.sh" ]; then
    chmod +x setup.sh
    ./setup.sh
fi

echo "=== [5/5] CẤU HÌNH NVIDIA & MÀN HÌNH CHỐNG ĐEN ==="
mkdir -p ~/.config/hypr

# Đảm bảo có file hyprland.conf nếu chưa symlink
touch ~/.config/hypr/hyprland.conf

# Bổ sung cấu hình tối ưu GPU Hybrid & Fallback màn hình
cat << 'CONFIG' >> ~/.config/hypr/hyprland.conf

# --- TỰ ĐỘNG THÊM BỞI SETUP SCRIPT ---
# Màn hình luôn tự động nhận diện (rút ra/cắm vào không bị đen)
monitor = , preferred, auto, 1

# Hỗ trợ NVIDIA Wayland
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = __GLX_VENDOR_LIBRARY_NAME,nvidia

# Chống mất con trỏ chuột
cursor {
    no_hardware_cursors = true
}
CONFIG

# Phân quyền lại thư mục cho user
sudo chown -R $USER:$USER ~/.config/hypr ~/.config/caelestia

echo "=== HOÀN TẤT! HỆ THỐNG ĐÃ ĐƯỢC LÀM SẠCH VÀ CÀI ĐẶT THÀNH CÔNG ==="
echo "Bạn có thể gõ: sudo reboot để khởi động lại máy."
EOF