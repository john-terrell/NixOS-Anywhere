xps15:
	nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/xps15/hardware-configuration.nix --flake .#xps15 --target-host nixos@xps15 --build-on-remote

stor0:
	nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hosts/stor0/hardware-configuration.nix --flake .#stor0 --target-host nixos@stor0 --build-on-remote
