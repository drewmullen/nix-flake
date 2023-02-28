{ pkgs, ... }: {
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "22.11";
  # specify my home-manager configs
  home.packages = with pkgs; [
    awscli2
    ripgrep
    fd
    curl
    less
    nixfmt
    discord
    # signal-desktop # only available x86
    # steam # only available x86
    # spotify # only available x86
    slack
    # inputs.pwnvim.packages."aarch64-darwin".default
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "vi";
  };
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      golang.go
      hashicorp.terraform
      waderyan.gitblame
      redhat.vscode-yaml
    ];
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings".nil.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];

      "[json]"."editor.defaultFormatter" = "vscode.json-language-features";

      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      "yaml.customTags" = [
        "!And"
        "!And sequence"
        "!If"
        "!If sequence"
        "!Not"
        "!Not sequence"
        "!Equals"
        "!Equals sequence"
        "!Or"
        "!Or sequence"
        "!FindInMap"
        "!FindInMap sequence"
        "!Base64"
        "!Join"
        "!Join sequence"
        "!Cidr"
        "!Ref"
        "!Sub"
        "!Sub sequence"
        "!GetAtt"
        "!GetAZs"
        "!ImportValue"
        "!ImportValue sequence"
        "!Select"
        "!Select sequence"
        "!Split"
        "!Split sequence"
      ];
    };
  };
  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.exa.enable = true;
  programs.git = {
    enable = true;
    userName = "drewmullen";
    userEmail = "mullen.drew@gmail.com";
    extraConfig = {
      pull.rebase = "always";
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      ls = "ls --color=auto -F";
      ll = "ls -la --color=auto -F";
      catt = "/bin/cat";
      cat = "bat";

      ns = "darwin-rebuild switch --flake ~/.config/nix/.#";
      nixupdate = "pushd ~/.config/nix; nix flake update; nixswitch; popd";

      gitamend = "git commit --amend -a --no-edit";
      gs = "git status";
      gb = "git branch -v";
    };
    initExtra = ''
      # ZSH doesnt have a binding for delete key
      bindkey "^[[3~" delete-char         # enable delete key
      bindkey '^[[3;3~' kill-word         # ⌥+delete deletes forward
      bindkey "^[[1;9D" beginning-of-line # cmd+←
      bindkey "^[[1;9C" end-of-line       # cmd+→
      bindkey "\e[1;3D" backward-word     # ⌥←
      bindkey "\e[1;3C" forward-word      # ⌥→
    '';
    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      size = 10000;
    };
  };

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "MesloLGS Nerd Font Mono";
      font.size = 16;
      key_bindings = [
        { # Delete entire line
          key = "Back";
          mods = "Command";
          chars = "\\x15";
        }
        # Could never get these working
        # { # Home
        #   key = "Left";
        #   mods = "Command";
        #   chars = "\\x1bOH";
        #   mode = "AppCursor";
        # }
        # { # End
        #   key = "Right";
        #   mods = "Command";
        #   chars = "\\x1bOF";
        #   mode = "AppCursor";
        # }
      ];
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.file.".inputrc".source = ./dotfiles/inputrc;
}
