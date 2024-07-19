{ config, pkgs, lib, inputs, userSettings, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };


  # we need the new kernel, right? :)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-b350adf5-976c-4a6e-8500-2cc84d73e24d".device = "/dev/disk/by-uuid/b350adf5-976c-4a6e-8500-2cc84d73e24d";
  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };


  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk  
    ];
    config.common.default = "*";
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "adaptive";
  };

  services.greetd = lib.mkIf (userSettings.wm == "hyprland") {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format \"%d. %b %Y %H:%M:%S\" --asterisks --user-menu --remember --remember-session --sessions ${config.programs.hyprland.package}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Configure console keymap
  console = {
    useXkbConfig = true;
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  };

  # Sound
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-ldac" = true;
        };
      };
    };
  };
  
  hardware.bluetooth.enable = true;

  # User Managment
  users.users.jonasfeld = {
    isNormalUser = true;
    description = "Jonas";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    man-pages linux-manual man-pages-posix
    
    powertop
    sbctl
    neovim
    git
    tmux
    wget
    psmisc

    # added by me - do I need this?
    usbutils
    qemu
    quickemu
  ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  # programs.dconf.enable = userSettings.wm == "hyprland";
  services.blueman.enable = userSettings.wm == "hyprland";
  services.gnome.gnome-keyring.enable = userSettings.wm == "hyprland";
  services.upower.enable = userSettings.wm == "hyprland";
  programs.gnome-disks.enable = userSettings.wm == "hyprland";
  services.gvfs.enable = userSettings.wm == "hyprland";
  services.tumbler.enable = userSettings.wm == "hyprland";
  services.gnome.evolution-data-server.enable = userSettings.wm == "hyprland";
  services.gnome.gnome-online-accounts.enable = userSettings.wm == "hyprland";

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    konsole
    oxygen
  ];

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    java.enable = true;
    # steam.enable = true; # not right now :)
  };

  virtualisation.docker = {
    enable = true;
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  programs.kdeconnect = {
    enable = true;
  };

  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [25565];
  };

  # hardware.opentabletdriver.enable = true;

  # hardware.enableAllFirmware = true;
  # Power Management
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
  };
  environment.sessionVariables = { 
    NIXOS_OZONE_WL = "1";
  }; # Force intel-media-driver

  environment.etc.hosts.mode = "0644";

  # nix.optimise = {
  #   automatic = true;
  #   dates = [ "weekly" ];
  # };

  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 14d";
  # };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-trusted-substituters = ["https://hyprland.cachix.org"];
    extra-trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  system.stateVersion = "24.05";

  # Edits
  services.xserver.xkb = {
    layout = "eurkey";
    extraLayouts.eurkey = {
      description = "EurKEY layout - https://eurkey.steffen.bruentjen.eu";
      languages = ["eng"];
      symbolsFile = ./keyboard_eurkey-1.2;
    };
  };

  services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;

  users.defaultUserShell = pkgs.zsh;

  # TODO pam/polkit?
}
