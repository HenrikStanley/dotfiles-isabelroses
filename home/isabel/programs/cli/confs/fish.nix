{osConfig, ...}: let
  sys = osConfig.modules.system;
in {
  programs.fish = {
    enable = true;
    catppuccin.enable = true;
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";

      # ls to exa
      ls = "exa -al --color=always --icons --group-directories-first";
      la = "exa -a --color=always --icons --group-directories-first";
      ll = "exa -abghHliS --icons --group-directories-first";
      lt = "exa -aT --color=always --icons --group-directories-first";

      # confirm
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      ln = "ln -i";

      mkidr = "mkdir -pv"; # always create pearent directory
      df = "df -h"; # human readblity
      rs = "sudo reboot";
      sysctl = "sudo systemctl";
      doas = "doas --";
      jctl = "journalctl -p 3 -xb"; # get error messages from journalctl
      lg = "lazygit";

      # nix stuff
      ssp = "~/shells/spawnshell.sh";
      rebuild = "sudo nixos-rebuild switch --flake ${sys.flakePath}#${sys.hostname}";
      nixclean = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
      nixrepair = "nix-store --verify --check-contents --repair";
    };
    shellInit = ''
      starship init fish | source
      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
      set TERM "xterm-256color"
      set fish_greeting
      set TERMINAL "alacritty"
      export "MICRO_TRUECOLOR=1"
      export GPG_TTY=$(tty)
    '';
  };
}