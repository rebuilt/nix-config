# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ];


    fileSystems."/home/nelson/drives/970_evo" = {
      device = "/dev/nvme0n1p2"; # You can also use device paths if preferred
      fsType = "auto";
      options = [ "nofail" "x-gvfs-show" ];
    };

    fileSystems."/home/nelson/drives/windows" = {
      device = "/dev/sdb3"; # You can also use device paths if preferred
      fsType = "auto";
      options = [ "nofail" "x-gvfs-show" ];
    };

    fileSystems."/home/nelson/drives/crucial" = {
      device = "/dev/sdc1"; # You can also use device paths if preferred
      fsType = "auto";
      options = [ "nofail" "x-gvfs-show" ];
    };

    fileSystems."/home/nelson/drives/barracuda" = {
      device = "/dev/sda1"; # You can also use device paths if preferred
      fsType = "auto";
      options = [ "nofail" "x-gvfs-show" ];
    };
# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-tripper"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
    networking.networkmanager.enable = true;

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

# Enable the XFCE Desktop Environment.
  services.xserver.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

# Enable CUPS to print documents.
  services.printing.enable = true;

# Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
  };

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nelson = {
    isNormalUser = true;
    description = "nelson";
    extraGroups = [ "networkmanager" "wheel"  "docker" "libvirtd"];
    packages = with pkgs; [

#  thunderbird
    ];
  };

# Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "nelson";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Install firefox.
  programs.firefox.enable = true;

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;  # see the note above
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
  ];
# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [

    #terminals
    ghostty
    kitty
    neovim

    bartib
    bash-completion
    bat
    btop
    # calibre
    cargo
    choose
    chromium
    clipman
    discord
    docker
    duf
    dust
    eza
    fd
    feh
    fzf
    gcc15
    gdb
    gemini-cli
    gimp
    git
    gnumake
    go
    hyperfine
    jql
    libgcc
    mise
    nasm
    nmap
    pandoc
    procs
    protonvpn-gui
    raylib-games
    ripgrep
    rm-improved
    rustup
    slack
    starship
    stow
    stylua
    tealdeer
    xfce.thunar
    transmission_4-qt
    vim
    vlc
    wiremix
    wireplumber
    zoom
    zoxide
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };


  virtualisation.docker = {
    enable = true;
  };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;


  services.ollama = {
    enable = true;
    acceleration = "vulkan";
  };
  services.gnome.gnome-keyring.enable = true;

# enable Sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

services.greetd = {                                                      
  enable = true;                                                         
  settings = {                                                           
    default_session = {                                                  
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
      user = "greeter";                                                  
    };                                                                   
  };                                                                     
};

programs.starship.enable = true;

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
