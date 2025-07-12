#!/bin/bash

# Dotfiles installation script
# Creates symlinks from ~/.dotfiles/* to ~/*

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$(dirname "$DOTFILES_DIR")"

# Files to symlink (source:target pairs)
DOTFILES=(
    "fzf.bash:.fzf.bash"
    "gemrc:.gemrc"
    "rgconfig:.rgconfig"
    "vim:.vim"
    "vimrc:.vimrc"
    "grc:.grc"
)

echo "Installing dotfiles from $DOTFILES_DIR to $HOME_DIR"
echo

# Check for conflicts first
conflicts=()
for entry in "${DOTFILES[@]}"; do
    source="${entry%:*}"
    target="${entry#*:}"
    target_path="$HOME_DIR/$target"
    source_path="$DOTFILES_DIR/$source"
    
    # Only report conflict if target exists and is NOT a symlink to our source
    if [[ -e "$target_path" ]]; then
        if [[ ! -L "$target_path" ]]; then
            # Target exists but is not a symlink
            conflicts+=("$target (regular file/directory)")
        else
            # Target is a symlink - check if it points to our source
            current_link="$(readlink "$target_path")"
            # Handle both absolute and relative paths
            if [[ "$current_link" == "$source_path" ]] || [[ "$current_link" == ".dotfiles/$source" ]]; then
                # Already correctly linked, no conflict
                :
            else
                # Symlink points elsewhere
                conflicts+=("$target (symlink to $current_link)")
            fi
        fi
    fi
done

# Exit if conflicts found
if [[ ${#conflicts[@]} -gt 0 ]]; then
    echo "ERROR: The following files already exist and would be overwritten:"
    for conflict in "${conflicts[@]}"; do
        echo "  $HOME_DIR/$conflict"
    done
    echo
    echo "Please backup or remove these files before running the installer."
    exit 1
fi

# Create symlinks
for entry in "${DOTFILES[@]}"; do
    source="${entry%:*}"
    target="${entry#*:}"
    source_path="$DOTFILES_DIR/$source"
    target_path="$HOME_DIR/$target"
    
    if [[ ! -e "$source_path" ]]; then
        echo "WARNING: Source file $source_path does not exist, skipping..."
        continue
    fi
    
    # Check if already correctly linked
    if [[ -L "$target_path" ]]; then
        current_link="$(readlink "$target_path")"
        if [[ "$current_link" == "$source_path" ]] || [[ "$current_link" == ".dotfiles/$source" ]]; then
            echo "✓ $target already correctly linked"
            continue
        fi
    fi
    
    # Create the symlink
    ln -sf "$source_path" "$target_path"
    echo "✓ Created symlink: $target -> $source"
done

echo
echo "Dotfiles installation complete!"
echo
echo "Note: You may need to manually configure:"
echo "  - ~/.gitconfig to include .dotfiles/gitconfig"
echo "  - ~/.bash_profile to source .dotfiles/bash_profile"