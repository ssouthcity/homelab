{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      eachSystem = nixpkgs.lib.genAttrs systems;
    in 
    {
      packages = eachSystem (system:
        let 
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          topf = pkgs.buildGoModule {
            pname = "topf";
            version = "0.5.0";
            src = pkgs.fetchFromGitHub {
              owner = "postfinance";
              repo = "topf";
              rev = "v0.5.0";
              sha256 = "sha256-W1IES57n8NTcnt9D5iTkrAxnZf4oaz4vm6UBTM96nrc=";
            };
            vendorHash = "sha256-YGDMWx8jLwLcdjIIh82wL2k1yhWo1+GEW0aq47PZbDI=";
            nativeCheckInputs = [
              pkgs.age
              pkgs.sops
              pkgs.vals
            ];
          };
        }
      );

      devShells = eachSystem (system:
        let 
            pkgs = nixpkgs.legacyPackages.${system};
        in
        {
            default = pkgs.mkShell {
            packages = [
              pkgs.age
              pkgs.cosign
              pkgs.fluxcd
              pkgs.fluxcd-operator
              pkgs.fluxcd-operator-mcp
              pkgs.k9s
              pkgs.kind
              pkgs.kubectl
              pkgs.kubernetes-helm
              pkgs.oras
              pkgs.sops
              pkgs.talosctl

              self.packages.${system}.topf
            ];
          };
        }
      );
  };
}
