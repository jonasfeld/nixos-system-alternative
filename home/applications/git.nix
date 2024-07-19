{ ... }:

{
  programs.git = {
    enable = true;
    # userName = "jonasfeld";
    # userEmail = "";
    # extraConfig = {
    #   commit.gpgsign = true;
    #   pull.ff = "only";
    # };
  };

  programs.gh.enable = true;
  home.file = {
    ".gitconfig".source = ../../dots/git/.gitconfig;
  };
}
