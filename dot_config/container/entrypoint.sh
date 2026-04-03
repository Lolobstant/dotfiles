#!/bin/bash
set -euo pipefail

# Bootstrap dotfiles via chezmoi — seulement si pas encore initialisé
if [ -n "${DOTFILES_REPO:-}" ]; then
  if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "⚡ Bootstrap dotfiles depuis ${DOTFILES_REPO}"
    chezmoi init --apply "${DOTFILES_REPO}"
  else
    echo "⚡ Dotfiles déjà initialisés, skip"
  fi
fi

exec "$@"
