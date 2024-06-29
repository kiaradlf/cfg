#!/usr/bin/env -S nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#git nixpkgs#jaq --command sh
set -xe

# script for `git bisect` for pinpointing regressions in flake inputs, see:
# https://gist.github.com/KiaraGrouwstra/70bf11002032b3c265512f4e17607631
# to be run from dep's perspective after: `git bisect $BAD $GOOD`
export DEPENDENCY_INPUT=$1 # e.g. niri-src
export DEPENDENCY_URL=$2   # e.g. https://github.com/nixos/nixpkgs
export SYSTEM_REPO=$3      # e.g. /etc/nixos

LOCK_FILE=$SYSTEM_REPO/flake.lock
CURRENT_COMMIT=$(jaq -r ".nodes[\"${DEPENDENCY_INPUT}\"].locked.rev" $LOCK_FILE)
TARGET_COMMIT=$(git rev-parse HEAD)
sed -E -i "s/$CURRENT_COMMIT/$TARGET_COMMIT/g" $LOCK_FILE
CURRENT_HASH=$(jaq -r ".nodes[\"${DEPENDENCY_INPUT}\"].locked.narHash" $LOCK_FILE)
TARGET_HASH=$(nix-hash --to-sri --type sha256 $(nix-prefetch-url --unpack "${DEPENDENCY_URL}/archive/${TARGET_COMMIT}.zip" --type sha256))
export DEPENDENCY_PATH=$PWD
cd $SYSTEM_REPO
sudo nixos-rebuild boot --flake .#default
cd $DEPENDENCY_PATH