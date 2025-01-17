{
  pkgs,
  lib,
  config,
  ...
}: {
  systemd.user.services =
    lib.mapVals (ExecStart: {
      Unit.After = ["niri.service"];
      Install.WantedBy = ["niri.service"];
      Service = {
        Type = "simple";
        Restart = lib.mkForce "on-failure";
        inherit ExecStart;
      };
    }) (let
      inherit (config.commands) swaybg waybar kdeconnect-indicator;
    in {
      inherit waybar kdeconnect-indicator;
      swaybg = "${swaybg} -m fill -i ${config.home.homeDirectory}/Pictures/wallpaper";
    });

  home.packages =
    [
      pkgs.qt6.qtwayland
    ]
    ++ lib.attrValues {
      inherit
        (pkgs)
        wayland
        alacritty # in case of non-parsing config
        fuzzel
        ;
    };
  programs.niri.settings = let
    inherit (config.commands) term firefox wpctl wl-paste playerctl swaync-client tor-browser codium thunar main-menu nmtui power anyrun pick-character font-preview pick-wallpaper networkmanager_dmenu cliphist dbus-update-activation-environment wallust btm toggle jit rofi swaylock light wezterm random-wallpaper yy keepassxc-menu;
    sh = cmd: ["sh" "-c" (lib.escape ["\""] cmd)];
  in {
    input = {
      keyboard = {
        xkb = {
          # You can set rules, model, layout, variant and options.
          # For more information, see xkeyboard-config(7).
          layout = "us,workman-p";
          options = "caps:escape";
          # model = "";
          # rules = "";
          # variant = "";
        };
        # You can set the keyboard repeat parameters. The defaults match wlroots and sway.
        # Delay is in milliseconds before the repeat starts. Rate is in characters per second.
        repeat-delay = 600;
        repeat-rate = 25;
        # Niri can remember the keyboard layout globally (the default) or per-window.
        # - "global" - layout change is global for all windows.
        # - "window" - layout is tracked for each window individually.
        track-layout = "global";
      };
      # Next sections include libinput settings.
      # Omitting settings disables them, or leaves them at their default values.
      touchpad = {
        enable = true;
        natural-scroll = true;
        scroll-method = "two-finger";
        accel-speed = 0.2;
        accel-profile = "flat";
        tap = true;
        dwt = false;
        dwtp = false;
        tap-button-map = "left-middle-right";
        click-method = "clickfinger";
      };
      mouse = {
        enable = true;
        natural-scroll = false;
        scroll-method = "on-button-down";
        accel-speed = 0.2;
        accel-profile = "flat";
      };
      trackpoint = {
        enable = true;
        natural-scroll = true;
        accel-speed = 0.2;
        accel-profile = "flat";
      };
      tablet = {
        # Set the name of the output (see below) which the tablet will map to.
        # If this is unset or the output doesn't exist, the tablet maps to one of the
        # existing outputs.
        map-to-output = "eDP-1";
      };
      warp-mouse-to-focus = true;
      focus-follows-mouse.enable = true;
      workspace-auto-back-and-forth = true;

      # By default, niri will take over the power button to make it sleep
      # instead of power off.
      # Uncomment this if you would like to configure the power button elsewhere
      # (i.e. logind.conf).
      power-key-handling.enable = true;
    };

    # # You can configure outputs by their name, which you can find
    # # by running `niri msg outputs` while inside a niri instance.
    # # The built-in laptop monitor is usually called "eDP-1".
    # outputs."eDP-1" = {
    #   enable = true;

    #   # Scale is a floating-point number, but at the moment only integer values work.
    #   scale = 2.0;

    #   transform = {
    #     flipped = false;
    #     # Transform allows to rotate the output counter-clockwise, valid values are:
    #     # 0, 90, 180, 270.
    #     rotation = 0;
    #   };

    #   # Resolution and, optionally, refresh rate of the output.
    #   # The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
    #   # If the refresh rate is omitted, niri will pick the highest refresh rate
    #   # for the resolution.
    #   # If the mode is omitted altogether or is invalid, niri will pick one automatically.
    #   # Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
    #   mode = {
    #     width = 1920;
    #     height = 1080;
    #     refresh = 120.030;
    #   };

    #   variable-refresh-rate = true;

    #   # Position of the output in the global coordinate space.
    #   # This affects directional monitor actions like "focus-monitor-left", and cursor movement.
    #   # The cursor can only move between directly adjacent outputs.
    #   # Output scale has to be taken into account for positioning:
    #   # outputs are sized in logical, or scaled, pixels.
    #   # For example, a 3840*2160 output with scale 2.0 will have a logical size of 1920×1080,
    #   # so to put another output directly adjacent to it on the right, set its x to 1920.
    #   # It the position is unset or results in an overlap, the output is instead placed
    #   # automatically.
    #   position = {
    #     x = 1280;
    #     y = 0;
    #   };
    # };

    layout = {
      # By default focus ring and border are rendered as a solid background rectangle
      # behind windows. That is, they will show up through semitransparent windows.
      # This is because windows using client-side decorations can have an arbitrary shape.
      #
      # If you don't like that, you should uncomment `prefer-no-csd` below.
      # Niri will draw focus ring and border *around* windows that agree to omit their
      # client-side decorations.
      focus-ring = {
        enable = false;
        width = 4;
        # https://css-gradient.com
        active.gradient = {
          from = "#670114";
          to = "#000000";
          angle = 135;
        };
        # inactive-gradient = {};
      };

      # How many logical pixels the border extends. It's similar to the focus ring, but always visible.
      border.width = 4;
      # You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
      preset-column-widths = [
        # Proportion sets the width as a fraction of the output width, taking gaps into account.
        # For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
        # The default preset widths are 1/3, 1/2 and 2/3 of the output.
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}

        # Fixed sets the width in logical pixels exactly.
        # {fixed = 1920;}
      ];
      # You can change the default width of the new windows.
      default-column-width = {
        # If you leave the brackets empty, the windows themselves will decide their initial width.
        # proportion = 1.0 / 2.0;
      };
      # When to center a column when changing focus, options are:
      # - "never", default behavior, focusing an off-screen column will keep at the left
      #   or right edge of the screen.
      # - "on-overflow", focusing a column will center it if it doesn't fit
      #   together with the previously focused column.
      # - "always", the focused column will always be centered.
      center-focused-column = "never";
      # Set gaps around windows in logical pixels.
      gaps = 16.0;
      # Struts shrink the area occupied by windows, similarly to layer-shell panels.
      # You can think of them as a kind of outer gaps. They are set in logical pixels.
      # Left and right struts will cause the next window to the side to always be visible.
      # Top and bottom struts will simply add outer gaps in addition to the area occupied by
      # layer-shell panels and regular gaps.
      struts = {
        left = 64.0;
        right = 64.0;
        # top = 64.0;
        # bottom = 64.0;
      };
    };

    # Enable to ask the clients to omit their client-side decorations if possible.
    # If the client will specifically ask for CSD, the request will be honored.
    # Additionally, clients will be informed that they are tiled, removing some rounded corners.
    prefer-no-csd = true;

    # You can change the path where screenshots are saved.
    # A ~ at the front will be expanded to the home directory.
    # The path is formatted with strftime(3) to give you the screenshot date and time.
    # You can also set this to null to disable saving screenshots to disk.
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    # Settings for the "Important Hotkeys" overlay.
    # Enable if you don't want to see the hotkey help at niri startup.
    hotkey-overlay.skip-at-startup = true;

    environment = {
      # Set a variable like this:
      QT_QPA_PLATFORM = "wayland";

      # Remove a variable by using null as the value:
      DISPLAY = "null";
    };

    binds = let
      # { prefixes.Mod = "focus"; suffixes.Up = "window-up"; } -> { "Mod+Up" = "focus-window-up"; }
      binds = {
        suffixes,
        prefixes,
        substitutions ? {},
      }: let
        replacer = lib.replaceStrings (lib.attrNames substitutions) (lib.attrValues substitutions);
        format = prefix: suffix: {
          name = "${prefix.key}+${suffix.key}";
          value = let
            actual-suffix =
              if lib.isList suffix.action
              then {
                action = lib.head suffix.action;
                args = lib.tail suffix.action;
              }
              else {
                inherit (suffix) action;
                args = [];
              };
          in {
            action.${replacer "${prefix.action}-${actual-suffix.action}"} =
              actual-suffix.args;
          };
        };
        pairs = attrs: fn:
          lib.concatMap (key:
            fn {
              inherit key;
              action = attrs.${key};
            }) (lib.attrNames attrs);
      in
        lib.listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)])));
      substitutions = {
        monitor-column = "monitor";
        monitor-window = "monitor";
      };
      horizontal = {
        # right hand
        Left = "left";
        Right = "right";
        # left hand
        "${config.keyboard.keys.D}" = "left";
        "${config.keyboard.keys.F}" = "right";
      };
      # vertical = {
      #   # right hand
      #   Up = "up";
      #   Down = "down";
      #   # left hand
      #   S = "up";
      #   G = "down";
      # };
      columns = lib.mapVals (x: "column-${x}") horizontal;
      # workspaces = lib.mapVals (x: "workspace-${x}") vertical;
      # windows = lib.mapVals (x: "window-${x}") vertical;
    in
      lib.mapVals (str: {action.spawn = sh str;}) {
        # Keys consist of modifiers separated by + signs, followed by an XKB key name
        # in the end. To find an XKB name for a particular key, you may use a program
        # like wev.
        #
        # "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
        # when running as a winit window.
        #
        # Most actions that you can bind here can also be invoked programmatically with
        # `niri msg action do-something`.
        #
        # Most actions that you can bind here can also be invoked programmatically with
        # `niri msg action do-something`.

        # You can also use a shell:
        # "Mod+T" = ["bash" "-c" "notify-send hello && exec alacritty"];

        "Mod+${
          if config.keyboard.active == "workman"
          then "D"
          else "T"
        }" =
          wezterm;

        # switch wallpaper
        "Mod+M" = random-wallpaper;
        "Shift+Mod+M" = term pick-wallpaper;

        "Mod+W" = "${firefox} --new-window about:newtab";
        "Mod+Shift+W" = tor-browser;
        "Mod+V" = codium;
        "Mod+Shift+E" = "${thunar} Downloads/";
        "Mod+E" = term "${yy} ${config.home.homeDirectory}/Downloads/";
        "Mod+Shift+Ctrl+Alt+Space" = term "${pick-character} ${./emoji.txt}";
        # "Mod+N" = "${systemctl} suspend-then-hibernate";
        "Mod+F3" = term font-preview;
        "Mod+F9" = term main-menu;
        "Mod+I" = term nmtui;
        "Mod+Shift+I" = networkmanager_dmenu;
        "Mod+U" = term power;
        "Mod+Y" = "${keepassxc-menu} -d ~/Nextcloud/keepass.kdbx";
        "Mod+B" = "${anyrun} --plugins libsymbols.so";
        "Ctrl+Alt+Delete" = term btm;
        "Mod+L" = swaylock;
        # "Alt+Space" = "${swaync-client} --close-latest";
        "Mod+Escape" = "${swaync-client} --close-all";
        "Mod+Grave" = "${swaync-client} --toggle-panel";
        "Mod+Space" = "${toggle anyrun} --plugins libapplications.so";
        "Mod+J" = "${toggle anyrun} --plugins libapplications.so";
        "Shift+Mod+Space" = term jit;
        "Alt+Mod+Space" = "${toggle rofi} -show drun -show-icons";
        "Alt+Mod+J" = "${toggle rofi} -show drun -show-icons";
        "Shift+Mod+J" = term jit;
      }
      // lib.mapVals (str: {
        allow-when-locked = true;
        action.spawn = sh str;
      }) {
        # audio
        "Mod+TouchpadScrollDown" = "${wpctl} set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 0.02+";
        "Mod+TouchpadScrollUp" = "${wpctl} set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 0.02-";
        XF86AudioRaiseVolume = "${wpctl} set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+";
        XF86AudioLowerVolume = "${wpctl} set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%-";
        XF86AudioMute = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86AudioMicMute = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        XF86AudioPlay = "${playerctl} play-pause";
        XF86AudioStop = "${playerctl} stop";
        XF86AudioPrev = "${playerctl} previous";
        XF86AudioNext = "${playerctl} next";
        # screen brightness
        XF86MonBrightnessDown = "${light} -U 5";
        XF86MonBrightnessUp = "${light} -A 5";
      }
      // (lib.mapVals (str: {action."${str}" = [];}) {
        "Mod+Q" = "close-window";
        "Alt+F4" = "close-window";
        "Mod+Comma" = "consume-window-into-column";
        "Mod+Period" = "expel-window-from-column";
        "Mod+BracketLeft" = "consume-or-expel-window-left";
        "Mod+BracketRight" = "consume-or-expel-window-right";

        "Mod+R" = "switch-preset-column-width";
        "Mod+A" = "maximize-column";
        "Mod+Shift+A" = "fullscreen-window";
        "F11" = "fullscreen-window";
        "Mod+C" = "center-column";

        # screenshots
        "Print" = "screenshot";
        "Ctrl+Print" = "screenshot-screen";
        "Alt+Print" = "screenshot-window";

        "Mod+Shift+H" = "power-off-monitors";

        # This debug bind will tint all surfaces green, unless they are being
        # directly scanned out. It's therefore useful to check if direct scanout
        # is working.
        # "Mod+Shift+Ctrl+T" = "toggle-debug-tint";

        "Mod+K" = "quit";
        # Mod-/, kinda like Mod-?, shows a list of important hotkeys.
        "Mod+Slash" = "show-hotkey-overlay";
      })
      // (binds {
        prefixes = {
          Mod = "focus-workspace";
          "Mod+Shift" = "move-column-to-workspace";
          "Mod+Alt" = "move-workspace";
        };
        suffixes = {
          # right hand
          Page_Up = "up";
          Page_Down = "down";
          # left hand
          S = "up";
          G = "down";
        };
      })
      // (binds {
        inherit substitutions;
        prefixes = {
          Mod = "focus";
        };
        suffixes = {
          # right hand
          Left = "column-left-or-last";
          Right = "column-right-or-first";
          # left hand
          "${config.keyboard.keys.D}" = "column-left-or-last";
          "${config.keyboard.keys.F}" = "column-right-or-first";
        };
      })
      // (binds {
        inherit substitutions;
        prefixes = {
          "Mod+Shift" = "move"; # alternative: move-column-L/R-or-to-monitor-L/R
        };
        suffixes = columns;
      })
      // (binds {
        inherit substitutions;
        prefixes = {
          Mod = "focus";
          "Mod+Shift" = "move";
        };
        suffixes = {
          # right hand
          Up = "window-up";
          Down = "window-down";
          # left hand
          X = "window-down";
          Z = "window-up";
        };
      })
      // (binds {
        prefixes = {
          "Mod+Alt" = "focus-monitor";
          "Mod+Shift+Alt" = "move-workspace-to-monitor";
        };
        suffixes = horizontal;
      })
      // (binds {
        prefixes = {
          "Mod+Shift+Alt" = "move-workspace";
        };
        suffixes = {
          # right hand
          Left = "up";
          Right = "down";
          # left hand
          S = "up";
          G = "down";
        };
      })
      // (binds {
        prefixes = {
          "Mod+Alt" = "move-column-to-monitor";
        };
        suffixes = {
          # right hand
          Up = "left";
          Down = "right";
          # left hand
          S = "left";
          G = "right";
        };
      })
      // (binds {
        prefixes = {
          Mod = "focus-column";
          "Mod+Shift" = "move-column-to";
          "Mod+Alt" = "move-column-to";
        };
        suffixes = {
          Home = "first";
          End = "last";
        };
      })
      # You can refer to workspaces by index. However, keep in mind that
      # niri is a dynamic workspace system, so these commands are kind of
      # "best effort". Trying to refer to a workspace index bigger than
      # the current workspace count will instead refer to the bottommost
      # (empty) workspace.
      #
      # For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
      # will all refer to the 3rd workspace.
      // (binds {
        suffixes = lib.listToAttrs (lib.lists.map (n: {
          name = toString n;
          value = ["workspace" n];
        }) (lib.range 1 9));
        prefixes = {
          "Mod" = "focus";
          "Mod+Shift" = "move-column-to";
        };
      })
      // (lib.mapVals (cmd: {action = cmd;}) {
        # Finer width adjustments.
        # This command can also:
        # * set width in pixels: "1000"
        # * adjust width in pixels: "-5" or "+5"
        # * set width as a percentage of screen width: "25%"
        # * adjust width as a percentage of screen width: "-10%" or "+10%"
        # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
        # set-column-width "100" will make the column occupy 200 physical screen pixels.
        "Mod+Minus" = {set-column-width = "-10%";};
        "Mod+Equal" = {set-column-width = "+10%";};

        # Finer height adjustments when in column with other windows.
        "Mod+Shift+Minus" = {set-window-height = "-10%";};
        "Mod+Shift+Equal" = {set-window-height = "+10%";};

        # Actions to switch layouts.
        # Note: if you uncomment these, make sure you do NOT have
        # a matching layout switch hotkey configured in xkb options above.
        # Having both at once on the same hotkey will break the switching,
        # since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
        "Mod+Apostrophe" = {switch-layout = "next";};
        "Mod+Shift+Apostrophe" = {switch-layout = "prev";};
      })
      // (lib.mapVals (attrs: let tpl = builtins.elemAt (lib.attrsets.attrsToList attrs) 0; in {action."${tpl.name}" = [];} // tpl.value) {
        "Mod+WheelScrollDown".focus-workspace-down.cooldown-ms = 150;
        "Mod+WheelScrollUp".focus-workspace-up.cooldown-ms = 150;
      });

    # Add lines like this to spawn processes at startup.
    # Note that running niri as a session supports xdg-desktop-autostart,
    # which may be more convenient to use.
    spawn-at-startup = [
      # screen sharing
      {command = sh "${dbus-update-activation-environment} --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";}

      # Lock screen after idling
      # {command = sh "${swayidle} -w timeout 900 '${swaylock} -f'";}

      {command = sh "${wl-paste} --type text --watch ${cliphist} store";} # Stores only text data
      {command = sh "${wl-paste} --type image --watch ${cliphist} store";} # Stores only image data

      {command = sh "${wallust} run `cat ~/.cache/wal/wal`";}
    ];

    # general before specific, get info by `wlrctl window list`
    window-rules = [
      {
        matches = [];
        clip-to-geometry = true;
        geometry-corner-radius = let
          radius = 50.0;
        in {
          top-left = radius;
          top-right = radius;
          bottom-right = radius;
          bottom-left = radius;
        };
      }

      {
        matches = [
          {is-active = true;}
        ];
        opacity = 0.85;
      }

      {
        matches = [
          {is-active = false;}
        ];
        opacity = 0.7;
      }

      {
        matches = [
          {app-id = "wezterm|kitty";}
        ];
        opacity = 0.8;
      }

      {
        matches = [
          {
            app-id = "wezterm|kitty";
            is-active = false;
          }
        ];
        opacity = 0.65;
      }

      {
        matches = [
          {
            app-id = "Xwayland";
          }
        ];
        open-maximized = true;
      }
    ];
  };
}
