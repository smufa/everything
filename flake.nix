{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    formatter."x86_64-linux" = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations.t460 = nixpkgs.lib.nixosSystem {
      modules = [
        ./t460/configuration.nix

        ({pkgs, ...}: {
          nix.registry.nixpkgs.flake = nixpkgs;
        })

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.enei = import ./lib/home.nix {
            pkgs = builtins.getAttr "x86_64-linux" nixpkgs.legacyPackages;
            hx-theme = "pop-dark";
          };

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    nixosConfigurations.malina = nixpkgs.lib.nixosSystem {
      hostPlatform = "aarch64-linux";
      modules = [./malina/configuration.nix];
    };

    nixosConfigurations.kista = nixpkgs.lib.nixosSystem {
      hostPlatform = "x86_64-linux";
      modules = [
        ./kista/configuration.nix
        ({pkgs, ...}: {
          nix.registry.nixpkgs.flake = nixpkgs;
        })

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.enei = import ./lib/home.nix {
            pkgs = builtins.getAttr "x86_64-linux" nixpkgs.legacyPackages;
            hx-theme = "catpuccin_frappe";
          };

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };
  };
}
