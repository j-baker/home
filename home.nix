{
  pkgs,
  username,
  homeDirectory,
  email ? "j.baker@outlook.com",
  ...
}:
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

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
    enable = true;

    userName = "James Baker";
    userEmail = email;
    lfs.enable = true;

    extraConfig = {
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINURXYzuUG9sLdATYSzq8ddSQgIgxxe0R3NjVm3NWF64";
      gpg.format = "ssh";

      commit.gpgsign = true;
      gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";

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
