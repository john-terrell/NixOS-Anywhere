{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      disko,
      ...
    }:
    {
      # nixos-rebuild uses nixosConfigurations."HOSTNAME"
      nixosConfigurations."xps15" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/xps15/configuration.nix
          ./hosts/xps15/hardware-configuration.nix
        ];
      };

      # nixos-rebuild uses nixosConfigurations."HOSTNAME"
      nixosConfigurations."stor0" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/stor0/configuration.nix
          ./hosts/stor0/hardware-configuration.nix
        ];
      };
    };
}
