#!/usr/bin/env bash
# Creates or updates the sprint: labels from sprint-labels.txt.
# Usage: scripts/sprint-labels.sh [repo ...]   (default: all repos below)
set -euo pipefail

REPOS=(
  respiree-backend
  respiree-dashboard
  respiree-mobile
  rpm_data_processing_backend
  respiree-event-scheduler
  backend_ai_service
)
[ $# -gt 0 ] && REPOS=("$@")

FILE="$(dirname "$0")/../sprint-labels.txt"

for repo in "${REPOS[@]}"; do
  gh label create "sprint: none" --repo "Respiree/$repo" --color CFD3D7 \
    --description "Work outside a sprint" --force
  while IFS='|' read -r short full; do
    short="$(sed "s/^ *//;s/ *$//" <<< "$short")"
    full="$(sed "s/^ *//;s/ *$//" <<< "$full")"
    [ -z "$short" ] || [[ "$short" == \#* ]] && continue
    gh label create "sprint: $short" --repo "Respiree/$repo" --color 1D76DB \
      --description "$full" --force
  done < "$FILE"
  echo "ok: Respiree/$repo"
done
