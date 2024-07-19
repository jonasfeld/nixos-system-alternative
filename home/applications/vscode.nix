{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.vscode-pull-request-github
      vscodevim.vim
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      kamadorueda.alejandra
      bbenoist.nix
      eamodio.gitlens
      esbenp.prettier-vscode
    ];
  };
}
