#!/usr/bin/env bash
set -euo pipefail

# Get script directory so it can find runs.txt relative to the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/runs.txt"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE not found!"
    exit 1
fi

MAIN_DIR="$SCRIPT_DIR/reads"
mkdir -p "$MAIN_DIR"

# Optional sample limit passed as the first argument (e.g., ./download.sh 3)
SAMPLE_LIMIT="${1:-}"
download_count=0

while IFS= read -r run || [ -n "$run" ]; do
    # Skip empty lines or comments
    [[ -z "$run" || "$run" =~ ^# ]] && continue

    # Trim any trailing whitespace/carriage returns
    run=$(echo "$run" | tr -d '[:space:]')

    # Check if a sample limit was provided and has been reached
    if [ -n "$SAMPLE_LIMIT" ] && [ "$download_count" -ge "$SAMPLE_LIMIT" ]; then
        echo "Reached the requested sample limit ($SAMPLE_LIMIT). Stopping."
        break
    fi

    echo "=========================================="
    echo "Processing run: $run ($(($download_count + 1))/$([ -n "$SAMPLE_LIMIT" ] && echo "$SAMPLE_LIMIT" || echo "all"))"
    echo "=========================================="

    # Create a dedicated directory for the run
    RUN_DIR="$MAIN_DIR/$run"
    mkdir -p "$RUN_DIR"

    # Download and split paired-end reads directly into the run's directory
    fasterq-dump --split-files "$run" -O "$RUN_DIR"

    echo "Saved to: $RUN_DIR/"
    
    download_count=$((download_count + 1))
done < "$INPUT_FILE"

echo "All downloads completed successfully! Total downloaded: $download_count"
