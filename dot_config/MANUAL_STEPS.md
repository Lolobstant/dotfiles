## 1. Keychain — secrets bootstrap

\```bash

# Token Homebrew GitHub API

security add-generic-password -a homebrew_api -s <email> -w <TOKEN>

# Clé age (si SOPS retenu)

age-keygen | security add-generic-password -a age -s identity -w "$(cat)"
\```

## 2. Git credentials

\```bash
git config --global user.name "Laurent"
git config --global user.email "<email>"
\```

## 3. SSH keys

\```bash
ssh-keygen -t ed25519 -C "<email>"

# Ajouter la clé publique sur GitHub : https://github.com/settings/keys

\```

## 4. Vérification finale

\```bash

# Tout doit passer

brew bundle check --file=~/.config/homebrew/config.homebrew
zinit self-update
chezmoi status # doit être vide
\```

# loader les clefs ssh

ssh-add --apple-use-keychain ~/.ssh/id_ed25519
