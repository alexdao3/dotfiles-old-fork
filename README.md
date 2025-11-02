# Alex's Dotfiles

Personal dotfiles managed with [Home Manager](https://github.com/nix-community/home-manager).

## Setup

### Prerequisites

Install Nix with flakes enabled:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Installation

1. Clone this repo:
```bash
git clone <your-repo-url> ~/dotfiles
```

2. Create symlink for Home Manager config:
```bash
ln -s ~/dotfiles/home-manager ~/.config/home-manager
```

3. Apply Home Manager configuration:
```bash
nix run home-manager/master -- switch --flake ~/.config/home-manager#alex
```

## What's Included

- **SketchyBar**: macOS status bar with Catppuccin Macchiato theme
  - AeroSpace workspace indicators
  - Weather (Lisbon)
  - Front app display
  - System monitor (CPU/RAM)
  - Battery, volume, clock

- **AeroSpace**: i3-like tiling window manager for macOS

- **Fonts**: JetBrainsMono Nerd Font (for icons)

## Updating

To update your configuration after making changes:
```bash
home-manager switch --flake ~/.config/home-manager#alex
```

## Structure

```
~/dotfiles/
├── home-manager/     # Home Manager configuration
│   ├── flake.nix
│   └── home.nix
├── sketchybar/       # SketchyBar config
│   ├── sketchybarrc
│   ├── colors-catppuccin.sh
│   └── plugins/
└── aerospace/        # AeroSpace config
    └── aerospace.toml
```
