#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

npm run lint:all && npm run build && npm run test


