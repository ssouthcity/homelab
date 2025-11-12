{
  description = "Development flake for homelab project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let 
      eachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
    in 
    {
      devShell = eachSystem (system:
          let 
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in 
          pkgs.mkShell {
            packages = [ 
              pkgs.age
              pkgs.fluxcd
              pkgs.k9s
              pkgs.kubectl
              pkgs.kubernetes-helm
              pkgs.sops
              pkgs.talosctl
            ];
          }
      );
    };
}
