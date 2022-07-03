#!/bin/bash
set -ex

export AUTIFY_GITHUB_ORG="autifyhq"

AUTIFY_MOBILE_SCRIPT_BRANCH="<<parameters.mobile_cli_branch_name>>"
if [ -z "$AUTIFY_MOBILE_SCRIPT_BRANCH" ]; then
  AUTIFY_MOBILE_SCRIPT_BRANCH="main"
fi
if [[ "$AUTIFY_MOBILE_SCRIPT_BRANCH" =~ ":" ]]; then
  ORG=( "${AUTIFY_MOBILE_SCRIPT_BRANCH//:/ }" )
  AUTIFY_GITHUB_ORG=${ORG[0]}
  AUTIFY_MOBILE_SCRIPT_BRANCH=${ORG[1]}
fi

readonly AUTIFY_MOBILE_SCRIPT_NAME="autify_mobile_cli.sh"
export AUTIFY_MOBILE_SCRIPT="https://raw.githubusercontent.com/${AUTIFY_GITHUB_ORG}/autify-for-mobile-cli/${AUTIFY_MOBILE_SCRIPT_BRANCH}/autify_mobile_cli.sh"
readonly WORKIND_DIR="./"

echo "* mobile_script_branch_name: ${AUTIFY_MOBILE_SCRIPT_BRANCH}"

# download script
curl -L -o "$WORKIND_DIR/$AUTIFY_MOBILE_SCRIPT_NAME" "$AUTIFY_MOBILE_SCRIPT"
chmod 777 "$WORKIND_DIR/$AUTIFY_MOBILE_SCRIPT_NAME"
