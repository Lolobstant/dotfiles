#!/usr/bin/env bash
# setup_ssh_keys.sh — migration clé existante + setup multi-contexte
# Usage : ./setup_ssh_keys.sh
# Idempotent : ne touche pas les clés existantes
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RESET='\033[0m'
ok()   { echo -e "${GREEN}✓${RESET} $*"; }
info() { echo -e "${BLUE}▶${RESET} $*"; }
warn() { echo -e "${YELLOW}⚠${RESET}  $*"; }

mkdir -p ~/.ssh && chmod 700 ~/.ssh

# ─── Étape 1 : migration clé existante → symlink perso ───────────────────────
info "Migration id_ed25519_github → id_ed25519_github_perso..."

SRC="$HOME/.ssh/id_ed25519_github"
DST="$HOME/.ssh/id_ed25519_github_perso"

if [[ ! -f "$SRC" && ! -f "$DST" ]]; then
  warn "Aucune clé trouvée — génération d'une nouvelle clé perso..."
  EMAIL="${1:-$(git config --global user.email || echo "")}"
  [[ -z "$EMAIL" ]] && { echo "Usage: $0 <email>"; exit 1; }
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$DST" -N ""
  ok "Clé générée : $DST"
elif [[ -f "$SRC" && ! -f "$DST" && ! -L "$DST" ]]; then
  # Clé existante, pas encore migrée → créer symlink
  ln -sf "id_ed25519_github" "$DST"
  ln -sf "id_ed25519_github.pub" "${DST}.pub"
  ok "Symlink créé : $DST → id_ed25519_github"
elif [[ -L "$DST" ]]; then
  ok "Symlink déjà en place : $DST → $(readlink "$DST")"
elif [[ -f "$DST" ]]; then
  ok "Clé déjà présente : $DST"
fi

# ─── Étape 2 : vérifier la clé dans l'agent ───────────────────────────────────
info "Ajout de la clé à l'agent..."
REAL_KEY="$(readlink -f "$DST" 2>/dev/null || echo "$DST")"
if ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf "$REAL_KEY" 2>/dev/null | awk '{print $2}')"; then
  ok "Clé déjà dans l'agent"
else
  ssh-add --apple-use-keychain "$REAL_KEY" 2>/dev/null \
    || ssh-add "$REAL_KEY"
  ok "Clé ajoutée à l'agent"
fi

# ─── Étape 3 : afficher l'état et les instructions ────────────────────────────
echo ""
echo "══════════════════════════════════════════════"
echo "  Clé publique active"
echo "══════════════════════════════════════════════"
cat "${DST}.pub"

echo ""
echo "══════════════════════════════════════════════"
echo "  Étapes manuelles"
echo "══════════════════════════════════════════════"
echo ""
echo "1. Vérifier que la clé est bien sur GitHub :"
echo "   github.com → Settings → SSH and GPG keys"
echo ""
echo "2. Tester les deux aliases :"
echo "   ssh -T git@github-perso   # → Hi Lolobstant!"
echo "   ssh -T git@github-pro     # → Hi Lolobstant! (même compte pour l'instant)"
echo ""
echo "3. Mettre à jour tes remotes existants :"
echo "   # Dans les repos perso :"
echo "   git remote set-url origin git@github-perso:Lolobstant/\$(basename \$(pwd)).git"
echo "   # Dans les repos pro :"
echo "   git remote set-url origin git@github-pro:org/\$(basename \$(pwd)).git"
echo ""
echo "4. Quand tu crées un compte GitHub pro séparé :"
echo "   ssh-keygen -t ed25519 -C 'pro@startup.com' -f ~/.ssh/id_ed25519_github_pro"
echo "   → Changer IdentityFile de 'github-pro' dans ~/.ssh/config"
echo "   → Ajouter la clé publique au compte GitHub pro"
