# NovaSector 开发 shell：覆盖 DM 构建、TGUI 前端、以及全量汉化 (i18n) 工具链所需的一切。
#
#   nix develop
#
# 之后 `tools/build/build.sh`、`bun run tgui:*`、以及 `cargo`（用于 tools/i18n 抽取工具）
# 均可直接使用；DreamMaker / DreamDaemon 也在 PATH 上。
{
  mkShell,
  rust-bin,
  bun,
  nodejs_22,
  python311,
  git,
  pkg-config,
  openssl,
  unzip,
  curl,
  zlib,
  libjpeg,
  byond,
  rust-g,
}:

let
  # 建 tools/i18n 抽取工具，并可选地从源码编译 rust_g / dreamluau。
  rust = rust-bin.stable.latest.default.override {
    extensions = [
      "rust-src"
      "clippy"
      "rustfmt"
    ];
  };
in
mkShell {
  packages = [
    rust
    bun
    nodejs_22
    python311
    git
    pkg-config
    openssl
    unzip
    curl
    byond
  ];

  # 上游 2026-07 新增的 behavior-tree-compiler target 走 tools/bootstrap/python，会在 venv 里
  # 用 pip **从源码编译** requirements.txt 的 Pillow（无 manylinux wheel 可用时）——那需要
  # zlib / libjpeg 的头文件。放 buildInputs（而非 packages）才会带上 NIX_CFLAGS_COMPILE，
  # 否则 pip 报 "The headers or library files could not be found for jpeg"。
  buildInputs = [
    zlib
    libjpeg
  ];

  # tools/build/lib/byond.ts 在 Linux 上回退到 PATH 上的裸命令即可；这里再显式指一份
  # DM_EXE 作为兜底，避免命名版本文件干扰。
  DM_EXE = "${byond}/bin/DreamMaker";
  BYOND_SYSTEM = byond.passthru.home;

  shellHook = ''
    # rust-g 原生库：detect 逻辑优先找仓库根的 ./librust_g.so（见 code/__DEFINES/rust_g.dm）。
    # 软链到 Nix 里 autoPatchelf 过的版本（已 .gitignore: /*.so）。否则服务端启动会因 rust_g
    # 加载失败而卡住。
    if [ -f flake.nix ] && [ -d code ]; then
      ln -sf ${rust-g}/lib/librust_g.so ./librust_g.so
    fi
    echo "NovaSector dev shell — DM/TGUI + i18n 工具链已就绪"
    echo "  DreamMaker : $(command -v DreamMaker || echo '未找到')"
    echo "  bun        : $(bun --version 2>/dev/null || echo '未找到')"
    echo "  cargo      : $(cargo --version 2>/dev/null || echo '未找到')"
    echo "  librust_g  : $(readlink -f librust_g.so 2>/dev/null || echo '未链接')"
  '';
}
