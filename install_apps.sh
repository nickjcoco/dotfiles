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
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
    if [ "$pkg_manager" = "yum" ]; then
        sudo yum install curl git neovim zsh -y || echo "Failed to install some packages with yum"
    elif [ "$pkg_manager" = "apt" ]; then
        sudo apt update -y && sudo apt install curl git neovim zsh -y || echo "Failed to install some packages with apt"
    fi
elif [ "$os" = "Darwin" ]; then
    echo "This is a Mac Machine"
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found, installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install curl git neovim zsh || echo "Failed to install some packages with brew"
else
    echo "Unsupported OS"
    exit 1
fi

# # Install oh-my-zsh and clone plugins
# if ! command -v zsh >/dev/null 2>&1; then
#     echo "zsh is not installed properly. Skipping oh-my-zsh installation."
# else
#     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "Failed to install oh-my-zsh"
#     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || echo "Failed to clone zsh-autosuggestions"
#     git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || echo "Failed to clone zsh-syntax-highlighting"
#     git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search || echo "Failed to clone zsh-history-substring-search"
# fi

# Install oh-my-zsh and clone plugins
if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh is not installed properly. Skipping oh-my-zsh installation."
else
    # Set zsh as the default shell
    if [ "$(basename "$SHELL")" != "zsh" ]; then
        echo "Setting zsh as the default shell..."
        chsh -s $(which zsh) || echo "Failed to set zsh as the default shell"
    fi

    # Install oh-my-zsh non-interactively
    echo "Installing oh-my-zsh..."
    export RUNZSH=no  # Prevents the installer from running zsh immediately after installation
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || echo "Failed to install oh-my-zsh"

    # Clone plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || echo "Failed to clone zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || echo "Failed to clone zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search || echo "Failed to clone zsh-history-substring-search"
fi

# Copy aliases and zshrc files to home directory
if [ -d "$HOME/dotfiles" ]; then
    cp $HOME/dotfiles/.aliases $HOME/.aliases || echo "Failed to copy .aliases"
    cp $HOME/dotfiles/.zshrc $HOME/.zshrc && source $HOME/.zshrc || echo "Failed to copy or source .zshrc"
else
    echo "Dotfiles directory not found at $HOME/dotfiles. Skipping file copy."
fi

# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh || echo "Failed to install Tailscale"

echo "Apps installed!"

# Test the configuration
echo "Testing git configuration..."
if git --version >/dev/null 2>&1; then
    echo "Git is configured correctly."
else
    echo "Git configuration test failed. Please check the installation."
fi

# Auto-remove automatically installed packages no longer needed
if [ "$pkg_manager" = "apt" ]; then
    sudo apt autoremove -y || echo "Failed to autoremove unused packages"
elif [ "$pkg_manager" = "yum" ]; then
    sudo yum autoremove -y || echo "Failed to autoremove unused packages"
fi
