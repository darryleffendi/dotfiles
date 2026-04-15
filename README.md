# Dotfiles

## Linux (WSL / VPS)
```bash
git clone https://github.com/darryleffendi/dotfiles.git ~/.config/dotfiles

# Nvim
ln -s ~/.config/dotfiles/nvim ~/.config/nvim

# Starship
ln -s ~/.config/dotfiles/starship.toml ~/.config/starship.toml
```

## Windows
```powershell
git clone https://github.com/darryleffendi/dotfiles.git $env:USERPROFILE\dotfiles

# Nvim
cp -r $env:USERPROFILE\dotfiles\nvim $env:LOCALAPPDATA\nvim

# Starship
cp $env:USERPROFILE\dotfiles\starship.toml $env:USERPROFILE\.config\starship.toml
```
