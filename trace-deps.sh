#!/usr/bin/env bash
set -euo pipefail

flake="$(pwd)"
drv="./test.nix"

nix-instantiate --dry-run --arg flakePath "${flake:-null}" --arg drvPath "./test.nix" -E '
{ flakePath, drvPath }:
let
  flake = if flakePath != null then builtins.getFlake (toString flakePath) else null;
  pkgs = import (flake.inputs.nixpkgs or <nixpkgs>) { };
  traced = import ./lib/traced-fetchers.nix { inherit pkgs; };
in
  traced.callPackage drvPath { }
'
