{
  pkgs,
  outputs,
  userConfig,
  ...
}: {
  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  nix.package = pkgs.nix;

  # Enable Nix daemon
  services.nix-daemon.enable = true;

  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # Add ability to use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Trackpad, mouse, keyboard, and input
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleKeyboardUIMode = 3;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };

  system.defaults.trackpad = {
    TrackpadRightClick = true;
    TrackpadThreeFingerDrag = true;
    Clicking = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [pip virtualenv]))
    awscli2
    delta
    du-dust
    eza
    fd
    jq
    kubectl
    lazydocker
    nh
    openconnect
    pipenv
    ripgrep
    terraform
    terragrunt
  ];

  # Zsh configuration
  programs.zsh.enable = true;

  # Fonts configuration
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
    roboto
  ];

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "anki"
      "brave-browser"
      "nikitabobko/tap/aerospace"
      "raycast"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
