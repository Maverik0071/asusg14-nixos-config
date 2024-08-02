{
  description = "Densetsu config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";   
    # OLDER VERSION OF NIXPKGS 
    nixpkgs-another-version.url = "github:nixos/nixpkgs/nixos-24.05";    
    
    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
     
      hyprland.url = "github:hyprwm/Hyprland";
     };

     # nil = "github:oxalica/nil#";

  outputs = { 
  self, 
  nixpkgs, 
  hyprland, 
  home-manager,
  ... 
  }  @inputs: let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    # nix flakes basic config
     nixosConfigurations = {
      asusg14 = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          ]; 
        };
       };
       
     };

     }
