#!/usr/bin/env bash

log_file=$(dirname "$0")/log


function before() {
  export ACCESS_TOKEN=test
  unset INPUT_AUTIFY_PATH
  unset INPUT_ACCESS_TOKEN
  unset INPUT_BUILD_PATH
  unset INPUT_WORKSPACE_ID
  echo "=== TEST ==="
}

function test_command() {
  local expected=$1
  local result
  result=$(bash ./src/scripts/build-upload.sh | head -1)

  if [ "$result" == "$expected" ]; then
    echo "Passed command: $expected"
  else
    echo "Failed command:"
    echo "  Expected: $expected"
    echo "  Result  : $result"
    exit 1
  fi
}

function test_code() {
  local expected=$1
  bash ./src/scripts/build-upload.sh > /dev/null
  local result=$?

  if [ "$result" == "$expected" ]; then
    echo "Passed code: $expected"
  else
    echo "Failed code:"
    echo "  Expected: $expected"
    echo "  Result  : $result"
    exit 1
  fi
}

function test_log() {
  local result
  result=$(mktemp)
  bash ./src/scripts/build-upload.sh | tail -n+2 > "$result"

  if (git diff --no-index --quiet -- "$log_file" "$result"); then
    echo "Passed log:"
  else
    echo "Failed log:"
    git --no-pager diff --no-index -- "$log_file" "$result"
    exit 1
  fi
}

{
  before
  export INPUT_AUTIFY_PATH="./test/autify-mock"
  export INPUT_ACCESS_TOKEN=ACCESS_TOKEN
  export INPUT_BUILD_PATH=a
  export INPUT_WORKSPACE_ID=b
  test_command "autify mobile build upload a --workspace-id=b"
  test_code 0
  test_log
}

{
  before
  export INPUT_AUTIFY_PATH="./test/autify-mock-fail"
  export INPUT_ACCESS_TOKEN=ACCESS_TOKEN
  export INPUT_BUILD_PATH=a
  export INPUT_WORKSPACE_ID=b
  test_command "autify-fail mobile build upload a --workspace-id=b"
  test_code 1
  test_log
}
