{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager;
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.t460 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./t460/configuration.nix ];
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