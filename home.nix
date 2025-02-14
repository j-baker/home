{
  pkgs,
  lib,
  username,
  homeDirectory,
  email ? "j.baker@outlook.com",
  sshPubKey,
  headless,
  ...
}:
let linux = pkgs.stdenv.isLinux;
in {
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
      user.signingkey = sshPubKey;
      gpg.format = "ssh";

      commit.gpgsign = true;

      pull = {
        rebase = true;
      };

      gpg.ssh.program = if linux then "${pkgs._1password-gui}/share/1password/op-ssh-sign" else "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };

  gtk.enable = linux && !headless;
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };
  gtk.gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    plugins.trouble = {
      enable = true;
    };
    plugins.web-devicons = {
      enable = true;
    };
    plugins.lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        bashls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
        };
      };
    };
    plugins.telescope = {
      enable = true;
    };
  };

  programs.tmux.enable = true;

  programs.swaylock = {
    enable = linux && !headless;
    settings = {
      image = "${./background.jpg}";
    };
  };
  services.swayidle = {
    enable = linux && !headless;

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
  services.swayosd.enable = linux && !headless;
  programs.waybar.enable = linux && !headless;

  programs.ssh = {
    enable = !headless;
    matchBlocks = {
      "homelab.jbaker.io" = {
        forwardAgent = true;
      };
    };
    extraConfig = if linux then ''
      IdentityAgent "~/.1password/agent.sock"
    '' else ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  home.packages = with pkgs; [
    jq
    htop
  ] ++ lib.optionals (linux && !headless) [
    nwg-launchers
    swaybg
  ];

  wayland.windowManager.sway = {
    enable = linux && !headless;
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
