#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

npm -w @my-saas/backend run start:dev


