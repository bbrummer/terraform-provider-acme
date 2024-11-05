{
  description = "terraform-provider-acme: project development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      defaultForEachSupportedSystem = (func:
        nixpkgs.lib.genAttrs supportedSystems (system: {
          default = func system;
        })
      );
    in
    {
      devShells = defaultForEachSupportedSystem
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
            };
          in
          pkgs.mkShell {
            packages = with pkgs; [
              buf
              go
              golangci-lint
              golangci-lint-langserver
              gopls
              protoc-gen-go
              protoc-gen-go-grpc
              gotestsum
              goreleaser
            ];

            shellHook = ''
              export PATH="$HOME/go/bin:$PATH"
            '';
          }
        );
    };
}
