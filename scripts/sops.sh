#!/usr/bin/env bash

set -euo pipefail

status=0

for file in "$@"; do
  if grep -Eq "^sops:" "$file"; then
    echo "[sops] skip $file"
    continue
  fi

  echo "[sops] encrypting $file"
  if ! sops --encrypt --in-place "$file"; then
    status=1
  fi
done

exit $status
