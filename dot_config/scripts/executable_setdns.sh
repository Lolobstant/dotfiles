#!/usr/bin/env bash
# ~/.config/scripts/setdns.sh
# Appelé par com.user.dnscrypt-setdns LaunchAgent
# Force DNS → 127.0.0.1 sur toutes les interfaces réseau actives

while IFS= read -r svc; do
  case "$svc" in
    "An asterisk"*) continue ;;
    "USB "*|"iPhone "*|"Thunderbolt "*) continue ;;
  esac
  networksetup -setdnsservers "$svc" 127.0.0.1 2>/dev/null || true
done < <(networksetup -listallnetworkservices | tail -n +2)
