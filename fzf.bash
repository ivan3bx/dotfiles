# Setup fzf
# ---------
if command -v brew >/dev/null 2>&1; then
  FZF_PREFIX="$(brew --prefix)/opt/fzf"
else
  FZF_PREFIX="/usr/local/opt/fzf"
fi

if [[ ! "$PATH" == *"$FZF_PREFIX/bin"* ]]; then
  export PATH="${PATH:+${PATH}:}$FZF_PREFIX/bin"
fi

# Auto-completion
# ---------------
if [[ -n "$BASH_VERSION" ]]; then
  [[ $- == *i* ]] && source "$FZF_PREFIX/shell/completion.bash" 2> /dev/null
elif [[ -n "$ZSH_VERSION" ]]; then
  [[ $- == *i* ]] && source "$FZF_PREFIX/shell/completion.zsh" 2> /dev/null
fi

# Key bindings
# ------------
if [[ -n "$BASH_VERSION" ]]; then
  source "$FZF_PREFIX/shell/key-bindings.bash"
elif [[ -n "$ZSH_VERSION" ]]; then
  source "$FZF_PREFIX/shell/key-bindings.zsh"
fi
