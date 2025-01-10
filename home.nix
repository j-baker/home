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

  gtk.enable = true;
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };
  gtk.gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.tmux.enable = true;

  programs.swaylock = {
    enable = true;
    settings = {
      image = "${./background.jpg}";
    };
  };
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
    ];

    systemdTarget = "sway-session.target";
  };
  services.swayosd.enable = true;
  programs.waybar.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "homelab.jbaker.io" = {
        forwardAgent = true;
      };
    };
    extraConfig = ''
      IdentityAgent "~/.1password/agent.sock"
    '';
  };

  home.packages = with pkgs; [
    jq
    htop

    nwg-launchers
    swaybg
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    xwayland = true;
    systemd.enable = true;

    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      bars = [ { command = "waybar"; } ];
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty";
    };

    extraConfig = ''
      exec --no-startup-id ${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init
      exec --no-startup-id ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
      exec ${pkgs.wlsunset}/bin/wlsunset -l -0.75 -L 51.51
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next
      output * bg ${./background.jpg} fill
    '';
  };
}
