#!/bin/bash

# Update vim plugins (git submodules) to latest versions
# This script ensures all vim plugins are properly initialized and updated

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIM_PLUGINS_DIR="$DOTFILES_DIR/vim/pack/plugins/start"

echo "Updating vim plugins (git submodules)..."
echo "Dotfiles directory: $DOTFILES_DIR"
echo

# Check if we're in a git repository
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    echo "ERROR: Not in a git repository. Please run this script from the dotfiles directory."
    exit 1
fi

# Initialize any uninitialized submodules
echo "🔧 Initializing submodules..."
if git submodule init; then
    echo "✓ Submodules initialized"
else
    echo "❌ Failed to initialize submodules"
    exit 1
fi

# Update all submodules to latest commit on their default branch
echo
echo "📥 Updating submodules to latest versions..."
if git submodule update --init --recursive --remote; then
    echo "✓ Submodules updated successfully"
else
    echo "❌ Failed to update submodules"
    exit 1
fi

# Check vim plugins directory
echo
echo "📂 Checking vim plugins directory..."
if [[ -d "$VIM_PLUGINS_DIR" ]]; then
    plugin_count=$(find "$VIM_PLUGINS_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)
    echo "✓ Found $plugin_count plugins in $VIM_PLUGINS_DIR"
    
    # List plugins
    echo
    echo "📋 Installed plugins:"
    for plugin in "$VIM_PLUGINS_DIR"/*; do
        if [[ -d "$plugin" ]]; then
            plugin_name=$(basename "$plugin")
            if [[ -d "$plugin/.git" ]]; then
                cd "$plugin"
                branch=$(git branch --show-current 2>/dev/null || echo "detached")
                latest_commit=$(git log -1 --format="%h - %s" 2>/dev/null || echo "unknown")
                echo "  📦 $plugin_name [$branch] - $latest_commit"
                cd "$DOTFILES_DIR"
            else
                echo "  📦 $plugin_name (not a git repository)"
            fi
        fi
    done
else
    echo "⚠️  Vim plugins directory not found: $VIM_PLUGINS_DIR"
fi

# Show any submodule status
echo
echo "📊 Submodule status:"
git submodule status

echo
echo "🎉 Vim plugin update complete!"
echo
echo "💡 Tips:"
echo "  - Restart vim to load updated plugins"
echo "  - Run :PluginInstall if using a plugin manager"
echo "  - Check vim startup for any plugin errors"