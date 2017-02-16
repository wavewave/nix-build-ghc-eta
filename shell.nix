{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  myhaskellpkgs = (callPackage ./top-level/haskell-packages.nix { crossSystem = null; }).packages.lts-6_27; 

   #haskell.packages.lts.override { overrides = config; }; 

  hsenv = myhaskellpkgs.ghcWithPackages (p: with p;
            [ aeson alex array base bytestring Cabal digest blaze-builder extra
              containers cpphs deepseq directory
              exceptions filepath ghc-paths happy haskeline hpc mtl path
              path-io process shake stdenv text time transformers turtle
              unix unix-compat zip

              shake parsec network-uri HTTP
            ]);

in

stdenv.mkDerivation {
  name = "eta-dev";
  buildInputs = [ hsenv jdk ];
}

