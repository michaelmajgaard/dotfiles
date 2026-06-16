#!/usr/bin/env bash

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mv ~/.config/nvim ~/.config/nvim.backup.$TIMESTAMP

rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.local/state/nvim
