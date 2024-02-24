# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using `nix build .#example` or (legacy) `nix-build -A example`
{
  inputs,
  lib,
  pkgs,
  ...
}: (
  lib.dryFlakes pkgs inputs [
    # "niri"
    "nix-software-center"
    "nixos-conf-editor"
    "nomad-driver-containerd-nix"
    "flare"
    "garn"
  ]
  //
  # non-flakes: import from remaining `pkgs/*.nix` files
  (lib.importRest {inherit pkgs lib inputs;}
    ../pkgs) # i couldn't just do ./ ...
)
