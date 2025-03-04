# 🤟 Crisidev Neovim Configs 🤟

Personal Neovim configuration based on [LazyVim](https://www.lazyvim.org/).

Take what you need, it also comes warrant free 😊

## Look and feel

![Rust](rust.png)

## Info

* My config is heavy and extremely personalized for my needs and it will probably not work for
  you out of the box.. **Take it as an inspiration**.
* I am usually up to date with Neovim HEAD.

## Installation

```sh
❯❯❯ git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
❯❯❯ git clone https://github.com/crisidev/lazyvim.git $HOME/.homesick/repos/lazyvim
❯❯❯ source "$HOME/.homesick/repos/homeshick/homeshick.sh"
❯❯❯ homeshick link lazyvim
```

## Update mason-ensure-installed

```sh
❯❯❯ echo "$(cat ~/.local/state/nvim/mason.log |grep "Installation succee" |awk -F'for Package' '{print $2}' |sed 's/(name=//g'| sed 's/)//g' | sort -u |xargs)" > ~/.config/nvim/mason-ensure-installed
```

## Update Mason installed plugins

```sh
❯❯❯ vim "+MasonInstall $(cat ~/.config/nvim/mason-ensure-installed)"
```
```
