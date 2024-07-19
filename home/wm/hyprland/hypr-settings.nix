{ pkgs, lib, config, inputs, userSettings, thunar_pkg }:

let
  evalBinds = mainMod: modifiers: binds: (
    builtins.map (bind: (
      mainMod + (
        if (lib.foldl (acc: mod: acc || (lib.hasPrefix mod bind)) false modifiers) then " " else ", "
      ) + bind)
    ) binds
  );
  grimblast = inputs.hyprland-contrib.packages.${pkgs.system}.grimblast;
in
{
  source = [
    # "$HOME/.config/hypr/monitors.conf"
  ];

 # monitor = [
 #   ",preferred,auto,auto"
 #     "eDP-1,2256x1504,0x0,1.566667"
 # ];


  env = [
    "XDG_SESSION_DESKTOP, Hyprland"
    "XCURSOR_SIZE, 20"
  ];

  exec-once = [
    "${pkgs.swaynotificationcenter}/bin/swaync"
    "${config.programs.waybar.package}/bin/waybar"
    "${pkgs.networkmanagerapplet}/bin/nm-applet"
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "${pkgs.swaybg}/bin/swaybg -i ${builtins.path { name = "swaybg-img"; path = userSettings.wallpaper; }}"
    "${thunar_pkg}/bin/thunar --daemon"
    "sleep 5; ${pkgs.copyq}/bin/copyq --start-server"
  ];

  # "debug:disable_scale_checks" = true;
  # "debug:disable_logs" = false;

  bind =
    # SUPER binds
    evalBinds "SUPER" [ "CTRL" "SHIFT" "ALT" ] [
      # exec keybinds
      "A, exec, ${grimblast}/bin/grimblast --freeze save area - | ${pkgs.swappy}/bin/swappy -f -"
      "SHIFT, A, exec, ${grimblast}/bin/grimblast --freeze save output - | ${pkgs.swappy}/bin/swappy -f -"
      "E, exec, ${thunar_pkg}/bin/thunar"
      "Q, exec, ${config.programs.kitty.package}/bin/kitty"
      "R, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show drun"
      "SHIFT, R, exec, ${import ./scripts/hyreload.nix { inherit pkgs config userSettings; }}"
      "T, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show ssh"
      "V, exec, ${pkgs.copyq}/bin/copyq show"
      "BACKSPACE, exec, loginctl lock-session"
      "SHIFT, BACKSPACE, exec, ${import ./scripts/lock-transparent.nix { inherit pkgs config; }}"
      "TAB, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show window"
      "RETURN, exec, ${config.programs.rofi.package}/bin/rofi -click-to-exit -show power-menu -modi 'power-menu:${import ./scripts/rofi-power-menu.nix { inherit pkgs; }}'"
      "PLUS, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel"
      "SHIFT, PLUS, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -C"
      "CTRL, PLUS, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd"

      "C, killactive"
      "F, fullscreen, 1"
      "SHIFT, F, fullscreen, 0"
      # "G, togglesplit,"
      "SHIFT, M, exit,"
      # "P, pseudo,"
      "SPACE, togglefloating,"

      "left,  movefocus, l"
      "right, movefocus, r"
      "up,    movefocus, u"
      "down,  movefocus, d"
      "SHIFT, left,  movewindow, l"
      "SHIFT, right, movewindow, r"
      "SHIFT, up,    movewindow, u"
      "SHIFT, down,  movewindow, d"
      "h, movefocus, l"
      "l, movefocus, r"
      "k, movefocus, u"
      "j, movefocus, d"
      "SHIFT, h, movewindow, l"
      "SHIFT, l, movewindow, r"
      "SHIFT, k, movewindow, u"
      "SHIFT, j, movewindow, d"

      "1, split-workspace, 1"
      "2, split-workspace, 2"
      "3, split-workspace, 3"
      "4, split-workspace, 4"
      "5, split-workspace, 5"
      "6, split-workspace, 6"
      "7, split-workspace, 7"
      "8, split-workspace, 8"
      "9, split-workspace, 9"
      "0, split-workspace, 10"

      "SHIFT, 1, split-movetoworkspace, 1"
      "SHIFT, 2, split-movetoworkspace, 2"
      "SHIFT, 3, split-movetoworkspace, 3"
      "SHIFT, 4, split-movetoworkspace, 4"
      "SHIFT, 5, split-movetoworkspace, 5"
      "SHIFT, 6, split-movetoworkspace, 6"
      "SHIFT, 7, split-movetoworkspace, 7"
      "SHIFT, 8, split-movetoworkspace, 8"
      "SHIFT, 9, split-movetoworkspace, 9"
      "SHIFT, 0, split-movetoworkspace, 10"

      "S, togglespecialworkspace, magic"
      "SHIFT, S, movetoworkspace, special:magic"

      "D,        exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad"
      "SHIFT, D, exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -g -l"
      "CTRL, D,  exec, ${inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad}/bin/scratchpad -t"

      "CTRL, RIGHT, split-workspace, r+1"
      "CTRL, LEFT,  split-workspace, r-1"
      "CTRL SHIFT, RIGHT, split-movetoworkspace, r+1"
      "CTRL SHIFT, LEFT,  split-movetoworkspace, r-1"

      "CTRL, L, split-workspace, r+1"
      "CTRL, H, split-workspace, r-1"
      "CTRL SHIFT, L, split-movetoworkspace, r+1"
      "CTRL SHIFT, H, split-movetoworkspace, r-1"
    ]
    ++
    evalBinds "CTRL" [ "SHIFT" ] [
      "SHIFT, M, pass, ^vesktop$"
    ];

  bindm =
    evalBinds "SUPER" [ ] [
      "mouse:272, movewindow"
      "mouse:273, resizewindow"
    ];

  binde =
    evalBinds "SUPER" [ "ALT" ] [
      "ALT, left,  resizeactive, -20 0"
      "ALT, right, resizeactive,  20 0"
      "ALT, up,    resizeactive, 0 -20"
      "ALT, down,  resizeactive, 0  20"
        
      "ALT, h, resizeactive, -20 0"
      "ALT, l, resizeactive,  20 0"
      "ALT, k, resizeactive, 0 -20"
      "ALT, j, resizeactive, 0  20"
    ];

  bindl = 
    evalBinds "" [ ] [
      "XF86AudioMute, exec,     ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -p toggle-mute"
      "XF86AudioMicMute, exec,  ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -m -p toogle-mute"
      "XF86AudioNext,   exec, ${config.services.playerctld.package}/bin/playerctl next"
      "XF86AudioPrev,   exec, ${config.services.playerctld.package}/bin/playerctl previous"
      "XF86AudioPlay,   exec, ${config.services.playerctld.package}/bin/playerctl play-pause"
      "XF86AudioPause,  exec, ${config.services.playerctld.package}/bin/playerctl play-pause"
    ];

  bindle =
    evalBinds "" [ ] [
      "XF86AudioRaiseVolume,  exec, ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -p up"
      "XF86AudioLowerVolume,  exec, ${config.services.avizo.package}/bin/volumectl ${if config.colorScheme.variant == "dark" then "-d" else ""} -p down"
      "XF86MonBrightnessUp,   exec, ${config.services.avizo.package}/bin/lightctl ${if config.colorScheme.variant == "dark" then "-d" else ""} up"
      "XF86MonBrightnessDown, exec, ${config.services.avizo.package}/bin/lightctl ${if config.colorScheme.variant == "dark" then "-d" else ""} down"
    ];

  binds = {
    workspace_back_and_forth = true;
  };

  input = {
    kb_layout = "eurkey";
    kb_options = "caps:escape";
    follow_mouse = 2;

    touchpad = {
      natural_scroll = true;
      tap-to-click = true;
    };

    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
    # accel_profile = "flat";
  };

  gestures = {
    workspace_swipe = true;
    workspace_swipe_fingers = 3;
    workspace_swipe_forever = true;
    workspace_swipe_use_r = true;
  };

  plugin.split-monitor-workspaces = {
    count = 10;
  };

  misc = {
    close_special_on_empty = false;
    focus_on_activate = true;
    mouse_move_enables_dpms = false;
    key_press_enables_dpms = true;
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
  };

  windowrulev2 = [
    "suppressevent maximize, class:.*"

    "float, class:pavucontrol"
    "float, class:nm-connection-editor"
    "float, class:.blueman-manager-wrapped"

    "float, class:xdg-desktop-portal-gtk"

    "float, class:firefox, title:(Password Required - Mozilla Firefox)"
    "stayfocused , class:firefox, title:(Password Required - Mozilla Firefox)"

    "float, class:swayimg"
    "noborder, class:swayimg"
    "noblur, class:swayimg"
    "noshadow, class:swayimg"
    "size 100%, 100%, class:swayimg"
    "center, class:swayimg"

    "float, class:copyq"
    "move onscreen cursor, class:copyq"
    "pin, class:copyq"
  ];

  layerrule = [
    "noanim, selection"
  ];

  general = {
    gaps_in = 0;
    gaps_out = 0;
    border_size = 1;
    "col.active_border" = "rgba(${config.colorScheme.palette.base0F}66)";
    "col.inactive_border" = "rgba(${config.colorScheme.palette.base04}66)";

    layout = "master";

    allow_tearing = false;
  };

  decoration = {
    rounding = 0;

    blur = {
      enabled = true;
      size = 4;
      passes = 2;

      vibrancy = 0.1696;
    };

    /* drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)"; */
  };

  animations = {
    # enabled = false;
    /* bezier = "myBezier, 0.05, 0.9, 0.1, 1.0";
    animation = [
      "windows, 1, 5, myBezier"
      "windowsOut, 1, 5, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 5, default"
    ]; */
  };

  /* dwindle = {
    pseudotile = true;
    preserve_split = true;
  }; */

  master = {
    new_status = "slave";
    new_on_top = true;
    mfact = 0.65;
    no_gaps_when_only = 1;
  };

  xwayland.force_zero_scaling = true;
}
