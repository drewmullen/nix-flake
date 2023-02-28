# Setup

1. Install nix

```
$ sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. Install homebrew - prefer not to install via homebrew but some app install/ mgmt is better via homebrew. we will have nix control homebrew packages still

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. Bootstrap nix

```
$ nix --experimental-features "nix-command flakes" build .#darwinConfigurations.<hostname>.system
$ ./result/sw/bin/darwin-rebuild switch --flake ~/.config/nix
```

To get a generic flake template

```
$ nix flake new -t github:nix-community/nix-direnv
```

nix-direnv commands:

```
$ echo "use flake" >> .envrc && direnv allow
```
