# kickstart.nvim

Personal nvim configuration, feel free to use it

## Installation

I'll only provide information for how to install kickstart on OSs and distros that I used Neovim.

### Linux

#### Ubuntu/Debian

```sh
# Install/update dependencies/packages needed
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip fonts-noto-color-emoji fd-find curl tar
curl https://sh.rustup.rs -sSf | sh # for cargo package manager, just go with the default installation (press enter or type 1)

# Install nerd font
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.zip
mkdir -p /usr/local/share/fonts
sudo mv 0xProto.zip /usr/local/share/fonts/
unzip /usr/local/share/fonts/0xProto.zip
sudo rm -f /usr/local/share/fonts/README.md /usr/local/share/fonts/LICENSE /usr/local/share/fonts/0xProto.zip
sudo fc-cache -f -v

# Install/update Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzvf nvim-linux-x86_64.tar.gz
rm -rf $HOME/.local/lib/nvim/ $HOME/.local/share/nvim/runtime/
mv ./nvim-linux-x86_64/bin/nvim $HOME/.local/bin/
mv ./nvim-linux-x86_64/lib/nvim/ $HOME/.local/lib/
mv ./nvim-linux-x86_64/share/applications/nvim.desktop $HOME/.local/share/applications/
mv ./nvim-linux-x86_64/share/icons/hicolor/128x128/apps/nvim.png $HOME/.local/share/icons/hicolor/128x128/apps/
mv ./nvim-linux-x86_64/share/man/man1/nvim.1 $HOME/.local/share/man/man1/
mkdir -p $HOME/.local/share/nvim/ && mv ./nvim-linux-x86_64/share/nvim/runtime/ $HOME/.local/share/nvim/
rm -rf ./nvim-linux-x86_64/

# Install kickstart and open Neovim
git clone https://github.com/hennique/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
nvim
```
