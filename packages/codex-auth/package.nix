{
  lib,
  stdenv,
  flake,
  fetchFromGitHub,
  zig_0_15,
  makeWrapper,
  nodejs,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "codex-auth";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "loongphy";
    repo = "codex-auth";
    tag = "v${version}";
    hash = "sha256-J1aq5ieWkHqze4HF/7Lw+VIa+FxO7vmsXaDJc7VH+Wk=";
  };

  # Upstream v0.2.8 does not compile with nixpkgs' default zig 0.16.0.
  # Pin zig_0_15 to package the latest stable release without carrying a
  # source compatibility patch.
  nativeBuildInputs = [
    zig_0_15
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-global-cache"
    export ZIG_LOCAL_CACHE_DIR="$PWD/.zig-cache"
    mkdir -p "$ZIG_GLOBAL_CACHE_DIR" "$ZIG_LOCAL_CACHE_DIR"

    zig build -Doptimize=ReleaseSafe

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 zig-out/bin/codex-auth $out/bin/codex-auth

    wrapProgram $out/bin/codex-auth \
      --set CODEX_AUTH_NODE_EXECUTABLE ${lib.getExe nodejs}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru.category = "Utilities";

  meta = with lib; {
    description = "CLI tool for switching Codex accounts";
    homepage = "https://github.com/loongphy/codex-auth";
    changelog = "https://github.com/loongphy/codex-auth/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ xbpk3t ];
    mainProgram = "codex-auth";
    platforms = platforms.unix;
  };
}
