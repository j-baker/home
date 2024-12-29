{ pkgs, ... }:
{
  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };
  };

  programs.git = {
    userName = "James Baker";
    userEmail = "j.baker@outlook.com";
    lfs.enable = true;

    extraConfig = {
      pull = {
        rebase = true;
      };
      rerere.enabled = true;
    };
  };

  programs.tmux.enable = true;

  home.packages = with pkgs; [
    jq
    htop
  ];
}
