#!/bin/bash

source "$CONFIG_DIR/colors-catppuccin.sh"

# Get CPU usage
CPU_USAGE=$(top -l 2 -n 0 -F -R | grep "CPU usage" | tail -1 | awk '{print $3}' | sed 's/%//')

# Get Memory info (in GB)
MEMORY_STATS=$(vm_stat | awk '
    /Pages active/ { active = $3 }
    /Pages wired down/ { wired = $4 }
    /Pages occupied by compressor/ { compressed = $5 }
    END {
        gsub(/\./, "", active)
        gsub(/\./, "", wired)
        gsub(/\./, "", compressed)

        page_size = 16384
        used_pages = active + wired + compressed
        used_gb = (used_pages * page_size) / 1024 / 1024 / 1024

        printf "%.0f", used_gb
    }
')

# Get total memory
TOTAL_MEMORY=$(sysctl -n hw.memsize | awk '{printf "%.0f", $1/1024/1024/1024}')

# Calculate memory percentage
MEMORY_PERCENT=$(echo "scale=0; ($MEMORY_STATS / $TOTAL_MEMORY) * 100" | bc)

# Determine color based on usage
if (( $(echo "$CPU_USAGE > 80" | bc -l) )) || (( MEMORY_PERCENT > 85 )); then
    COLOR=$RED
elif (( $(echo "$CPU_USAGE > 60" | bc -l) )) || (( MEMORY_PERCENT > 70 )); then
    COLOR=$YELLOW
else
    COLOR=$GREEN
fi

# Format: CPU% | RAM GB
LABEL="${CPU_USAGE}% | ${MEMORY_STATS}G"

sketchybar --set "$NAME" label="$LABEL" icon.color="$COLOR" label.color="$TEXT"
