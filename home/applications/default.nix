{ pkgs, inputs, ... }:

{
  imports = [ 
    # ./alacritty
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./kitty
    # ./librewolf.nix
    ./neovim
    # ./obs-studio.nix
    ./shell
    ./ssh.nix
    # ./thunderbird.nix
    # ./vim.nix
    ./vscode.nix
    ./yazi.nix
    ./zellij.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # dev
    ollama
    bear
    gdb
    nodejs
    gh
    android-studio
    cmake
    cargo
    rustc
    vscodium
    beekeeper-studio

    # user programs
    anki-bin
    prismlauncher
    btop
    inkscape
    gimp
    libqalculate
    obsidian
    wl-clipboard
    # nixln-edit
    spotify
    spotify-tray

    # etc
    copyq
    tree
    unzip
    zoxide

    # messengers
    element-desktop
    telegram-desktop
    # vesktop
    zoom-us
    signal-desktop
    whatsapp-for-linux
    mattermost-desktop

    # essentials
    firefox
    thunderbird
    keepassxc
    onedrive

    texlive.combined.scheme-full

    # work related
    google-chrome
    slack

    # uni
    calibre
    eduvpn-client
  ];

  programs.zathura.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  services.kdeconnect.enable = true;
  services.kdeconnect.indicator = true;

  services.playerctld.enable = true;

  home.file.".gdbinit".text = ''
    source ${inputs.gdb-ptrfind}/ptrfind.py
  '';
}
