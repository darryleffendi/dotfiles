# Dotfiles

## Linux (WSL / VPS)
```bash
git clone https://github.com/darryleffendi/dotfiles.git ~/.config/dotfiles

# Nvim
ln -s ~/.config/dotfiles/nvim ~/.config/nvim

# Starship
ln -s ~/.config/dotfiles/starship.toml ~/.config/starship.toml

# Tmux
ln -s ~/.config/dotfiles/tmux/ ~/.config/tmux

# Ghostty
ln -s ~/.config/dotfiles/ghostty/ ~/.config/ghostty

# WezTerm
ln -s ~/.config/dotfiles/wezterm/ ~/.config/wezterm
```

## Windows
```bash
git clone https://github.com/darryleffendi/dotfiles.git $env:USERPROFILE\dotfiles

# Nvim
cp -r $env:USERPROFILE\dotfiles\nvim $env:LOCALAPPDATA\nvim

# Starship
cp $env:USERPROFILE\dotfiles\starship.toml $env:USERPROFILE\.config\starship.toml

# WezTerm
cp $env:USERPROFILE\dotfiles\wezterm $env:USERPROFILE\.config\wezterm

# Ghostty
cp $env:USERPROFILE\dotfiles\ghostty $env:USERPROFILE\.config\ghostty

```
