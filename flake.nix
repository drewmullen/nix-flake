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
    # darwin utilities (darwin-rebuild, etc) looks for `darwinConfigurations namespace
    darwinConfigurations.dm-mbp = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs {
        system = "aarch64-darwin";
        # allowUnfree for vscode
        config.allowUnfree = true;
      };
      # modules is the inputs to darwin system for configuration parameters
      modules = [
        # darwin preferences and configuration
        ./modules/darwin
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.dm.imports = [ ./modules/home-manager ];
          };
          users.users.dm.home = "/Users/dm";
        }
      ];
    };
  };
}
