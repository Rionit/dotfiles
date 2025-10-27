# dotfiles
My Linux dotfiles (I use Arch btw)

hello from arch

## Note for myself

How to add config files here:

1. `mv` the config folder/file in here to `dotfiles/`
e.g. if it's `~/.config/my_app_configs/` then `mv ~/.config/my_app_configs/ .config/`
so that it all matches the home directory

2. in `dotfiles/` do `stow -t "$HOME" .`

3. add to git, push and pray
