#!/bin/bash

source "$CONFIG_DIR/plugins/colors.sh"

# Get CPU usage (average across all cores)
CPU_USAGE=$(top -l 2 -n 0 -F -R | grep "CPU usage" | tail -1 | awk '{print $3}' | sed 's/%//')

# Get Memory info
MEMORY_STATS=$(vm_stat | awk '
    /Pages active/ { active = $3 }
    /Pages inactive/ { inactive = $3 }
    /Pages wired down/ { wired = $4 }
    /Pages occupied by compressor/ { compressed = $5 }
    /File-backed pages/ { file_backed = $3 }
    END {
        gsub(/\./, "", active)
        gsub(/\./, "", inactive)
        gsub(/\./, "", wired)
        gsub(/\./, "", compressed)
        gsub(/\./, "", file_backed)

        # Page size is 16384 bytes on Apple Silicon (M-series)
        page_size = 16384

        # Calculate used memory (active + wired + compressed)
        used_pages = active + wired + compressed
        used_gb = (used_pages * page_size) / 1024 / 1024 / 1024

        printf "%.1f", used_gb
    }
')

# Get total memory
TOTAL_MEMORY=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024}')

# Get swap usage
SWAP_USAGE=$(sysctl vm.swapusage | awk '{print $4}' | sed 's/M//')

# Calculate memory percentage
MEMORY_PERCENT=$(echo "scale=0; ($MEMORY_STATS / $TOTAL_MEMORY) * 100" | bc)

# Determine colors based on usage
get_cpu_color() {
    local cpu=$1
    if (( $(echo "$cpu > 80" | bc -l) )); then
        echo "$TEXT_RED"
    elif (( $(echo "$cpu > 60" | bc -l) )); then
        echo "0xffff9e64"  # Orange
    else
        echo "$TEXT_WHITE"
    fi
}

get_memory_color() {
    local mem=$1
    if (( mem > 90 )); then
        echo "$TEXT_RED"
    elif (( mem > 75 )); then
        echo "0xffff9e64"  # Orange
    else
        echo "$TEXT_WHITE"
    fi
}

get_swap_color() {
    local swap=$1
    if (( $(echo "$swap > 1000" | bc -l) )); then
        echo "$TEXT_RED"
    elif (( $(echo "$swap > 100" | bc -l) )); then
        echo "0xffff9e64"  # Orange
    else
        echo "$TEXT_WHITE"
    fi
}

CPU_COLOR=$(get_cpu_color "$CPU_USAGE")
MEMORY_COLOR=$(get_memory_color "$MEMORY_PERCENT")
SWAP_COLOR=$(get_swap_color "$SWAP_USAGE")

# Format swap nicely
if (( $(echo "$SWAP_USAGE > 1000" | bc -l) )); then
    SWAP_DISPLAY=$(echo "scale=1; $SWAP_USAGE / 1024" | bc)"G"
else
    SWAP_DISPLAY="${SWAP_USAGE}M"
fi

# Build label - simple text without color tags
# Format: CPU | RAM | SWAP
LABEL="${CPU_USAGE}% | ${MEMORY_STATS}G/${TOTAL_MEMORY%%.*}G"

# Only show swap if it's being used
if (( $(echo "$SWAP_USAGE > 10" | bc -l) )); then
    LABEL="$LABEL | 󰓡$SWAP_DISPLAY"
fi

# Set the label and use label color based on worst metric
WORST_COLOR="$TEXT_WHITE"
if [ "$CPU_COLOR" = "$TEXT_RED" ] || [ "$MEMORY_COLOR" = "$TEXT_RED" ] || [ "$SWAP_COLOR" = "$TEXT_RED" ]; then
    WORST_COLOR="$TEXT_RED"
elif [ "$CPU_COLOR" = "0xffff9e64" ] || [ "$MEMORY_COLOR" = "0xffff9e64" ] || [ "$SWAP_COLOR" = "0xffff9e64" ]; then
    WORST_COLOR="0xffff9e64"
fi

sketchybar --set "$NAME" label="$LABEL" label.color="$WORST_COLOR"
