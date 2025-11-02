#!/bin/bash

# Simplified aerospace workspace indicator
# Shows single icon per workspace based on state

source "$CONFIG_DIR/colors-catppuccin.sh"

# Get the workspace ID passed as argument
SID=$1

# Check if this is the focused workspace
FOCUSED=$(aerospace list-workspaces --focused)

# Check if workspace has windows
WINDOW_COUNT=$(aerospace list-windows --workspace "$SID" --format "%{app-name}" 2>/dev/null | wc -l | tr -d ' ')

# Use consistent coffee cup icon like the reference implementation
ICON="󰃃"

# If workspace is empty, hide it
if [ "$WINDOW_COUNT" -eq 0 ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# Determine colors based on state
if [ "$SID" = "$FOCUSED" ]; then
    # Active workspace
    ICON_COLOR=$MAUVE
    BG_COLOR=$SURFACE1
    BORDER_COLOR=$MAUVE
    BORDER_WIDTH=2
else
    # Has windows but not focused
    ICON_COLOR=$TEXT
    BG_COLOR=$SURFACE0
    BORDER_COLOR=$SURFACE2
    BORDER_WIDTH=1
fi

# Set the workspace appearance
sketchybar --set "$NAME" \
    icon="$ICON" \
    label="$SID" \
    label.drawing=on \
    label.padding_left=4 \
    icon.color="$ICON_COLOR" \
    label.color="$ICON_COLOR" \
    background.color="$BG_COLOR" \
    background.border_color="$BORDER_COLOR" \
    background.border_width="$BORDER_WIDTH" \
    drawing=on
