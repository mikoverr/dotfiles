{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # =============================================================================
  # SYSTEM & BOOT
  # =============================================================================
  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.05";

  # =============================================================================
  # LOCALIZATION & TIME
  # =============================================================================
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT    = "ru_RU.UTF-8";
    LC_MONETARY       = "ru_RU.UTF-8";
    LC_NAME           = "ru_RU.UTF-8";
    LC_NUMERIC        = "ru_RU.UTF-8";
    LC_PAPER          = "ru_RU.UTF-8";
    LC_TELEPHONE      = "ru_RU.UTF-8";
    LC_TIME           = "ru_RU.UTF-8";
  };

  # =============================================================================
  # USERS & NETWORKING
  # =============================================================================
  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  networking = {
    hostName = "nixmachine";
    networkmanager.enable = true;
  };

  # =============================================================================
  # DESKTOP ENVIRONMENT (GNOME)
  # =============================================================================
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = true;

  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:win_space_toggle";
  };

  environment.gnome.excludePackages = with pkgs; [
    # Games
    atomix
    gnome-2048
    gnome-chess
    gnome-klotski
    gnome-mahjongg
    gnome-mines
    gnome-nibbles
    gnome-sudoku
    gnome-taquin
    hitori
    iagno
    lightsoff
    quadrapassel
    swell-foop
    tali

    # System apps
    baobab
    epiphany
    geary
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-software
    gnome-system-monitor
    gnome-text-editor
    gnome-weather
    gnome-connections
    simple-scan
    snapshot
    yelp

    # Specific tools
    gnome-tour
    gnome-user-docs
  ];

  # =============================================================================
  # SERVICES
  # =============================================================================
  # Audio & Multimedia
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # System Services
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.postgresql.enable = true;
  services.ratbagd.enable = true; # daemon for logitech g304
  services.ollama.enable = true;

  # =============================================================================
  # PROGRAMS & SHELLS
  # =============================================================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "robbyrussell";
    };
  };

  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.firefox.enable = true;
  programs.obs-studio.enable = true;
  programs.localsend.enable = true;
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme    = "adw-gtk3-dark";
          cursor-theme = "material_light_cursors";
          cursor-size  = lib.gvariant.mkInt32 24;
          icon-theme   = "Papirus-Dark";
          font-name    = "Inter 11";
        };
        settings."org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "dash-to-dock@micxgx.gmail.com"
            "clipboard-indicator@tudmotu.com"
            "just-perfection-desktop@just-perfection"
            "workspaces-by-open-apps@favo02.github.com"
            "eepresetselector@ulville.github.io"
          ];
        };
        settings."org/gnome/shell/extensions/user-theme" = {
          name = "Marble-dark";
        };
      }
    ];
  };

  # =============================================================================
  # SYSTEM PACKAGES
  # =============================================================================
  environment.systemPackages = with pkgs; [
    # Core Utilities & File Management
    tree
    file-roller
    unzip
    p7zip
    unrar
    btop

    # Development CLI
    cmake
    gcc
    gdb
    nodejs
    qt6.qtbase
    qt6.qttools
    qt6.qtwayland

    # Development GUI
    zed-editor
    android-studio
    qtcreator
    dbeaver-bin

    # AI Tools
    aider-chat

    # Music Production
    zrythm
    ardour
    vital
    surge-xt

    # General Applications
    easyeffects
    obsidian
    onlyoffice-desktopeditors
    scrcpy
    piper

    # Appearance & Themes
    adw-gtk3
    papirus-icon-theme
    material-cursors
    marble-shell-theme

    # GNOME Extensions
    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.just-perfection
    gnomeExtensions.workspaces-indicator-by-open-apps
    gnomeExtensions.easyeffects-preset-selector
  ];

  # =============================================================================
  # FONTS & APPEARANCE
  # =============================================================================
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
        autohint = false;
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        sansSerif = [ "Inter" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
        emoji     = [ "Noto Color Emoji" ];
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # =============================================================================
  # ENVIRONMENT & ALIASES
  # =============================================================================
  environment.pathsToLink = [ "/share/icons" "/share/pixmaps" ];

  environment.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
    XCURSOR_THEME = "material_light_cursors";
    XCURSOR_SIZE = "24";
  };

  environment.variables = {
    XCURSOR_THEME = "material_light_cursors";
    XCURSOR_SIZE  = "24";
  };

  environment.shellAliases = {
    vi = "nvim";
    # ai = "OLLAMA_API_BASE=http://127.0.0.1:11434 aider --model ollama/qwen2.5:1.5b";
  };
}
