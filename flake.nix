{
  description = "Personal NixOS flake (mostly yoinked)";

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      userSettings = {
        catppuccin-flavour = "macchiato"; # vim theme
        colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
        default-font = "JetBrainsMono Nerd Font";
        lockscreen = builtins.toString ./etc/lockscreen.png;
        wallpaper = builtins.toString ./etc/wallpaper.jpg;
        wm = "hyprland";
      };
      overlays = { nixpkgs.overlays = [ inputs.nixpkgs-overlay.overlays.default ]; };
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
          specialArgs = {
            inherit inputs;
            inherit userSettings;
          };
        };
      };
      homeConfigurations = {
        jonasfeld = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            overlays
            ./home
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit userSettings;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-overlay = {
      url = "github:nlintn/nixpkgs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      submodules = true;
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    
    gdb-ptrfind = {
      url = "github:ChaChaNop-Slide/ptrfind";
      flake = false;
    };
  };

  nixConfig = {
    substituters = [ "https://cache.nixos.org/" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    extra-trusted-substituters = [ "https://hyprland.cachix.org" ]; 
    extra-trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
