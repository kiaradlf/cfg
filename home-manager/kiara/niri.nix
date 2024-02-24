{pkgs, lib, ...}: {
  home.packages = with pkgs; [
    wayland
    qt6.qtwayland
    swaybg
    # in case of non-parsing configs
    alacritty
    fuzzel
  ];
  programs.niri.config = let
    terminal = ''"wezterm" "-e" "--always-new-process"'';
    binds = with lib;
      {
        suffixes,
        prefixes,
        # substitutions ? {},
      }: let
        format = prefix: suffix: "${prefix.key}+${suffix.key} { ${prefix.action}-${suffix.action}; }";
        pairs = attrs: fn:
          concatMap (key:
            fn {
              inherit key;
              action = attrs.${key};
            }) (attrNames attrs);
        list = pairs prefixes (prefix: pairs suffixes (suffix: [(format prefix suffix)]));
        string = concatStringsSep "\n" list;
      in
        # replaceStrings (attrNames substitutions) (attrValues substitutions)
        string;
    in ''
    // This config is in the KDL format: https://kdl.dev
    // "/-" comments out the following node.

    input {
        keyboard {
            xkb {
                // You can set rules, model, layout, variant and options.
                // For more information, see xkeyboard-config(7).
                layout "us,nl"
                options "caps:escape"
            }

            // You can set the keyboard repeat parameters. The defaults match wlroots and sway.
            // Delay is in milliseconds before the repeat starts. Rate is in characters per second.
            // repeat-delay 600
            // repeat-rate 25

            // Niri can remember the keyboard layout globally (the default) or per-window.
            // - "global" - layout change is global for all windows.
            // - "window" - layout is tracked for each window individually.
            // track-layout "global"
        }

        // Next sections include libinput settings.
        // Omitting settings disables them, or leaves them at their default values.
        touchpad {
            tap
            // dwt
            natural-scroll
            // accel-speed 0.2
            // accel-profile "flat"
            // tap-button-map "left-middle-right"
        }

        mouse {
            // natural-scroll
            // accel-speed 0.2
            // accel-profile "flat"
        }

        tablet {
            // Set the name of the output (see below) which the tablet will map to.
            // If this is unset or the output doesn't exist, the tablet maps to one of the
            // existing outputs.
            map-to-output "eDP-1"
        }

        // By default, niri will take over the power button to make it sleep
        // instead of power off.
        // Uncomment this if you would like to configure the power button elsewhere
        // (i.e. logind.conf).
        // disable-power-key-handling
    }

    // You can configure outputs by their name, which you can find
    // by running `niri msg outputs` while inside a niri instance.
    // The built-in laptop monitor is usually called "eDP-1".
    // Remember to uncommend the node by removing "/-"!
    /-output "eDP-1" {
        // Uncomment this line to disable this output.
        // off

        // Scale is a floating-point number, but at the moment only integer values work.
        scale 2.0

        // Transform allows to rotate the output counter-clockwise, valid values are:
        // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
        transform "normal"

        // Resolution and, optionally, refresh rate of the output.
        // The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
        // If the refresh rate is omitted, niri will pick the highest refresh rate
        // for the resolution.
        // If the mode is omitted altogether or is invalid, niri will pick one automatically.
        // Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.    mode "1920x1080@144"

        // Position of the output in the global coordinate space.
        // This affects directional monitor actions like "focus-monitor-left", and cursor movement.
        // The cursor can only move between directly adjacent outputs.
        // Output scale has to be taken into account for positioning:
        // outputs are sized in logical, or scaled, pixels.
        // For example, a 3840*2160 output with scale 2.0 will have a logical size of 1920×1080,
        // so to put another output directly adjacent to it on the right, set its x to 1920.
        // It the position is unset or results in an overlap, the output is instead placed
        // automatically.
        position x=1280 y=0
    }

    layout {
        // You can change how the focus ring looks.
        focus-ring {
            // Uncomment this line to disable the focus ring.
            // off

            // How many logical pixels the ring extends out from the windows.
            width 4

            // Color of the ring on the active monitor: red, green, blue, alpha.
            active-color 239 159 118 238
            // 238 190 190

            // Color of the ring on inactive monitors: red, green, blue, alpha.
            inactive-color 89 89 89 170
        }

        // You can also add a border. It's similar to the focus ring, but always visible.
        border {
            // The settings are the same as for the focus ring.
            // If you enable the border, you probably want to disable the focus ring.
            off

            width 4
            active-color 255 200 127 255
            inactive-color 80 80 80 255
        }

        // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
        preset-column-widths {
            // Proportion sets the width as a fraction of the output width, taking gaps into account.
            // For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
            // The default preset widths are 1/3, 1/2 and 2/3 of the output.
            proportion 0.33333
            proportion 0.5
            proportion 0.66667

            // Fixed sets the width in logical pixels exactly.
            // fixed 1920
        }

        // You can change the default width of the new windows.
        // default-column-width { proportion 0.5; }
        // If you leave the brackets empty, the windows themselves will decide their initial width.
        default-column-width {}

        // Set gaps around windows in logical pixels.
        gaps 16

        // Struts shrink the area occupied by windows, similarly to layer-shell panels.
        // You can think of them as a kind of outer gaps. They are set in logical pixels.
        // Left and right struts will cause the next window to the side to always be visible.
        // Top and bottom struts will simply add outer gaps in addition to the area occupied by
        // layer-shell panels and regular gaps.
        struts {
            left 64
            right 64
            // top 64
            // bottom 64
        }

        // When to center a column when changing focus, options are:
        // - "never", default behavior, focusing an off-screen column will keep at the left
        //   or right edge of the screen.
        // - "on-overflow", focusing a column will center it if it doesn't fit
        //   together with the previously focused column.
        // - "always", the focused column will always be centered.
        center-focused-column "never"
    }

    // Add lines like this to spawn processes at startup.
    // Note that running niri as a session supports xdg-desktop-autostart,
    // which may be more convenient to use.

    spawn-at-startup "swaybg" "-m" "fill" "-i" "/home/kiara/Pictures/wallpaper"
    spawn-at-startup "wallust" "run" "`cat ~/.cache/wal/wal`"

    spawn-at-startup "waybar"

    spawn-at-startup "kdeconnect-cli"

    // screen sharing
    spawn-at-startup "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP"

    // Lock screen after idling
    // spawn-at-startup "swayidle" "-w" "timeout" "900" "'swaylock -f'"

    spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store" // Stores only text data
    spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store" // Stores only image data

    cursor {
        // Change the theme and size of the cursor as well as set the
        // `XCURSOR_THEME` and `XCURSOR_SIZE` env variables.
        // xcursor-theme "default"
        // xcursor-size 24
    }

    // Uncomment this line to ask the clients to omit their client-side decorations if possible.
    // If the client will specifically ask for CSD, the request will be honored.
    // Additionally, clients will be informed that they are tiled, removing some rounded corners.
    // prefer-no-csd

    // You can change the path where screenshots are saved.
    // A ~ at the front will be expanded to the home directory.
    // The path is formatted with strftime(3) to give you the screenshot date and time.
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // You can also set this to null to disable saving screenshots to disk.
    // screenshot-path null

    // Settings for the "Important Hotkeys" overlay.
    hotkey-overlay {
        // Uncomment this line if you don't want to see the hotkey help at niri startup.
        skip-at-startup
    }

    binds {
        // Keys consist of modifiers separated by + signs, followed by an XKB key name
        // in the end. To find an XKB name for a particular key, you may use a program
        // like wev.
        //
        // "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
        // when running as a winit window.
        //
        // Most actions that you can bind here can also be invoked programmatically with
        // `niri msg action do-something`.

        Mod+T { spawn "wezterm"; }

        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "-l" "2.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "-l" "2.0" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioStop { spawn "playerctl" "stop"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86MonBrightnessDown { spawn "light" "-U" "1"; }
        XF86MonBrightnessUp   { spawn "light" "-A" "1"; }

        Mod+Q  { close-window; }
        Alt+F4 { close-window; }

        ${binds {
          prefixes = {
            "Mod+Ctrl" = "focus-monitor";
            "Mod+Shift+Ctrl" = "move-column-to-monitor";
            "Mod+Shift+Ctrl+Alt" = "move-workspace-to-monitor";
          };
          suffixes = {
            # right hand
            Left  = "left";
            Down  = "down";
            Up    = "up";
            Right = "right";
            # left hand
            S     = "left";
            X     = "down";
            Z     = "up";
            D     = "right";
          };
        }}

        ${binds {
          prefixes = {
            "Mod" = "focus";
            "Mod+Shift" = "move";
            "Mod+Alt" = "move";
          };
          suffixes = {
            # right hand
            Left  = "column-left";
            Down  = "window-down";
            Up    = "window-up";
            Right = "column-right";
            # left hand
            S     = "column-left";
            X     = "window-down";
            Z     = "window-up";
            D     = "column-right";
          };
        }}

        ${binds {
          prefixes = {
            "Mod" = "focus-column";
            "Mod+Shift" = "move-column-to";
          };
          suffixes = {
            Home  = "first";
            End   = "last";
          };
        }}

        ${binds {
          prefixes = {
            "Mod" = "focus-workspace";
            "Mod+Shift" = "move-column-to-workspace";
            "Mod+Alt" = "move-column-to-workspace";
            "Mod+Ctrl" = "move-workspace";
          };
          suffixes = {
            # right hand
            Page_Up = "up";
            Page_Down = "down";
            # left hand
            A = "up";
            F = "down";
          };
        }}

        ${binds {
          suffixes = lib.listToAttrs (map (n: {
            name = n;
            value = "workspace ${n}";
          }) (map toString (lib.range 1 9)));
          prefixes = {
            "Mod" = "focus";
            "Mod+Shift" = "move-column-to";
          };
        }}

        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        Mod+R { switch-preset-column-width; }
        Mod+G { maximize-column; }
        Mod+Shift+G { fullscreen-window; }
        Mod+C { center-column; }

        // Finer width adjustments.
        // This command can also:
        // * set width in pixels: "1000"
        // * adjust width in pixels: "-5" or "+5"
        // * set width as a percentage of screen width: "25%"
        // * adjust width as a percentage of screen width: "-10%" or "+10%"
        // Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
        // set-column-width "100" will make the column occupy 200 physical screen pixels.
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Finer height adjustments when in column with other windows.
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Actions to switch layouts.
        // Note: if you uncomment these, make sure you do NOT have
        // a matching layout switch hotkey configured in xkb options above.
        // Having both at once on the same hotkey will break the switching,
        // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
        // Mod+Space       { switch-layout "next"; }
        // Mod+Shift+Space { switch-layout "prev"; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Shift+H { power-off-monitors; }

        Mod+Shift+Ctrl+T { toggle-debug-tint; }

        // switch wallpaper
        Mod+M { spawn "random-wallpaper.sh"; }
        Shift+Mod+M { spawn ${terminal} "pick-wallpaper.sh"; }

        Mod+W { spawn "firefox"; }
        Mod+V { spawn "codium"; }
        Mod+E { spawn "nautilus" "Downloads/"; }
        Mod+Shift+E { spawn ${terminal} "lf" "/home/kiara/Downloads/"; }
        Mod+Shift+Ctrl+Alt+Space { spawn ${terminal} "pick-character.sh" "${./scripts/emoji.txt}"; }
        Mod+N { spawn "systemctl" "hibernate"; }
        Mod+K { quit; }
        Mod+F3 { spawn ${terminal} "fontpreview.sh"; }

        // Mod-/, kinda like Mod-?, shows a list of important hotkeys.
        Mod+Slash { show-hotkey-overlay; }

        Mod+F9 { spawn ${terminal} "main-menu.sh"; }
        Mod+I { spawn ${terminal} "nmtui"; }
        Mod+Shift+I { spawn "networkmanager_dmenu"; }
        Mod+U { spawn ${terminal} "power.sh"; }
        Mod+P { spawn "/home/kiara/.config/rofi/displays.sh"; }
        Mod+Y { spawn "/home/kiara/.config/rofi/keepassxc.sh" "-d" "~/Nextcloud/keepass.kdbx"; }
        Mod+B { spawn "anyrun" "--plugins" "libsymbols.so"; }
        Ctrl+Alt+Delete { spawn "gnome-system-monitor"; }
        Mod+L { spawn "swaylock"; }
        Alt+Space { spawn "swaync-client" "--close-latest"; }
        Mod+Escape { spawn "swaync-client" "--close-all"; }
        Mod+Grave { spawn "swaync-client" "--toggle-panel"; }

        Mod+Space       { spawn "anyrun.sh"; }
        Shift+Mod+Space { spawn ${terminal} "jit.sh"; }
        Ctrl+Mod+Space  { spawn "wofi.sh"; }
        Alt+Mod+Space   { spawn "rofi.sh"; }
        Mod+J           { spawn "anyrun.sh"; }
        Shift+Mod+J     { spawn ${terminal} "jit.sh"; }
        Ctrl+Mod+J      { spawn "wofi.sh"; }
        Alt+Mod+J       { spawn "rofi.sh"; }
    }

    // Settings for debugging. Not meant for normal use.
    // These can change or stop working at any point with little notice.
    debug {
        // Make niri take over its DBus services even if it's not running as a session.
        // Useful for testing screen recording changes without having to relogin.
        // The main niri instance will *not* currently take back the services; so you will
        // need to relogin in the end.
        // dbus-interfaces-in-non-session-instances

        // Wait until every frame is done rendering before handing it over to DRM.
        // wait-for-frame-completion-before-queueing

        // Enable direct scanout into overlay planes.
        // May cause frame drops during some animations on some hardware.
        // enable-overlay-planes

        // Disable the use of the cursor plane.
        // The cursor will be rendered together with the rest of the frame.
        // disable-cursor-plane

        // Slow down animations by this factor.
        // animation-slowdown 3.0

        // Override the DRM device that niri will use for all rendering.
        // render-drm-device "/dev/dri/renderD129"
    }
  '';
}
