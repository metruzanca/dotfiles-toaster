# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export EDITOR="hx"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# terminal cheatsheet
if [[ $- == *i* ]]; then
  glow ~/.config/cheatsheet.md
fi

# Auto-start zellij in server mode (no graphical session)
if [[ $- == *i* ]] && ! systemctl is-active --quiet graphical.target 2>/dev/null && command -v zellij &>/dev/null && [[ -z "$ZELLIJ" ]]; then
  exec zellij
fi
