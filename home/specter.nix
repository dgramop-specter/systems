{pkgs, lib, config, dgramop-systems, ...}: {
  imports = [
    "${dgramop-systems}/home/common.nix"
  ];

  config = {
    home.username = "dgramop";
    home.homeDirectory = "/home/dgramop";
    common = {
      enable = true;
      email = "dhruv@specter.co";
      name = "Dhruv Gramopadhye";
      retina = false;
    };

    home.packages = with pkgs; [
      pkg-config
      marktext
      keymapp
      slack
      awscli2
      k9s
      kubectl
      _1password-gui
      flameshot
      datadog-agent
      chromium
      libreoffice
      papers
      alsa-utils
    ];

    home.file.".config/i3/config".text = import ./i3.conf.nix { alacritty = pkgs.alacritty; rofi = pkgs.rofi; flameshot = pkgs.flameshot; };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*".user = "specter";

      # HIL config, chill
      matchBlocks."brothernode-*" = {
        user = "root";
      };
      matchBlocks."192.168.10.*" = {
        extraOptions = {
          "StrictHostKeyChecking" = "no";
          "UserKnownHostsFile" = "/dev/null";
        };
      };
      matchBlocks."*.sitl" = {
        extraOptions = {
          "StrictHostKeyChecking" = "no";
          "UserKnownHostsFile" = "/dev/null";
        };
      };
    };
  };
}
