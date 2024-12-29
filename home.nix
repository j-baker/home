{ ... }: {
    programs.fzf.enable = true;

    programs.zsh = {
        enable = true;
        
        oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "agnoster";
        };
    };
}
