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

  programs.git.enable = true;

  programs.tmux.enable = true;

  environment.homePackages = with pkgs; [
    jq
  ];
}
