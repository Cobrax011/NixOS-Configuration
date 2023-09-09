# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-17546cdb-726d-484a-b559-cd3a53437f62".device = "/dev/disk/by-uuid/17546cdb-726d-484a-b559-cd3a53437f62";
  boot.initrd.luks.devices."luks-17546cdb-726d-484a-b559-cd3a53437f62".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

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
  #Fonts
  fonts.fonts = with pkgs; [
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
  vistafonts
  corefonts
  fira
  roboto
  roboto-slab
  fira-mono  
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cobra0x011 = {
    isNormalUser = true;
    description = "Cobra0x011";
    extraGroups = [ "wheel" "kvm" "input" "disk" "libvirtd" "syncthing" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      thunderbird
    ];
  };
  # Fish Shell 
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
   # Configuring Nvidia PRIME
  hardware.nvidia.nvidiaSettings = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime = {
   offload.enable = true;

   # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
   nvidiaBusId = "PCI:1:0:0";

   # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
   intelBusId = "PCI:0:2:0";
  };
  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia.powerManagement.enable = true;
  
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lshw
    wine-staging       # Required for playing apps for not-so-nice platform :)
    pkgs.winetricks    # Also required with wine 
    curl                # Requests swiss-nife
    qbittorrent         # For sharing files
    elinks              # Nice text-based browser, the future of serfing :D
    pkgs.tectonic       # LaTeX engine
    pkgs.alfis         # Pretty blockchain-based DNS in Yggdrasil Network. Unfortunately has some issues 
    yggdrasil           # Autorounting mash-network works over Internet, radio and bluetooth. Gives you white IPv6
    rhvoice             # BEST OFFline Russian (and other Slavic language) TTS engine 
    radicale            # CalDAV and CardDAV server
    git                 # Do you know the difference between git and github? :P
    unzip               # ZIP unarchivier
    automake            # Make utilities
    mmake
    gnumake
    nginx               # Multipurpose webserver
    pdnsd               # Caching DNS server
    gcc                 # GNU C Compiler
    tinycc              # really tiny C Compiler by genious programmer Fabrice Bellard
    pkgs.terminus_font  # Good-looking console font for cyrillic alphabets
    pkgs.aspellDicts.ru # Russian spellchecking dictionary
    pkgs.aspellDicts.ar
    pkgs.aspell         # Spellchecking app
  # steam              # unfree game shop
    unrar              # unfree but popular archive format
  # dosbox-staging     # for games and soft which is was not free but currently it doesn't matter
    vlc
    flameshot
    peek
    putty
    google-chrome
    brave
    vscode
    virt-manager
    fontconfig
    nfs-utils
    freetype
    gimp
    github-desktop
    kdenlive
    audacity
    hugo
    pavucontrol
    powershell
    protonup-ng
    python3Full
    python.pkgs.pip
    qemu
    megasync
    keepassxc
    obs-studio
    maestral
    syncthing
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    telegram-desktop
    intel-gpu-tools
    strawberry
    openssl             # For selfsigning certificates
  # prosody             # XMPP server
  # psi                 # XMPP client
  # mpd                 # MPD server
  # ympd                # MPD client
  # mpc-cli             # MPD cli client
    mplayer
    tor
    go         
    pkgs.cryptsetup    #
    xdg-desktop-portal-gtk
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
    xorg.xinput
    gnomeExtensions.pop-shell
    xorg.xprop
    gnome3.gnome-tweaks
    pkgs.vaapiIntel #if your CPU is GEN 8 or Newer 'pkgs.intel-media-driver'
      (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }
    ];
  }) 
 ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable: 
  services.fstrim.enable = true;
  services.flatpak.enable = true;
  services.syncthing.enable = true;
  
 #Virtual Machines
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

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
  system.stateVersion = "23.05"; # Did you read the comment?
 #Security
 security.sudo.enable = true;
 nixpkgs.config.permittedInsecurePackages = [
  "openssl-1.1.1v"
  "python-2.7.18.6"
   ];
 #ntfs Support
 boot.supportedFilesystems = [ "ntfs" ];
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;  
  system.autoUpgrade.allowReboot = true; 
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
}
