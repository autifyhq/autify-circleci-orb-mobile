#!/bin/bash
set -ex

curl -s -XPOST \
    -H "Authorization: Bearer ${AUTIFY_FOR_MOBILE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"build_id\":\"<<parameters.build_id>>\"}" \
    "<<parameters.test_plan_api_base_url>>""<<parameters.test_plan_id>>"/test_plan_results \
    > "<<parameters.response_file_path>>"

errors=$(cat "<<parameters.response_file_path>>" | jq .errors)
id=$(cat "<<parameters.response_file_path>>" | jq .id)
data=$(cat "<<parameters.response_file_path>>" | jq .test_plan)

if [ "${errors}" = "null" ]; then
    if [ "${data}" != "null" ]; then
        echo "Successfully started the test plan."
        echo "Test plan name : $(echo "${data}" | jq -r .name)"
        echo "Build : $(echo "${data}" | jq -r .build.name)" "$(echo "${data}" | jq -r .build.version)"
        TEST_PLAN_RESULT_ID=${id}
        echo "Test plan result ID : ${TEST_PLAN_RESULT_ID}"
    else
        # In case the response has neither `data` nor `errors`
        echo "Something went wrong. The response was :"
        cat "<<parameters.response_file_path>>"

        exit 1
    fi
else
    error_messages=$(echo "${errors}" | jq '.[] | .message')
    echo "Error running the test plan. The error messages are :"
    if [ "${error_messages}" = "null" ]; then
        cat "<<parameters.response_file_path>>"
    else
        echo "${error_messages}" | while read -r message; do
            echo "${message}"
        done
    fi

    exit 1
fi
