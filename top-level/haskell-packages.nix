{ pkgs, callPackage, stdenv, crossSystem }:

rec {

  lib = import ../development/haskell-modules/lib.nix { inherit pkgs; };

  compiler = {

    ghc6102Binary = callPackage ../development/compilers/ghc/6.10.2-binary.nix { gmp = pkgs.gmp4; };
    ghc704Binary = callPackage ../development/compilers/ghc/7.0.4-binary.nix {
      gmp = pkgs.gmp4;
    };
    ghc742Binary = callPackage ../development/compilers/ghc/7.4.2-binary.nix {
      gmp = pkgs.gmp4;
    };

    ghc6104 = callPackage ../development/compilers/ghc/6.10.4.nix { ghc = compiler.ghc6102Binary; };
    ghc6123 = callPackage ../development/compilers/ghc/6.12.3.nix { ghc = compiler.ghc6102Binary; };
    ghc704 = callPackage ../development/compilers/ghc/7.0.4.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc722 = callPackage ../development/compilers/ghc/7.2.2.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc742 = callPackage ../development/compilers/ghc/7.4.2.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc763 = callPackage ../development/compilers/ghc/7.6.3.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc783 = callPackage ../development/compilers/ghc/7.8.3.nix {
      ghc = compiler.ghc742Binary;
    };
    ghc784 = callPackage ../development/compilers/ghc/7.8.4.nix {
      ghc = compiler.ghc742Binary;
    };
    ghc7102 = callPackage ../development/compilers/ghc/7.10.2.nix rec {
      bootPkgs = packages.ghc784;
      inherit (bootPkgs) hscolour;
    };
    ghc7103 = callPackage ../development/compilers/ghc/7.10.3.nix rec {
      bootPkgs = packages.ghc784;
      inherit (bootPkgs) hscolour;
    };
    ghc801 = callPackage ../development/compilers/ghc/8.0.1.nix rec {
      bootPkgs = packages.ghc7103;
      inherit (bootPkgs) hscolour;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix rec {
      bootPkgs = packages.ghc7103;
      inherit (bootPkgs) alex happy;
      inherit crossSystem;
      selfPkgs = packages.ghcHEAD;
    };
    ghcNokinds = callPackage ../development/compilers/ghc/nokinds.nix rec {
      bootPkgs = packages.ghc784;
      inherit (bootPkgs) alex happy;
    };

    ghcjs = packages.ghc7103.callPackage ../development/compilers/ghcjs {
      bootPkgs = packages.ghc7103;
    };
    ghcjsHEAD = packages.ghc801.callPackage ../development/compilers/ghcjs/head.nix {
      bootPkgs = packages.ghc801;
    };

    jhc = callPackage ../development/compilers/jhc {
      inherit (packages.ghc763) ghcWithPackages;
    };

    uhc = callPackage ../development/compilers/uhc/default.nix ({
      stdenv = pkgs.clangStdenv;
      inherit (pkgs.haskellPackages) ghcWithPackages;
    });

  };

  packages = {

    # Support for this compiler is broken, because it can't deal with directory-based package databases.
    # ghc6104 = callPackage ../development/haskell-modules { ghc = compiler.ghc6104; };
    ghc6123 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc6123;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-6.12.x.nix { };
    };
    ghc704 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc704;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.0.x.nix { };
    };
    ghc722 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc722;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.2.x.nix { };
    };
    ghc742 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc742;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.4.x.nix { };
    };
    ghc763 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc763;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.6.x.nix { };
    };
    ghc783 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc783;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.8.x.nix { };
    };
    ghc784 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc784;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.8.x.nix { };
    };
    ghc7102 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7102;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc7103 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7103;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc801 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc801;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    # TODO Support for multiple variants here
    ghcCross = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD.crossCompiler;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcNokinds = callPackage ../development/haskell-modules {
      ghc = compiler.ghcNokinds;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-nokinds.nix { };
    };
    ghcjs = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjs;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcjsHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjsHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

    # These attributes exist only for backwards-compatibility so that we don't break
    # stack's --nix support. These attributes will disappear in the foreseeable
    # future: https://github.com/commercialhaskell/stack/issues/2259.

    lts-6_27 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7103;
      compilerConfig = callPackage ../development/haskell-modules/configuration-lts-6.27.nix { };
    };
    
  };
}
