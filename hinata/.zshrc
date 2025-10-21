# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

#Add Rust Path
export PATH="$HOME/.cargo/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='nano'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#start Starship
eval "$(starship init zsh)"

#personal aliases
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias ifconfig="echo 'did you mean ip -br a?' ; ip -br a"
alias ipaddr="ip -color -br a"
alias ff="fastfetch"
alias py="$(command -v python3 || command -v python)"

# code paths
export RAIDROOT="/mnt/raid"
alias cdgit='cd "$RAIDROOT/mycode"'
alias gitclone='cd "$RAIDROOT/gitclones"'
alias workcode='cd "$RAIDROOT/workcode"'

#pacman helpers
alias whichorphans="pacman -Qdtq"
alias removeorphans="pacman -Qdtq | sudo pacman -Rns -"
alias listaur='pacman -Qqm'
alias listpac='comm -23 <(pacman -Qqe | sort) <(pacman -Qqm | sort)'
alias listupdates='command -v checkupdates >/dev/null && checkupdates || echo "install pacman-contrib for checkupdates first pls"'
alias aurupdates='yay -Qua'

#lulz aliases
alias idolmode="killall wpaperd && wpaperd -c $HOME/.config/wpaperd/idolmode.toml -d"
alias vtubermode="killall wpaperd && wpaperd -c $HOME/.config/wpaperd/vtubermode.toml -d"
alias restorewpaperd="killall wpaperd && wpaperd -c $HOME/.config/wpaperd/config.toml -d"
alias normiemode='killall wpaperd && wpaperd -c $HOME/.config/wpaperd/normiemode.toml -d'
alias moviemode='killall wpaperd && wpaperd -c $HOME/.config/wpaperd/moviemode.toml -d'

#function aliases
function fuck() { sudo $(fc -ln -1); }

# jump to a subdirectory in ~/.config
conf() {
  local target="$HOME/.config/${1:-}"
  if [[ -z "$1" ]]; then
    cd "$HOME/.config" || return
  elif [[ -d "$target" ]]; then
    cd "$target" || return
  else
    echo "No such directory: $target"
  fi
}

# smart tab completion for ~/.config subdirs
_conf_complete() {
  _files -W "$HOME/.config" -/
}
compdef _conf_complete conf

# open Hyprland config files quickly
hyprconf() {
  local target="$HOME/.config/hypr/${1:-hyprland.conf}"
  [ -e "$target" ] && $EDITOR "$target" || echo "No such config: $target"
}
# smart tab completion for hyprconf
_hyprconf_complete() {
  _files -W "$HOME/.config/hypr"
}
compdef _hyprconf_complete hyprconf

# activate venv
function va() {
  if [ -f .venv/bin/activate ]; then
    source .venv/bin/activate
  elif [ -f venv/bin/activate ]; then
    source venv/bin/activate
  else
    echo "No .venv found in $(pwd)"
  fi
}


# path env vars
export ZSHCONF="$HOME/.zshrc"
export NNMODELS="/mnt/raid/imagegen/ComfyUI/models/"

# test secrets handling
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Created by `pipx` on 2024-08-08 22:05:56
export PATH="$PATH:/home/ntsu/.local/bin"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/ntsu/.dart-cli-completion/zsh-config.zsh ]] && . /home/ntsu/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

