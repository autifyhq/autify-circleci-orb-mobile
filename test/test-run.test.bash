#!/usr/bin/env bash

log_file=$(dirname "$0")/log


function before() {
  export ACCESS_TOKEN=test
  unset INPUT_AUTIFY_PATH
  unset INPUT_ACCESS_TOKEN
  unset INPUT_AUTIFY_TEST_URL
  unset INPUT_BUILD_ID
  unset INPUT_BUILD_PATH
  export INPUT_VERBOSE=0
  export INPUT_WAIT=0
  unset INPUT_TIMEOUT
  unset INPUT_MAX_RETRY_COUNT
  echo "=== TEST ==="
}

function test_command() {
  local expected=$1
  local result
  result=$(bash ./src/scripts/test-run.sh | head -1)

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
  bash ./src/scripts/test-run.sh > /dev/null
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
  bash ./src/scripts/test-run.sh | tail -n+2 > "$result"

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
  export INPUT_AUTIFY_TEST_URL=a
  export INPUT_BUILD_ID=b
  test_command "autify mobile test run a --build-id=b"
  test_code 0
  test_log
}

{
  before
  export INPUT_AUTIFY_PATH="./test/autify-mock"
  export INPUT_ACCESS_TOKEN=ACCESS_TOKEN
  export INPUT_AUTIFY_TEST_URL=a
  export INPUT_BUILD_ID=b
  export INPUT_VERBOSE=1
  export INPUT_WAIT=1
  export INPUT_TIMEOUT=300
  export INPUT_MAX_RETRY_COUNT=1
  test_command "autify mobile test run a --build-id=b --verbose --wait -t=300 --max-retry-count=1"
  test_code 0
  test_log
}

{
  before
  export INPUT_AUTIFY_PATH="./test/autify-mock"
  export INPUT_ACCESS_TOKEN=ACCESS_TOKEN
  export INPUT_AUTIFY_TEST_URL=a
  export INPUT_BUILD_PATH=c
  test_command "autify mobile test run a --build-path=c"
  test_code 0
  test_log
}

{
  before
  export INPUT_AUTIFY_PATH="./test/autify-mock"
  export INPUT_ACCESS_TOKEN=ACCESS_TOKEN
  export INPUT_AUTIFY_TEST_URL=a
  export INPUT_BUILD_ID=b
  export INPUT_BUILD_PATH=c
  test_command "Can't specify both build-id and build-path."
  test_code 1
}

{
  before
  export INPUT_AUTIFY_PATH="./test/autify-mock-fail"
  export INPUT_ACCESS_TOKEN=ACCESS_TOKEN
  export INPUT_AUTIFY_TEST_URL=a
  export INPUT_BUILD_ID=b
  test_command "autify-fail mobile test run a --build-id=b"
  test_code 1
  test_log
}
