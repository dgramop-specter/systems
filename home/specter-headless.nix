{pkgs, lib, config, dgramop-systems, ...}: {
  imports = [
    "${dgramop-systems}/home/common.nix"
  ];

  config = {
    home.username = "dhruv";
    home.homeDirectory = "/home/dhruv";
    common = {
      enable = true;
      email = "dhruv@specter.co";
      name = "Dhruv Gramopadhye";
      retina = false;
    };

    home.packages = with pkgs; [
      pkg-config
      awscli2
      k9s
      kubectl
    ];
  };
}
