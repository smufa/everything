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
    
    nixosModules.everything = {pkgs, ...}@args: {
      imports = [ (import ./options.nix { pkgs = pkgs; home = home-manager;}) ];
    };
    
    nixosConfigurations.t460 = nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.everything
        
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

    nixosConfigurations.seymour = nixpkgs.lib.nixosSystem {
      modules = [
        ./seymour/configuration.nix
      
        ({pkgs, ...}: {
          nix.registry.nixpkgs.flake = nixpkgs;
        })

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.enei = import ./lib/home.nix {
            pkgs = builtins.getAttr "x86_64-linux" nixpkgs.legacyPackages;
            hx-theme = "dracula";
          };
          home-manager.users.tina = import ./lib/home_tina.nix {
            pkgs = builtins.getAttr "x86_64-linux" nixpkgs.legacyPackages;
            hx-theme = "dracula";
          };
          home-manager.users.lan= import ./lib/home.nix {
            pkgs = builtins.getAttr "x86_64-linux" nixpkgs.legacyPackages;
            hx-theme = "dracula";
          };


          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    nixosConfigurations.kista = nixpkgs.lib.nixosSystem {
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
