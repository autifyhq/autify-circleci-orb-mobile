#!/bin/bash
set -ex

export AUTIFY_PROJECT_ID="<<parameters.autify_project_id>>"
export AUTIFY_APP_DIR_PATH="<<parameters.autify_app_dir_path>>"
export AUTIFY_UPLOAD_TOKEN="<<parameters.autify_upload_token>>"
exec ./autify_mobile_cli.sh
