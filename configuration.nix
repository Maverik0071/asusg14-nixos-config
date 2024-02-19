let
  g14_patches = fetchGit {
    url = "https://gitlab.com/dragonn/linux-g14";
    ref = "5.17";
    rev = "ed8cf277690895c5b2aa19a0c89b397b5cd2073d";
  };
in
# { ... }

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modulesPath, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
       ./hardware-configuration.nix
      # ./home
     # ./desktop-packages.nix	
     inputs.home-manager.nixosModules.default
    ];
# amdgpu setup
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.opengl.extraPackages = with pkgs; [
  amdvlk
  ];
  # For 32 bit applications 
  hardware.opengl.extraPackages32 = with pkgs; [
  driversi686Linux.amdvlk
  ];
   
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["amdgpu"];
  
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.systemd-boot.extraEntries = { };
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.efi.efiSysMountPoint = "/boot";
  # boot.initrd.kernelModules = [" amdgpu "];
  boot.loader = {
  grub = {
    enable = true;
    useOSProber = true;
    devices = [ "nodev" ];
    efiSupport = true;
    configurationLimit = 5;
  };
  efi.canTouchEfiVariables = true;
};
  boot.initrd.kernelModules = [ "amdgpu"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  nix = {
  package = pkgs.nixFlakes;
  extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
    "experimental-features = nix-command flakes";
    }; 
  
  #direnv
  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.silent = true;    
 
  # Bootloader #boot.kernalPackages = "pkgs.linuxPackages_latest;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_5_17;
  boot.kernelPatches = map (patch: { inherit patch; }) [
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0004-5.15+--more-uarches-for-kernel.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"

  "${g14_patches}/sys-kernel_arch-sources-g14_files-0043-ALSA-hda-realtek-Fix-speakers-not-working-on-Asus-Fl.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0049-ALSA-hda-realtek-Add-quirk-for-ASUS-M16-GU603H.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-0050-asus-flow-x13-support_sw_tablet_mode.patch"

  # mediatek mt7921 bt/wifi patches
  "${g14_patches}/sys-kernel_arch-sources-g14_files-8017-mt76-mt7921-enable-VO-tx-aggregation.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-8026-cfg80211-dont-WARN-if-a-self-managed-device.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-8050-r8152-fix-spurious-wakeups-from-s0i3.patch"

  # squashed s0ix enablement through
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9001-v5.16.11-s0ix-patch-2022-02-23.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9004-HID-asus-Reduce-object-size-by-consolidating-calls.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9005-acpi-battery-Always-read-fresh-battery-state-on-update.patch"

  "${g14_patches}/sys-kernel_arch-sources-g14_files-9006-amd-c3-entry.patch"

  "${g14_patches}/sys-kernel_arch-sources-g14_files-9010-ACPI-PM-s2idle-Don-t-report-missing-devices-as-faili.patch"
  "${g14_patches}/sys-kernel_arch-sources-g14_files-9012-Improve-usability-for-amd-pstate.patch"
];

networking.hostName = "blackwolf-nixos"; # Define your hostname.
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
  #services.xserver.autorun = true;
  #services.xserver.layout = "us";
  #services.xserver.desktopManager.default = "none";
  #services.xserver.desktopManager.xterm.enabe = false;
  #services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  # services.xserver.displayManager.ly.enable = true;  
 
  # Enable the XFCE Desktop Environment.
  # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  
  # enable flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk];
  xdg.portal.config.common.default = "gtk";
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

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
       vim
       neovim
       firefox
       chromium
       openssh
       lunarvim
       pkgs.gh 
    #  thunderbird
    ];
  };

  home-manager = {
  # also pass inputs to home-manager modules
  extraSpecialArgs = {inherit inputs;};
  users = {
    "densetsu" = import ./home.nix;
    };
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
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   # bash and zsh 
    nix-bash-completions
    nix-zsh-completions
    zsh-autocomplete
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    zsh-fast-syntax-highlighting
    nixd
  #bootstrapping
    wget
    curl
    pkgs.gh
    git
    vim
    arandr
    pkgs.chromium-xorg-conf
    meson
    gcc
    clang
    cl 
    zig
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
    material-icons
    material-design-icons
    luna-icons
    variety
    sweet
   #vim and programming 
    vimPlugins.nvim-treesitter-textsubjects
    nixos-install-tools
    nodejs_21
    lua
    python3
    clipit
    rofi-power-menu
    blueberry
   #misc
    pasystray
    tlp
    pkgs.ly
    dhcpdump
    lf
    postgresql
    w3m
    usbimager
    wezterm
    xdragon
    lunarvim
    pcsc-tools
    pcsclite
    pkgs.opensc
    pkgs.ark
    pam_p11
    pam_usb
    nss
    nss_latest
    acsccid
    distrobox
   #hyprland
    hyprland
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
   #waybar
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
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      emoji = [ "openmoji-color" ];
    };
  };
  
   # nix grub generations
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
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

# Supergfxctl
services.supergfxctl = {
  enable = true;
  gfx-mode = "Integrated";
  gfx-vfio-enable = true;
};  # Power Profiles
services.power-profiles-daemon.enable = true;
systemd.services.power-profiles-daemon = {
  enable = true;
  wantedBy = [ "multi-user.target" ];
};
services.asusctl.enable = true;

hardware.nvidia.powerManagement = {
  enable = true;
  finegrained = true;
};

 # List services that you want to enable:     
    services.sshd.enable = true;
    services.tlp.enable = true;
    services.pcscd.enable = true;

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.debian.pcsc-lite.access_pcsc" &&
          subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
  '';

    services.postgresql.enable = true;
 
  # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  	services.openssh.ports = [
  	  22
  	];

  # services.openssh = {
  # enable = true;
  # require public key authentication for better security
  #settings.PasswordAuthentication = false;
  #settings.KbdInteractiveAuthentication = false;
  #settings.PermitRootLogin = "yes";
  # }; 

 
  #users.users."densetsu".openssh.authorizedKeys.keyFiles = [
  # /etc/nixos/ssh/authorized_keys
  # ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  #networking.interfaces.enp1s0.useDHCP = true;
  #networking.interfaces.wlp2s0.useDHCP = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
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
