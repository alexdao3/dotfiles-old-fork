{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "alex";
  home.homeDirectory = "/Users/alex";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Fonts - JetBrainsMono Nerd Font for SketchyBar icons
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # SketchyBar configuration
  home.file.".config/sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/sketchybar";
    recursive = true;
  };

  # Aerospace configuration
  home.file.".config/aerospace/aerospace.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/aerospace/aerospace.toml";
  };

  # Ghostty configuration
  home.file.".config/ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ghostty";
    recursive = true;
  };
}
