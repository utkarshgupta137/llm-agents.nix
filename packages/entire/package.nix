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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "entireio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-VfuzYSFgH6cW80SYtkhaNeiNYFAOHbcFX9jdr/rDqSw=";
  };

  nativeBuildInputs = [ unpinGoModVersionHook ];

  vendorHash = "sha256-GhFH/y781RIRZ7+r79Wsw8x0/ZmTnv0g9GHtESn5zSA=";

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

  passthru.category = "Utilities";

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
