#!/bin/bash

set -eEu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_FILES_DIR="${SCRIPT_DIR}/../servers"

main() {
  local -r SERVER_IP_ADDR="${1}"

  echo "Setting up zsh on ${SERVER_IP_ADDR}"

  scp "${CONFIG_FILES_DIR}/zshrc" "${SERVER_IP_ADDR}:.zshrc"
  scp "${CONFIG_FILES_DIR}/p10k.zsh" "${SERVER_IP_ADDR}:.p10k.zsh"
}

main $@
