# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # waybar with Hyprland IPC support, allow workspace switching
    waybar = prev.waybar.overrideAttrs (oldAttrs: rec {
      mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
      preConfigurePhases = (oldAttrs.preConfigurePhase or [ ]) ++ [ "hyprPhase" ];
      hyprPhase = ''
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
      '';
    });
  };
}
