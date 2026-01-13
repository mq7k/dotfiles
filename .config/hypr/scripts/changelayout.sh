#!/usr/bin/bash

# Changes Hyprland keyboard layout.
hyprctl switchxkblayout all next

# Starts/stops the keyd service. 
systemctl is-active --quiet keyd && sudo systemctl stop keyd || sudo systemctl start keyd
