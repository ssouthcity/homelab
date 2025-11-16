{
  description = "Development flake for homelab project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = { self, nixpkgs, git-hooks, ... }:
    let 
      eachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
    in 
    {
      formatter = eachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          config = self.checks.${system}.pre-commit.config;
          inherit (config) package configFile;
          script = ''
            ${pkgs.lib.getExe package} run --all-files --config ${configFile}
          '';
        in
        pkgs.writeShellScriptBin "pre-commit-run" script
      );

      checks = eachSystem (system: {
        pre-commit = git-hooks.lib.${system}.run {
          src = ./.; 
          hooks = {
            yamlfmt = {
              enable = true;
              settings.lint-only = false;
            };

            sops = {
              enable = true;
              name = "Ensure SOPS";
              files = "\\.enc\\.(yml|yaml)$";
              entry = "scripts/sops.sh";
              language = "script";
            };
          };
        };
      });

      devShell = eachSystem (system:
          let 
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            inherit (self.checks.${system}.pre-commit) shellHook enabledPackages;
          in 
          pkgs.mkShell {
            inherit shellHook;
            buildInputs = enabledPackages;
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
