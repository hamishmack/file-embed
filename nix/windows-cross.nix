# Test script to cross compile for windows on linux
# and run the test in wine:
#   nix-build nix/windows-cross.nix
{ haskellNixSrc ? builtins.fetchTarball {
    url = "https://github.com/input-output-hk/haskell.nix/archive/aa30155d0501533d7a82e73fa22ccb56e2c58a4b.tar.gz";
    sha256 = "0mkpblzvyc7bhxvi461z43f8bp1bcx9n8jcfkj2ygylsz7ssll5a";
  }
, haskellNix ? import haskellNixSrc {}
, nixpkgs ? haskellNix.sources.nixpkgs-default
, pkgs ? import nixpkgs haskellNix.nixpkgsArgs
, pkgsCross ? import nixpkgs (haskellNix.nixpkgsArgs // {
    system = "x86_64-linux";
    crossSystem = pkgs.lib.systems.examples.mingwW64;
  })
} :
let
  project = pkgsCross.haskell-nix.stackProject {
    src = pkgs.haskell-nix.haskellLib.cleanGit {
      src = ../.;
      name = "file-embed";
    };
  };
in
  pkgsCross.haskell-nix.haskellLib.check
    project.file-embed.components.tests.test

