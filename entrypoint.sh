#!/bin/sh -l

num_file_changed=$(jq --raw-output .pull_request.changed_files "$GITHUB_EVENT_PATH")

if [ "$2" = "true" ]; then
  exit 0
fi

if [ "$num_file_changed" -gt "$1" ]; then
  echo "Number of changed files: "$num_file_changed
  echo "Way too many changes. Maximum allowed number of is: "$1
  exit 1
fi
