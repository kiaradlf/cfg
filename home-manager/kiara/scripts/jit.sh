#!/usr/bin/env -S nix shell nixpkgs#bash nixpkgs#nix nixpkgs#nix-index nixpkgs#gum github:Mic92/nix-index-database#default --command bash
# https://discourse.nixos.org/t/nixpkgs-desktop/39781/6

set -euo pipefail

APPS=$(nix-locate --minimal --regex '/share/applications/.*\.desktop$' \
	   | sed 's/\.out$//;/(.*)/d' \
	   | sort -u)
SELECTION=$(gum filter --no-limit <<< "$APPS")
# tighten the sandbox to what you need
# $HOME is tmpfs to the app so it puts its trash into a trash can
# bwrap --dev-bind / / \
#       --tmpfs "$HOME" \
      nix run nixpkgs#"$SELECTION"
