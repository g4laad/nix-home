{ config, pkgs, ... }:

{
  home = {
    username = "user";
    homeDirectory = "/home/user";
    sessionPath = [ "${config.home.homeDirectory}/.local/bin" "${config.home.homeDirectory}/.cargo/bin" ];
    packages = [ pkgs.nerd-fonts.jetbrains-mono ];
    # Compatibility baseline: keep this when updating the flake inputs.
    stateVersion = "26.05";
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;

  news.display = "silent";

  # Make the packaged Nerd Font discoverable by terminal applications.
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    mouse = true;
    keyMode = "vi";
    historyLimit = 50000;
    clock24 = true;
    extraConfig = ''
      set -g renumber-windows on
      bind -n S-Left previous-window
      bind -n S-Right next-window
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind c new-window -c "#{pane_current_path}"
    '';
  };

  programs.zsh = {
    enable = true;
    # Manage ~/.zshrc; activation must back up the existing file first.
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    defaultKeymap = "emacs";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 50000;
      save = 50000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    initContent = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*:descriptions' format '%B%d%b'
    '';
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # Keep Starship's default layout with Nerd Font symbols.
    presets = [ "nerd-font-symbols" ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    # Keep Up/Down bound to Zsh history substring search.
    flags = [ "--disable-up-arrow" ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
