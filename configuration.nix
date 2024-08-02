# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  
  # direnv
  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.silent = true;

  # XWayland
  programs.xwayland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.initrd.kernelModules = [ "amdgpu" "radeon"];


  networking.hostName = "asusg14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.displayManager.sddm.theme = "catppuccin-sddm";

  # enable flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];
  xdg.portal.config.common.default = "gtk";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
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
  users.users.densetsu = {
    isNormalUser = true;
    description = "densetsu";
    extraGroups = [ "networkmanager" "wheel" "dialout"];
    packages = with pkgs; [
      firefox
      kate
      vim
      neovim
      # floorp
      librewolf
      chromium
      openssh
      lunarvim
      pkgs.gh
    ];
  };
   
  # for virtualization like gnome-boces or virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.podman.enable = true;
 
  #spices (virtualization)
  services.spice-vdagentd.enable = true;  
  
  # for enabling Hyprland Window manager
  programs.hyprland.enable = true;

  # LF file manager
  # programs.lf.enable = true;

  # ZRAM
  zramSwap.enable = true;

  # zsh terminal
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Flakes and the command-line tool with nix command settings 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set default editor to vim
  environment.variables.EDITOR = "lvim";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neofetch
    asusctl
    nix-bash-completions
    nix-zsh-completions
    zsh-autocomplete
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    zsh-fast-syntax-highlighting
    nixd
    nix-top
    # nix-doc
    nix-pin
    nix-tree
    nix-melt
    nix-info
    nix-diff
    nix-serve
    nix-web
    nix-tree
    nix-script
    nix-index
    nix-update
    nix-script
    nix-bundle
    nixos-icons
    nixos-shell
    nix-plugins
    nix-search-cli
    nixpkgs-lint
    nixos-option
    nom
    nh
    nil
    nvd
    nix-output-monitor
  
  #bootstrapping
    wget
    gnumake
    gnumake42
    curl
    pkgs.gh
    git
    gitFull
    gita
    vim
    arandr
    pkgs.chromium-xorg-conf
    meson
    gcc
    clang
    cl 
    zig
    gnumake
    gnumake42
    cmake
    meson
    ninja
    libsForQt5.full
    libsForQt5.qt5.qtbase
    qt6.full
    lm_sensors
    xfce.xfce4-sensors-plugin
    xsensors
    qt6.qtbase
    qt6.qmake
    fanctl

   #i3wm pkgs
    dmenu
    rofi
    autotiling
    lxappearance
    xfce.xfce4-terminal
    xfce.xfce4-settings
    dunst
    pavucontrol
    jgmenu
    nix-zsh-completions
    zsh
    tmux
    fzf-zsh
    nitrogen
    pfetch
    neofetch
    neovim
    picom
    networkmanager_dmenu
    papirus-folders
    papirus-nord
    sweet
    clipmenu
    volumeicon
    brightnessctl

  #  fonts and themes
    hermit
    powerline-fonts
    noto-fonts
    corefonts
    libertine
    google-fonts
    source-code-pro
    terminus_font
    nerdfonts
    terminus-nerdfont
    ranger
    i3status
    pkgs.pcscliteWithPolkit
    pkgs.pcsctools
    pkgs.scmccid
    pkgs.ccid
    pkgs.pcsclite
    pkgs.opensc
    starship
    nixos-icons
    luna-icons
    # sweet-folders
    # candy-icons
    material-icons
    material-design-icons
    luna-icons
    variety
    sweet
    catppuccin
    comixcursors
    ayu-theme-gtk
    hvm

   #vim and programming 
    vimPlugins.nvim-treesitter-textsubjects
    nixos-install-tools
    # nodejs_21
    lua
    python3
    clipit
    rofi-power-menu
    blueberry
    bluez

   #misc
    linode-cli
    teamviewer
    microsoft-edge
    yazi
    gummy
    remmina
    catppuccin-sddm
    zed-editor
    microcodeAmd
    amdgpu_top
    amdctl
    pasystray
    dhcpdump
    lf
    postgresql
    w3m
    usbimager
    xdragon
    lunarvim
    pcsctools
    pcsclite
    pkgs.opensc
    pkgs.ark
    pam_p11
    # pam_usb
    nss
    nss_latest
    acsccid
    distrobox
    vscodium
    smartmontools
    check_smartmon
    glibc
    kvmtool
    nvtopPackages.panthor

   #hyprland
    hyprland
    swaylock
    xdg-desktop-portal-hyprland
    rPackages.gbm
    hyprland-protocols
    libdrm
    wayland-protocols
    waybar
    wofi
    kitty
    kitty-themes
    swaybg
    waypaper

   #waybar
    nm-tray
    gtkmm3
    gtk-layer-shell
    jsoncpp
    fmt
    wayland
    spdlog
    # libgtk-3-dev #[gtk-layer-shell]
    gobject-introspection #[gtk-layer-shell]
    # libpulse #[Pulseaudio module]
    libnl #[Network module]
    libappindicator-gtk3 #[Tray module]
    libdbusmenu-gtk3 #[Tray module]
    libmpdclient #[MPD module]
    # libsndio #[sndio module# ]
    libevdev #[KeyboardState module]
    # xkbregistry
    upower #[UPower battery module]
    nwg-look
    feh
    wl-clipboard
    wlogout
    supergfxctl
    asusctl
    blueman
    linuxKernel.packages.linux_zen.zenpower
    linuxKernel.packages.linux_zen.asus-ec-sensors
    linuxKernel.packages.linux_zen.asus-wmi-sensors
    linuxKernel.packages.linux_xanmod.asus-ec-sensors
    linuxKernel.packages.linux_xanmod_latest.asus-ec-sensors
    linuxKernel.packages.linux_xanmod_stable.asus-ec-sensors
    linuxKernel.packages.linux_xanmod_latest.asus-wmi-sensors

    # Steam
    steam
    steam-run
    pkgs.steamPackages.steam-runtime
    sc-controller
    gamescope
    protonup-qt
    lutris
    steamtinkerlaunch
  
  ];

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      open-sans
      source-han-sans-japanese
      source-han-serif-japanese
      openmoji-color
      terminus_font_ttf
      terminus-nerdfont
    ];
     
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      emoji = [ "openmoji-color" ];
    };
  };

  environment.sessionVariables = {
  FLAKE = "/etc/nixos/configuration.nix";
   };
  
   # nix grub generations
  nix.settings.auto-optimise-store = true;
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 3d";
  };

    nixpkgs.config.permittedInsecurePackages = [
    "nodejs-12.22.12"
    "python-2.7.18.7"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.supergfxd.enable = true;
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  services.supergfxd.settings = {
  supergfxctl-mode = "Integrated";
  gfx-vfio-enable = true;
  };  # Power Profiles
  systemd.services.supergfxd.path = [ pkgs.pciutils ];
  services.power-profiles-daemon.enable = true;
  systemd.services.power-profiles-daemon = {
  enable = true;
  wantedBy = [ "multi-user.target" ];
  };
  
  #pscsd
  services.pcscd.enable = true;
 
  # tlp services
 # services.tlp.enable = true;
  
   # amdgpu setup
    #Enable OpenGL
  hardware.opengl = {
    enable = true;
    # driSupport = true;
    driSupport32Bit = true;
  };

  hardware.opengl.extraPackages = with pkgs; [
  amdvlk
  ];
  # For 32 bit applications 
  hardware.opengl.extraPackages32 = with pkgs; [
  driversi686Linux.amdvlk
  ];


  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.nvidia.powerManagement = {
  enable = true;
  finegrained = true;
    };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    prime = {
      reverseSync.enable = true; 
    #   sync = {
    #    enable = true;
    #   };
      offload = {
       enable =  true;
       enableOffloadCmd = true; # Provides `nvidia-offload` command.
      };
    };
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # List services that you want to enable:
    services.teamviewer.enable = true;
    services.sshd.enable = true;
    services.postgresql.enable = true;
    # services.asusd.enableUserService = true;
    # services.asusd.enable = true;
    programs.rog-control-center.enable = true;
    programs.rog-control-center.autoStart = true;
    services.smartd.enable = true;
    hardware.usbStorage.manageStartStop = true;
    programs.zsh.enableLsColors = true;
    programs.zsh.enableCompletion = true;
    programs.zsh.enableBashCompletion = true;
    programs.zsh.autosuggestions.strategy = [
     "history"
      ]; 

    programs.zsh.autosuggestions.async = true;
    virtualisation.kvmgt.enable = true;

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
          subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
  '';  

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [
  	  22
  	];

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
