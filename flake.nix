{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system};
      let
        hl = haskell.lib;
        hsPkgs = haskell.packages.ghc96;

        hsPkgsFn = p:
          with p; [
            HsOpenSSL
            HsOpenSSL-x509-system
            aeson
            base-compat
            base16-bytestring
            binary-instances
            bytestring
            cryptohash-sha1
            deepseq-generics
            hashable
            hspec
            hspec-discover_2_11_7
            http-client
            http-client-openssl
            http-link-header
            http-types
            iso8601-time
            mtl
            network-uri
            tagged
            text
            transformers-compat
            unordered-containers
            vector
          ];
      in {
        devShells.default = mkShell {
          buildInputs = with hsPkgs; [
            (ghcWithPackages hsPkgsFn)
            cabal-fmt
            cabal-install
            haskell-language-server
            hlint
          ];
        };
      });

  nixConfig = {
    extra-substituters = [ "https://magthe-dev.cachix.org" ];
    extra-trusted-public-keys = [
      "magthe-dev.cachix.org-1:mFSHoML7X60LmeIf+vvmuG6uBHdufg8kcUkcfSV3yHc="
    ];
  };
}
