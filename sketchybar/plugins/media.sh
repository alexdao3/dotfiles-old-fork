#!/bin/bash

# Media player plugin - shows currently playing music from Spotify or Apple Music

source "$CONFIG_DIR/plugins/colors.sh"

# Check if Spotify is running and playing
if pgrep -x "Spotify" > /dev/null; then
  PLAYER="Spotify"
  STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)

  if [ "$STATE" = "playing" ]; then
    TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
    ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)

    ICON="󰓇"
    LABEL="$ARTIST - $TRACK"

    # Truncate if too long
    if [ ${#LABEL} -gt 40 ]; then
      LABEL="${LABEL:0:37}..."
    fi

    sketchybar --set "$NAME" \
      icon="$ICON" \
      label="$LABEL" \
      icon.color=$TEXT_WHITE \
      label.color=$TEXT_GREY \
      drawing=on
    exit 0
  fi
fi

# Check if Apple Music is running and playing
if pgrep -x "Music" > /dev/null; then
  PLAYER="Music"
  STATE=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)

  if [ "$STATE" = "playing" ]; then
    TRACK=$(osascript -e 'tell application "Music" to name of current track as string' 2>/dev/null)
    ARTIST=$(osascript -e 'tell application "Music" to artist of current track as string' 2>/dev/null)

    ICON=""
    LABEL="$ARTIST - $TRACK"

    # Truncate if too long
    if [ ${#LABEL} -gt 40 ]; then
      LABEL="${LABEL:0:37}..."
    fi

    sketchybar --set "$NAME" \
      icon="$ICON" \
      label="$LABEL" \
      icon.color=$TEXT_WHITE \
      label.color=$TEXT_GREY \
      drawing=on
    exit 0
  fi
fi

# Nothing playing - hide the item
sketchybar --set "$NAME" drawing=off
