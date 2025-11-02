#!/bin/bash

# AeroSpace mode indicator
# Shows which aerospace mode is active (main, resize, service)

source "$CONFIG_DIR/plugins/colors.sh"

# Get the mode from aerospace (we'll track it via events)
# For now, we'll show an icon that changes color based on mode

MODE=${MODE:-"main"}

case "$MODE" in
  "resize")
    ICON="󰩨"
    COLOR=$HIGHLIGHT_BACKGROUND
    LABEL="RESIZE"
    ;;
  "service")
    ICON="󰒓"
    COLOR="0xffff9e64"  # Orange
    LABEL="SERVICE"
    ;;
  *)
    ICON=""
    COLOR=$TRANSPARENT
    LABEL=""
    ;;
esac

if [ "$MODE" = "main" ]; then
  sketchybar --set "$NAME" \
    icon="$ICON" \
    label="$LABEL" \
    background.color=$TRANSPARENT \
    drawing=off
else
  sketchybar --set "$NAME" \
    icon="$ICON" \
    label="$LABEL" \
    icon.color=$TEXT_WHITE \
    label.color=$TEXT_WHITE \
    background.color=$COLOR \
    background.padding_left=8 \
    background.padding_right=8 \
    background.corner_radius=6 \
    drawing=on
fi
