{
  config,
  pkgs,
  inputs,
  ...
}: 
{
  home.packages = with pkgs; [
    #life
    flatpak
    obsidian
    minecraft
    vscode
    chromium
    dconf
    pavucontrol
    playerctl
    fontconfig
    jellyfin-media-player
    #security
    seatd
    polkit_gnome
    gnupg
    bitwarden
    gnome.gnome-keyring
    gnome.seahorse
    #cli
    networkmanager
    lazygit
    tldr
    bluez
    brightnessctl
    coreutils
    cloudflared
    cifs-utils
    exa
    unzip
    fd
    duf
    jq
    ripgrep
    age
    inputs.catppuccin-toolbox.packages.${pkgs.system}.catwalk
    #extra
    zoom-us
    distrobox
    imagemagick
    gnome.gnome-font-viewer
  ];
} 