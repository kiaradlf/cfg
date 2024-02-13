{ lib, config, pkgs, inputs, ... }:

with lib;

let cfg = config.toggles.files;
in {
  options.toggles.files.enable = mkEnableOption "files";

  # imports = lib.optionals cfg.enable [
  # ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ## file browser
      gnome.nautilus
      baobab

      ## file handling / metadata
      xdg-utils

      ## compression
      zip
      unzip
      zlib
      unrar-free

      ## file sharing
      nextcloud-client

      # security
      gnome.seahorse
    ];

    services.syncthing.enable = true;

    # configure nautilus-open-any-terminal
    dconf.settings = {
      "com/github/stunkymonkey/nautilus-open-any-terminal" = {
        terminal = "wezterm";
      };
    };

    programs.pistol = {
      enable = true;
      associations = [
        {
          mime = "application/json";
          command = "bat %pistol-filename%";
        }
        {
          mime = "application/*";
          command = "hexyl %pistol-filename%";
        }
        {
          fpath = ".*.md$";
          command =
            "sh: bat --paging=never --color=always %pistol-filename% | head -8";
        }
      ];
    };

    programs.lf = {
      enable = true;
      settings = {
        number = true;
        ratios = [ 1 1 2 ];
        tabstop = 4;
      };
      extraConfig = ''
        set previewer ~/.config/lf/lf_kitty_preview
        set cleaner ~/.config/lf/lf_kitty_clean
      '';
      commands = {
        get-mime-type = ''%xdg-mime query filetype "$f"'';
        open = "$$OPENER $f";
      };
      keybindings = {
        D = "trash";
        U = "!du -sh";
        gh = "cd ~";
        i = "$less $f";
      };
      cmdKeybindings = { "<c-g>" = "cmd-escape"; };
      previewer = {
        # Key to bind to the script at `previewer.source` and pipe through less. Setting to null will not bind any key.
        keybinding = "i";
        # Script or executable to use to preview files. Sets lf's `previewer` option.
        source = pkgs.writeShellScript "pv.sh" ''
          #!/bin/sh

          case "$1" in
              *.tar*) tar tf "$1";;
              *.zip) unzip -l "$1";;
              *.rar) unrar l "$1";;
              *.7z) 7z l "$1";;
              *.pdf) pdftotext "$1" -;;
              *) highlight -O ansi "$1" || cat "$1";;
          esac
        '';
      };
    };

  };
}
