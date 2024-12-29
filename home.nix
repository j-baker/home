{ pkgs, username, homeDirectory, email ? "j.baker@outlook.com", ... }:
{
    home.username = username;
    home.userEmail = userEmail;
  home.stateVersion = "24.11";

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
    userEmail = email;
    lfs.enable = true;

    extraConfig = {
      pull = {
        rebase = true;
      };
      rerere.enabled = true;
    };
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.tmux.enable = true;

  home.packages = with pkgs; [
    jq
    htop
  ];
}
