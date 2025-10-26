{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
    ../../modules/ephemeral-zfsroot.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    grub = {
      # no need to set devices, disko will add all devices that have a EF02 partition to the list already
      # devices = [ ];
      efiSupport = true;
      efiInstallAsRemovable = true;
      enable = true;
      device = "nodev";
      useOSProber = true;
    };
    systemd-boot.enable = false;
  };

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "stor0";
    networkmanager = {
      enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.openssh = {
    enable = true;
    settings = {
        PasswordAuthentication = true;
    };
  };

  # Install firefox.
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    neovim
    pciutils
    wget
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johnt = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "John Terrell";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    hashedPassword = "$y$j9T$AeqCH7AXFUgNCdMQOid8u.$B/J278PehmzkpD4CJ.S1ETishYmpNAsvo1OK5iaKAoC";
    packages = with pkgs; [
    ];
    openssh = {
        authorizedKeys.keys = [
         "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/eqBF4qIn6LVLAXhTajccYtB/7m0vZ4qEqNSFKjkyrBCPxfs5jxOnp6Vwp+LdqBm+ZMeCr0t+U0yyayCVGjiTEFYYVT5VyZKyC+M/RJni/lo8nOi4Ah+GxuKyLzQnIAfTm8oeKZ8uyWY++RMZ9mOMBwaHfW97qZApAL+13A93N1Z31K68Siqd6nZojQ1Cvp3/zd+irwjYI7qNbNggMXsMNWYlZOZOxfxVx3jnS0e4b6Hr+L/ChbbTXqi13G3J3LUFFn+k76Pw5+QznOcWtkHq2RctpEhnWl+Px1WjK6blsZ2+pzHK+TAcqZd3vyPfW8tKriyOtwuCKkllDI8TqDe/JW8iGBtglB/8m2L0rmTHGnGjaai6Gk93c92NW2+NB4y8URGENTT0utkpWMxNqtteq40fpLEvPtB2Hop3hViz8RffLdAsbT0B3OrsDE9HXIPtEneLtymvff7we/vtIqw02H3kFUlHP+I623MpjvtTVcWx36c2Fp6nwufl59QvFb0="
        ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/eqBF4qIn6LVLAXhTajccYtB/7m0vZ4qEqNSFKjkyrBCPxfs5jxOnp6Vwp+LdqBm+ZMeCr0t+U0yyayCVGjiTEFYYVT5VyZKyC+M/RJni/lo8nOi4Ah+GxuKyLzQnIAfTm8oeKZ8uyWY++RMZ9mOMBwaHfW97qZApAL+13A93N1Z31K68Siqd6nZojQ1Cvp3/zd+irwjYI7qNbNggMXsMNWYlZOZOxfxVx3jnS0e4b6Hr+L/ChbbTXqi13G3J3LUFFn+k76Pw5+QznOcWtkHq2RctpEhnWl+Px1WjK6blsZ2+pzHK+TAcqZd3vyPfW8tKriyOtwuCKkllDI8TqDe/JW8iGBtglB/8m2L0rmTHGnGjaai6Gk93c92NW2+NB4y8URGENTT0utkpWMxNqtteq40fpLEvPtB2Hop3hViz8RffLdAsbT0B3OrsDE9HXIPtEneLtymvff7we/vtIqw02H3kFUlHP+I623MpjvtTVcWx36c2Fp6nwufl59QvFb0="
  ];

  users.users.nixos = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/eqBF4qIn6LVLAXhTajccYtB/7m0vZ4qEqNSFKjkyrBCPxfs5jxOnp6Vwp+LdqBm+ZMeCr0t+U0yyayCVGjiTEFYYVT5VyZKyC+M/RJni/lo8nOi4Ah+GxuKyLzQnIAfTm8oeKZ8uyWY++RMZ9mOMBwaHfW97qZApAL+13A93N1Z31K68Siqd6nZojQ1Cvp3/zd+irwjYI7qNbNggMXsMNWYlZOZOxfxVx3jnS0e4b6Hr+L/ChbbTXqi13G3J3LUFFn+k76Pw5+QznOcWtkHq2RctpEhnWl+Px1WjK6blsZ2+pzHK+TAcqZd3vyPfW8tKriyOtwuCKkllDI8TqDe/JW8iGBtglB/8m2L0rmTHGnGjaai6Gk93c92NW2+NB4y8URGENTT0utkpWMxNqtteq40fpLEvPtB2Hop3hViz8RffLdAsbT0B3OrsDE9HXIPtEneLtymvff7we/vtIqw02H3kFUlHP+I623MpjvtTVcWx36c2Fp6nwufl59QvFb0="
    ];
    extraGroups = [ "wheel" ];
  };

  security.sudo.extraRules = [
    {
      users = [ "nixos" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  system.stateVersion = "25.05";
}
