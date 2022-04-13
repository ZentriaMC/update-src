{ pkgs }:

let
  inherit (pkgs) lib;

  tracedFetchers = [
    "fetchurl"
    "fetchzip"
    "fetchgit"
    "fetchFromGitHub"
    "fetchFromGitLab"
  ];

  fetchers =
    let
      traceArgs = fn: o: args:
        let
          fnRef = pkgs.${fn};
          ovArgs = lib.attrNames (builtins.intersectAttrs o (lib.functionArgs fnRef.override));
          o' = lib.filterAttrs (n: _: lib.elem n ovArgs) o;
          overridden = fnRef.override o';

          cleanArgs = builtins.removeAttrs args [
            "recursiveHash"
            "downloadToTemp"
            "nativeBuildInputs"
            "postFetch"
            "preFetch"
          ];

          traceFetcher = b: lib.trace "fetcher=${fn}=${builtins.toJSON cleanArgs}" b;
        in
        traceFetcher (overridden args);
    in
    pkgs // (
      let
        traceArgs' = fn: traceArgs fn self;
        self = lib.listToAttrs (map (n: lib.nameValuePair n (traceArgs' n)) tracedFetchers);
      in
      self
    );
in
{
  inherit fetchers;
  callPackage = lib.callPackageWith fetchers;
}
