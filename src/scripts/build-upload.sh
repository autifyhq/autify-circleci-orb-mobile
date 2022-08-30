#!/usr/bin/env bash

AUTIFY="${INPUT_AUTIFY_PATH}"

ACCESS_TOKEN="${!INPUT_ACCESS_TOKEN}"

if [ -z "${ACCESS_TOKEN}" ]; then
  echo "Missing access-token."
  exit 1
fi

ARGS=()

function add_args() {
  ARGS+=("$1")
}

if [ -n "${INPUT_BUILD_PATH}" ]; then
  add_args "${INPUT_BUILD_PATH}"
else
  echo "Missing build-path."
  exit 1
fi

if [ -n "${INPUT_WORKSPACE_ID}" ]; then
  add_args "--workspace-id=${INPUT_WORKSPACE_ID}"
else
  echo "Missing workspace-id."
  exit 1
fi

AUTIFY_MOBILE_ACCESS_TOKEN="${ACCESS_TOKEN}" "${AUTIFY}" mobile build upload "${ARGS[@]}"
