#!/bin/bash

# Weather plugin - shows current weather + city
# Uses wttr.in service (no API key needed)

source "$CONFIG_DIR/colors-catppuccin.sh"

# Get weather data (cached for 30 minutes to avoid rate limiting)
CACHE_FILE="/tmp/sketchybar_weather_cache"
CACHE_MAX_AGE=1800  # 30 minutes in seconds

get_weather() {
  # Get weather from wttr.in in a simple format
  # Format: temperature, condition, location
  # Default to Lisbon
  curl -s "wttr.in/Lisbon?format=%t|%C|Lisbon" 2>/dev/null
}

# Check if cache exists and is fresh
if [ -f "$CACHE_FILE" ]; then
  CACHE_AGE=$(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)))

  if [ $CACHE_AGE -lt $CACHE_MAX_AGE ]; then
    WEATHER=$(cat "$CACHE_FILE")
  else
    WEATHER=$(get_weather)
    echo "$WEATHER" > "$CACHE_FILE"
  fi
else
  WEATHER=$(get_weather)
  echo "$WEATHER" > "$CACHE_FILE"
fi

# Parse temperature, condition, and city
TEMP=$(echo "$WEATHER" | cut -d'|' -f1 | tr -d ' ')
CONDITION=$(echo "$WEATHER" | cut -d'|' -f2 | tr -d ' ')
# Extract just the first part of location (city name), remove commas
CITY=$(echo "$WEATHER" | cut -d'|' -f3 | cut -d',' -f1 | tr -d ' ')

# Map weather conditions to icons
get_weather_icon() {
  case "$1" in
    *[Cc]lear*|*[Ss]unny*)
      echo "󰖙"
      ;;
    *[Cc]loud*|*[Oo]vercast*)
      echo "󰖐"
      ;;
    *[Rr]ain*|*[Dd]rizzle*)
      echo "󰖗"
      ;;
    *[Ss]now*|*[Ss]leet*)
      echo "󰖘"
      ;;
    *[Tt]hunder*|*[Ss]torm*)
      echo "󰖓"
      ;;
    *[Ff]og*|*[Mm]ist*)
      echo "󰖑"
      ;;
    *[Pp]artly*)
      echo "󰖕"
      ;;
    *)
      echo "󰖐"
      ;;
  esac
}

ICON=$(get_weather_icon "$CONDITION")

if [ -n "$TEMP" ]; then
  sketchybar --set "$NAME" \
    icon="$ICON" \
    label="$CITY $TEMP" \
    drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
