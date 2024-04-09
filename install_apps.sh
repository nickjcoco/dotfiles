#!/bin/bash

# Determine OS name
os=$(uname)

# Install curl, git, neovim, and zsh
if [ "$os" = "Linux" ]; then
    echo "This is a Linux machine"
    if [[ -f /etc/redhat-release ]]; then
        pkg_manager=yum
    elif [[ -f /etc/debian_version ]]; then
        pkg_manager=apt
    fi
    if [ $pkg_manager = "yum" ]; then
        sudo yum install curl git neovim zsh -y
    elif [ $pkg_manager = "apt" ]; then
        sudo apt install curl git neovim zsh -y
    fi
elif [ "$os" = "Darwin" ]; then
    echo "This is a Mac Machine"
    brew install curl git neovim zsh
else
    echo "Unsupported OS"
    exit 1
fi

# Install oh-my-zsh and clone plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Copy aliases and zshrc files to home directory
cp $HOME/dotfiles/.aliases $HOME/.aliases
cp $HOME/dotfiles/.zshrc $HOME/.zshrc && source $HOME/.zshrc

# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh

echo "Apps installed!"

# Test the configuration
echo "Testing git configuration..."

if git --version >/dev/null 2>&1; then
    echo "Git is configured correctly."
else
    echo "Git configuration test failed. Please check the installation."
fi

# Auto-remove automatically installed packages no longer needed
sudo apt autoremove -y
