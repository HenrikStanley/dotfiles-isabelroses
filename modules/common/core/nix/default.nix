{
  config,
  pkgs,
  lib,
  inputs,
  inputs',
  ...
}:
with lib; {
  system = {
    autoUpgrade.enable = false;
    stateVersion = lib.mkDefault "23.05";
  };

  environment = {
    # we need git for flakes, don't we
    systemPackages = [pkgs.git];
  };

  nixpkgs = {
    config = {
      allowUnfree = true; # really a pain in the ass to deal with when disabled
      allowBroken = false;
      allowUnsupportedSystem = true;
      permittedInsecurePackages = [];
    };

    overlays = with inputs; [
      rust-overlay.overlays.default

      (final: prev: {
        nur = import nur {
          nurpkgs = prev;
          pkgs = prev;
          repoOverrides = {
            bella = inputs'.bella-nur.packages;
          };
        };
      })
    ];
  };

  # faster rebuilding
  documentation = {
    doc.enable = false;
    nixos.enable = false;
    info.enable = false;
    man = {
      enable = lib.mkDefault true;
      generateCaches = lib.mkDefault true;
    };
  };

  nix = {
    # Make builds run with low priority so my system stays responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    # set up garbage collection to run daily,
    # removing unused packages after three days
    gc = {
      automatic = true;
      dates = "Mon *-*-* 03:00";
      options = "--delete-older-than 3d";
    };

    # automatically optimize nix store my removing hard links
    # do it after the gc
    optimise = {
      automatic = true;
      dates = ["04:00"];
    };

    settings = {
      # specify the path to the nix registry
      flake-registry = "/etc/nix/registry.json";
      # Free up to 20GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 thrice
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (20 * 1024 * 1024 * 1024)}";
      # automatically optimise symlinks
      auto-optimise-store = true;
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel"];
      # only allow sudo users to manage the nix store
      trusted-users = ["@wheel"];
      # let the system decide the number of max jobs
      max-jobs = "auto";
      # build inside sandboxed environments
      sandbox = true;
      # supported system features
      # TODO: "gccarch-core2" "gccarch-haswell"
      system-features = ["nixos-tests" "kvm" "recursive-nix" "big-parallel"];
      # extra architectures supported by my builders
      extra-platforms = config.boot.binfmt.emulatedSystems;
      # continue building derivations if one fails
      keep-going = true;
      # show more log lines for failed builds
      log-lines = 30;
      # enable new nix command and flakes
      # and also "unintended" recursion as well as content addresssed nix
      extra-experimental-features = [
        "flakes"
        "nix-command"
        "recursive-nix"
        "ca-derivations"
      ];
      # don't warn me that my git tree is dirty, I know
      warn-dirty = false;
      # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
      http-connections = 50;
      # whether to accept nix configuration from a flake without prompting
      accept-flake-config = true;

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # substituters to use
      substituters = [
        "https://cache.ngi0.nixos.org" # content addressed nix cache (TODO)
        "https://cache.nixos.org" # funny binary cache
        "https://cache.privatevoid.net" # for nix-super
        "https://nixpkgs-wayland.cachix.org" # automated builds of *some* wayland packages
        "https://nix-community.cachix.org" # nix-community cache
        "https://hyprland.cachix.org" # hyprland
        "https://nix-gaming.cachix.org" # nix-gaming
        "https://nixpkgs-unfree.cachix.org" # unfree-package cache
        "https://numtide.cachix.org" # another unfree package cache
        "https://isabelroses.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "isabelroses.cachix.org-1:mXdV/CMcPDaiTmkQ7/4+MzChpOe6Cb97njKmBQQmLPM="
      ];
    };
  };
}
