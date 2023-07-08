{
  config,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = {
    modules = {
      device = {
        type = "desktop";
        cpu = "intel";
        gpu = "nvidia";
        monitors = ["HDMI-1"];
        hasBluetooth = false;
        hasSound = true;
        keyboard = "us";
      };
      system = {
        username = "isabel";

        boot = {
          loader = "systemd-boot";
          enableKernelTweaks = true;
          enableInitrdTweaks = true;
          loadRecommendedModules = true;
        };

        video.enable = true;
        sound.enable = true;
        bluetooth.enable = false;
        printing.enable = false;

        networking = {
          optimizeTcp = true;
        };

        virtualization = {
          enable = true;
          docker.enable = true;
          qemu.enable = true;
          podman.enable = false;
          distrobox.enable = true;
        };
      };
      usrEnv = {
        isWayland = true;
        desktop = "Hyprland";
        useHomeManager = true;
      };
      programs = {
        git.signingKey = "7F2F6BD6997FCDF7";

        cli.enable = true;
        gui.enable = true;

        default = {
          terminal = "alacritty";
        };
        override = {};
      };
    };

    hardware = {
      nvidia = mkIf (builtins.elem device.gpu ["nvidia" "hybrid-nv"]) {
        nvidiaPersistenced = mkForce false;

        open = mkForce false;

        prime = {
          offload.enable = mkForce true;
          # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
          intelBusId = "PCI:0:2:0";

          # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };

    boot = {
      kernelParams =
        [
          "nohibernate"
        ]
        ++ optionals ((device.cpu == "intel") && (device.gpu != "hybrid-nv")) [
          "i915.enable_fbc=1"
          "i915.enable_psr=2"
        ];
    };

    console.earlySetup = true;
  };
}