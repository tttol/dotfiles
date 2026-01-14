#!/bin/zsh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
echo "========================================="
echo "Syncing all configurations..."
echo "========================================="
echo ""
SUCCESS_COUNT=0
FAIL_COUNT=0
FAILED_SCRIPTS=()
while IFS= read -r -d '' script; do
  SCRIPT_NAME=$(basename "$script")
  SCRIPT_DIR_PATH=$(dirname "$script")
  DIR_NAME=$(basename "$SCRIPT_DIR_PATH")
  echo "[$DIR_NAME] Executing $SCRIPT_NAME..."
  if (cd "$SCRIPT_DIR_PATH" && bash "$SCRIPT_NAME"); then
    echo "[$DIR_NAME] ✓ Success"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    echo "[$DIR_NAME] ✗ Failed"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    FAILED_SCRIPTS+=("$DIR_NAME/$SCRIPT_NAME")
  fi
  echo ""
done < <(find . -type f -name "copy_*_config.sh" -print0 | sort -z)
echo "========================================="
echo "Summary:"
echo "  Success: $SUCCESS_COUNT"
echo "  Failed:  $FAIL_COUNT"
if [ $FAIL_COUNT -gt 0 ]; then
  echo ""
  echo "Failed scripts:"
  for failed in "${FAILED_SCRIPTS[@]}"; do
    echo "  - $failed"
  done
  exit 1
fi
echo "========================================="
echo "All configurations synced successfully!"
