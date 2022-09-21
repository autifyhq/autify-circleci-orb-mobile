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

if [ -n "${INPUT_AUTIFY_TEST_URL}" ]; then
  add_args "${INPUT_AUTIFY_TEST_URL}"
else
  echo "Missing autify-test-url."
  exit 1
fi

if [ -n "${INPUT_BUILD_ID}" ] && [ -n "${INPUT_BUILD_PATH}" ]; then
  echo "Can't specify both build-id and build-path."
  exit 1
elif [ -n "${INPUT_BUILD_ID}" ]; then
  add_args "--build-id=${INPUT_BUILD_ID}"
elif [ -n "${INPUT_BUILD_PATH}" ]; then
  add_args "--build-path=${INPUT_BUILD_PATH}"
else
  echo "Specify either build-id or build-path."
  exit 1
fi

if [ "${INPUT_VERBOSE}" -eq 1 ]; then
  add_args "--verbose"
fi

if [ "${INPUT_WAIT}" -eq 1 ]; then
  add_args "--wait"
fi

if [ -n "${INPUT_TIMEOUT}" ]; then
  add_args "-t=${INPUT_TIMEOUT}"
fi

if [ -n "${INPUT_MAX_RETRY_COUNT}" ]; then
  add_args "--max-retry-count=${INPUT_MAX_RETRY_COUNT}"
fi

AUTIFY_MOBILE_ACCESS_TOKEN="${ACCESS_TOKEN}" "${AUTIFY}" mobile test run "${ARGS[@]}"
