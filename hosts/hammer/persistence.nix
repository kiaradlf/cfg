{
  # https://github.com/nix-community/impermanence/blob/master/README.org#nixos
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/ssh"
      "/var/lib/systemd/timers"
      "/etc/nixos" # not everyone seemed to do this - maybe i just need this for the age key?
      "/var/db/sudo"
      "/var/lib/bluetooth"
      "/var/lib/nixos" # important nixos files like uid/gid map
      "/var/lib/systemd"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id" # needed for systemd logs and possibly other stuff
      "/etc/shadow" # passwords
      "/etc/passwd" # sudo rights
      "/etc/group" # user groups
      "/etc/adjtime" # hardware clock offset
    ];
    users.kiara = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "Nextcloud"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/nix" # trusted settings and repl history
        ".local/share/direnv"
      ];
    };
  };
}
