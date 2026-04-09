{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    # Personal systems repo (non-flake) for shared modules
    dgramop-systems = {
      url = "github:dgramop/systems";
      flake = false;
    };

    # Tools
    branch.url = "github:dgramop-specter/branch";
    branch.inputs.nixpkgs.follows = "nixpkgs";

    oncall.url = "github:dgramop-specter/oncall";
    oncall.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, dgramop-systems, branch, oncall }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
    in {
      packages.homeConfigurations."specter" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit dgramop-systems; };
        modules = [ ./home/specter.nix ];
      };

      packages.homeConfigurations."specter-headless" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit dgramop-systems; };
        modules = [ ./home/specter-headless.nix ];
      };
    }) // (let
      overlayer = { ... }: { nixpkgs.overlays = [ self.overlays.default ]; };
    in {
      nixosConfigurations."dev.specter" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit dgramop-systems; };
        modules = [
          overlayer
          ./nixos/machines/dev/specter/configuration.nix
        ];
      };

      overlays.default = (final: prev: {
        dgramop = {
          branch = branch.outputs.defaultPackage.${prev.system};
          oncall = oncall.outputs.defaultPackage.${prev.system};
        };
      });
    });
}
