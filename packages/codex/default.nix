{
  pkgs,
  ...
}@args:
pkgs.callPackage ./package.nix (
  {
    mkRustyV8Archive = pkgs.callPackage ../../lib/rusty-v8.nix { };
  }
  # `src` collides with the deprecated `pkgs.src` alias, which throws when
  # callPackage autofills it. Provide an explicit null default so package.nix
  # falls back to its own fetchFromGitHub unless a caller overrides it.
  // {
    src = null;
  }
  // builtins.removeAttrs args [ "pkgs" ]
)
