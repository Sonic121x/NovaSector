{
  description = "NovaSector 开发环境：DM/TGUI 构建 + 全量汉化 (i18n) 工具链 + FHS 封装的 BYOND";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # BYOND 仅发布 Linux 构建，且要 buildFHSEnv（Linux-only）封装；故只暴露 x86_64-linux。
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
          # BYOND 是闭源预编译二进制（不可再分发），需要 unfree 许可。
          config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "byond" ];
        };

        byond = pkgs.callPackage ./nix/byond.nix { };
        rust-g = pkgs.callPackage ./nix/rust_g.nix { };
        bun_1_3_5 = pkgs.bun.overrideAttrs (_old: {
          version = "1.3.5";
          src = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.5/bun-linux-x64.zip";
            hash = "sha256-cFHYapJK7+o+C5YhO1/Y95wHk/nK5lNCM+Yn5cPbRmk=";
          };
        });
      in
      {
        packages = {
          inherit byond rust-g;
          default = byond;
        };

        devShells.default = pkgs.callPackage ./nix/devshell.nix {
          inherit byond rust-g;
          bun = bun_1_3_5;
        };
      }
    );
}
