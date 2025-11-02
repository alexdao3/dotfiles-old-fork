#!/bin/bash

# Aerospace workspace indicator with app icons
# Shows icon based on the app running in the workspace

source "$CONFIG_DIR/colors-catppuccin.sh"

# Get the workspace ID passed as argument
SID=$1

# Check if this is the focused workspace
FOCUSED=$(aerospace list-workspaces --focused)

# Get the first app name in this workspace
FIRST_APP=$(aerospace list-windows --workspace "$SID" --format "%{app-name}" 2>/dev/null | head -1)
WINDOW_COUNT=$(aerospace list-windows --workspace "$SID" --format "%{app-name}" 2>/dev/null | wc -l | tr -d ' ')

# If workspace is empty, hide it
if [ "$WINDOW_COUNT" -eq 0 ]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# Use SketchyBar's built-in icon mapping (SF Symbols)
# Source the icon map function from the old config
source "$CONFIG_DIR/plugins/icon_map_fn.sh"

# Get the icon for the app
icon_map "$FIRST_APP"
ICON="$icon_result"

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
