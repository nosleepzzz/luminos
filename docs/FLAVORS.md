# 🌟 LuminOS Official Flavors & Editions Guide

**LuminOS** is a universal, ultra-lightweight Linux distribution engineered for high speed, zero-trust security sandboxing, and out-of-the-box Windows application compatibility.

To serve every hardware use-case, LuminOS comes in **4 official Flavors**:

---

## 1. 🍏 LuminOS Glass Edition (Flagship)
- **Target**: Laptops, Ultrabooks & Modern PCs
- **Desktop**: Hyprland Wayland with macOS Sonoma Glass aesthetics
- **Idle RAM**: **~420 MB**
- **Highlights**: Dynamic top menu bar, macOS traffic light controls, floating dock with hover magnification, 3-finger touchpad gestures, native battery daemon (`lumin-powerd`).

---

## 2. ⚡ LuminOS Lite Edition (Ultra-Low Spec)
- **Target**: Ancient PCs, Netbooks & Systems with 1 GB – 2 GB RAM
- **Desktop**: Sway / Openbox ultra-lightweight shell
- **Idle RAM**: **< 280 MB**
- **Highlights**: Minimalist memory footprint, ZRAM ZSTD compression target 3.0x, instant cold boot in < 4 seconds. Turns 15-year-old PCs into snappy computers.

---

## 3. 🎮 LuminOS GameDeck Edition (Gaming & Handhelds)
- **Target**: Gaming PCs, Laptops & Handheld PCs (Steam Deck, ROG Ally, Legion Go)
- **Desktop**: GameMode / Big Picture Shell + Hyprland
- **Idle RAM**: **~500 MB**
- **Highlights**: Pre-configured **Proton-Lumin GE**, MangoHud performance overlay, DXVK 2.4, VKD3D-Proton, automatic Vulkan shader pre-compilation, zero-latency BORE scheduler kernel mode (`lumin-tweak --game`).

---

## 4. 🏢 LuminOS Workstation Edition (Pro & Enterprise)
- **Target**: Desktops, Office Workstations & Developer Rigs
- **Desktop**: KDE Plasma / Classic Desktop Shell
- **Idle RAM**: **~550 MB**
- **Highlights**: Out-of-the-box Windows Office Suite runner (`lumin-security --sandbox`), KVM/QEMU virtualization, Docker container runtime, AppArmor enterprise security rules.

---

## 📊 Flavor Comparison Matrix

| Feature | Glass Edition (Flagship) | Lite Edition | GameDeck Edition | Workstation Edition |
| :--- | :--- | :--- | :--- | :--- |
| **Primary Use** | Laptops & Daily Driver | Low-Spec / Old Hardware | Gaming & Handhelds | Work, Dev & Office |
| **Idle Memory** | ~420 MB | **< 280 MB** | ~500 MB | ~550 MB |
| **Windows App Execution** | Sandbox (`bwrap`) | Lightweight Wine | Proton-Lumin GE + DXVK | Enterprise Prefix Sandbox |
| **UI Aesthetics** | macOS Sonoma Glass | Ultra-Minimal Slate | Cyber HUD / Game Shell | Pro Desktop Layout |
