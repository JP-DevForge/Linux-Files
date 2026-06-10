# =========================
# Historial
# =========================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY


# =========================
# Colores
# =========================

autoload -U colors && colors


# =========================
# Completado
# =========================

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' completer _complete _ignored

zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories


# =========================
# FZF
# =========================

source /usr/share/doc/fzf/examples/key-bindings.zsh


# =========================
# Atuin
# =========================

export ATUIN_TMUX_POPUP=false
eval "$(atuin init zsh --disable-up-arrow)"


# =========================
# Autosuggestions
# =========================

_zsh_autosuggest_strategy_smart() {
    local buf="${1:-$BUFFER}"
    suggestion=""

    local path_cmds='(cd|z|zi|yy|ls|ll|dir|vdir|tree|du|df|mount|umount|mkdir|rmdir|rm|cp|mv|ln|chmod|chown|chgrp|touch|cat|less|more|nano|vim|nvim|code|kate|tar|zip|unzip|rsync|scp)'

    if [[ "$buf" == ${~path_cmds}\ * ]]; then
        _zsh_autosuggest_strategy_completion "$buf"
        return
    fi

    _zsh_autosuggest_strategy_atuin "$buf"

    [[ -n "$suggestion" ]] && return

    if [[ "$buf" != *" "* && ${#buf} -ge 4 ]]; then
        _zsh_autosuggest_strategy_completion "$buf"
    fi
}

ZSH_AUTOSUGGEST_STRATEGY=(smart)

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# =========================
# Alias
# =========================

alias ll='ls -lah'
alias update='paru -Syu'


# =========================
# Teclado estilo Bash
# =========================

bindkey -e

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word


# =========================
# Prompt
# =========================

eval "$(starship init zsh)"


# =========================
# Fastfetch
# =========================

if [[ -t 1 ]] && [[ -z "$SSH_TTY" ]]; then
    fastfetch
fi


# =========================
# Zoxide
# =========================

eval "$(zoxide init zsh)"


# =========================
# Yazi
# =========================

function yy() {
    local tmp="$(mktemp -t yazi-cwd.XXXXXX)"
    yazi "$@" --cwd-file="$tmp"

    if cwd="$(cat "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
        builtin cd "$cwd"
    fi

    rm -f "$tmp"
}
fastfetch
