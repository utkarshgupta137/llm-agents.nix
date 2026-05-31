{
  lib,
  buildGoModule,
  fetchFromGitHub,
  flake,
  go_1_26,
  unpinGoModVersionHook,
  versionCheckHook,
  versionCheckHomeHook,
}:

(buildGoModule.override { go = go_1_26; }) rec {
  pname = "entire";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "entireio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-yGutKLwdTuGamZMdkqHlhBypZFuY9jM0w/1VW6ACppg=";
  };

  nativeBuildInputs = [ unpinGoModVersionHook ];

  vendorHash = "sha256-pIIrrbp3x15iiY3CuA+wU7315bHUSjvJWBa4Q58OorU=";

  subPackages = [ "./cmd/entire" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/entireio/cli/cmd/entire/cli/versioninfo.Version=${version}"
  ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    versionCheckHomeHook
  ];
  versionCheckProgramArg = [ "version" ];

  passthru.category = "Usage Analytics";

  meta = with lib; {
    description = "CLI tool that captures AI agent sessions and links them to code changes";
    homepage = "https://github.com/entireio/cli";
    changelog = "https://github.com/entireio/cli/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ yutakobayashidev ];
    mainProgram = "entire";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
