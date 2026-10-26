<h1 align="center">dotfiles</h1>
<p align="center">My NixOS + Gnome config</p>

## Features
- Gnome Desktop Environment with custom themes (Marble-dark, Papirus).
- Zsh with Oh-My-Zsh, autosuggestions, and syntax highlighting.
- Pre-configured development tools (Neovim, Zed, Android Studio, QtCreator).
- AI tools integration (Ollama, Aider).
- Music production software (Zrythm, Ardour, Vital, Surge XT).

## How to use this configuration

1. Generate `hardware-configuration.nix` file: 
   ```bash
   nixos-generate-config --print | sudo tee /etc/nix/hardware-configuration.nix
   ```

2. Customize user in `configuration.nix`:
   - `users.users.user` - replace `user` with your desired username.
   - `networking.hostName` - change `nixmachine` to your preferred hostname.
   - `time.timeZone` - update to your local timezone.

3. Apply configuration:
   ```bash
   sudo nixos-rebuild switch
   ```
