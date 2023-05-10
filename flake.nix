{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.t460 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
      ./t460/configuration.nix 

      ({ pkgs, ...}: {
        nix.registry.nixpkgs.flake = nixpkgs;
      })

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.enei = import ./lib/home.nix;

        # Optionally, use home-manager.extraSpecialArgs to pass
        # arguments to home.nix
      }
      ];
    };

    nixosConfigurations.malina = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./malina/configuration.nix ];
    };

    nixosConfigurations.kista = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./kista/configuration.nix ];
    };
  };
}