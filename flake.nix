
{
  description = "Macbook Setup";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Tricked out nvim
    #pwnvim.url = "github:zmre/pwnvim";
  };
  outputs = inputs: {
    darwinConfigurations.dm-mbp =
      inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs { 
          system = "aarch64-darwin"; 
          # allowUnfree had a bug, solution:
          # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
          config.allowUnfree = true;
        };
        modules = [
          ({ pkgs, ... }: {
            # here go the darwin preferences and config items
            programs.zsh.enable = true;
            environment.shells = [ pkgs.bash pkgs.zsh ];
            environment.loginShell = pkgs.zsh;
            environment.systemPackages = [ pkgs.coreutils ];
            environment.systemPath = [ "/opt/homebrew/bin" ];
            environment.pathsToLink = [ "/Applications" ];
            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToEscape = true;
            fonts.fontDir.enable = true; # DANGER
            fonts.fonts =
              [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
            services.nix-daemon.enable = true;
            system.defaults.finder.AppleShowAllExtensions = true;
            system.defaults.finder._FXShowPosixPathInTitle = true;
            system.defaults.dock.autohide = true;
            system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
            system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
            system.defaults.NSGlobalDomain.KeyRepeat = 1;
            # the _correct_ scroll setting
            system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
            # backwards compat; don't change
            system.stateVersion = 4;
            homebrew = {
              enable = true;
              caskArgs.no_quarantine = true;
              global.brewfile = true;
              masApps = { };
              casks = [ "raycast" "amethyst" ];
              taps = [ "fujiapple852/trippy" ];
              brews = [ "trippy" ];
            };
          })
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.dm.imports = [
                ({ pkgs, ... }: {
                  # Don't change this when you change package input. Leave it alone.
                  home.stateVersion = "22.11";
                  # specify my home-manager configs
                  home.packages = [
                    pkgs.ripgrep
                    pkgs.fd
                    pkgs.curl
                    pkgs.less
                    # inputs.pwnvim.packages."aarch64-darwin".default
                  ];
                  home.sessionVariables = {
                    PAGER = "less";
                    CLICLOLOR = 1;
                    EDITOR = "nvim";
                  };
                  programs.vscode.enable = true;
                  programs.bat.enable = true;
                  programs.bat.config.theme = "TwoDark";
                  programs.fzf.enable = true;
                  programs.fzf.enableZshIntegration = true;
                  programs.exa.enable = true;
                  programs.git.enable = true;
                  programs.zsh.enable = true;
                  programs.zsh.enableCompletion = true;
                  programs.zsh.enableAutosuggestions = true;
                  programs.zsh.enableSyntaxHighlighting = true;
                  programs.zsh.shellAliases = { ls = "ls --color=auto -F"; };
                  programs.starship.enable = true;
                  programs.starship.enableZshIntegration = true;
                  programs.alacritty = {
                    enable = true;
                    settings.font.normal.family = "MesloLGS Nerd Font Mono";
                    settings.font.size = 16;
                  };
                  programs.direnv = {
                    enable = true;
                    nix-direnv.enable = true;
                  };
                  home.file.".inputrc".text = ''
                    set show-all-if-ambiguous on
                    set completion-ignore-case on
                    set mark-directories on
                    set mark-symlinked-directories on
                    set match-hidden-files off
                    set visible-stats on
                    set keymap vi
                    set editing-mode vi-insert
                  '';
                })
              ];
            };
          }
        ];
      };
  };
}
