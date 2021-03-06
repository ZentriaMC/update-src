{
  description = "catapult";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";

    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    let
      # https://rust-lang.github.io/rustup-components-history/
      rustVersion = "1.58.0";
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rust = pkgs.rust-bin.stable."${rustVersion}".minimal;
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = [
            rust
            pkgs.rust-analyzer
            pkgs.rustfmt

            pkgs.libiconv
            pkgs.darwin.apple_sdk.frameworks.Security
            pkgs.rnix-lsp
          ];
        };
      });
}
