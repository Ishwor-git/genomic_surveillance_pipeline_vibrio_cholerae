#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="runs.txt"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE not found!"
    exit 1
fi

MAIN_DIR="main"
mkdir -p "$MAIN_DIR" 

while IFS= read -r run || [ -n "$run" ]; do
    # Skip empty lines or comments
    [[ -z "$run" || "$run" =~ ^# ]] && continue

    # Trim any trailing whitespace/carriage returns
    run=$(echo "$run" | tr -d '[:space:]')

    echo "=========================================="
    echo "Processing run: $run"
    echo "=========================================="

    # Create a dedicated directory for the run
    RUN_DIR="$MAIN_DIR/$run"
    mkdir -p "$RUN_DIR"

    # Download and split paired-end reads directly into the run's directory
    fasterq-dump --split-files "$run" -O "$RUN_DIR"

    echo "Saved to: $RUN_DIR/"
done < "$INPUT_FILE"

echo "All downloads completed successfully!"
