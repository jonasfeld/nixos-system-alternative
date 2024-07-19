{ pkgs, config, inputs, userSettings, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default

    ./applications

    ./fonts.nix

    ./wm
  ];

  home.username = "jonasfeld";
  home.homeDirectory = "/home/jonasfeld";

  colorScheme = userSettings.colorScheme;
  
  home.sessionVariables = {
    DOT_DIR = "${config.home.homeDirectory}/dev/projects/nixos-system-alternative";
  };

  systemd.user.startServices = true;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  nix.package = pkgs.nix;
}
