#!/bin/bash
echo "$(playerctl metadata --format '{{title}} @ {{artist}}')"

