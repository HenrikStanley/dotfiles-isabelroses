{
  imports = [
    ./gaming # super cool procrastinations related things
    ./hardware # hardware - bluetooth etc.
    ./options # options, for quick configuration
    ./os # system configurations
    ./nix # nix settings for nixos only systems
    ./security # keeping the system safe
    ./services # allows for per-system system services to be enabled
    ./themes # themes for the system

    ./emulation.nix # emulation setup
    ./encryption.nix # keeping my stuff hidden from you strange people
    ./virtualization.nix # docker, QEMU, waydroid etc.
  ];
}
