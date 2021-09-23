#!/bin/sh -l

git init
origin=$(jq --raw-output .repository.git_url "$GITHUB_EVENT_PATH")
git remote add origin ${origin}

num_file_changed=$(jq --raw-output .pull_request.changed_files "$GITHUB_EVENT_PATH")
pr_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

echo "::set-output name=num_file_changed::"$num_file_changed
echo "::set-output name=pr_number::"$pr_number

if [ "$3" = "true" ]; then
  exit 0
fi

if [ "$num_file_changed" -gt "$1" ]; then
  echo "Number of changed files: "$num_file_changed
  echo "Way too many changes. Maximum allowed number of is: "$1
  echo $2 | gh auth login --with-token
  gh pr comment -b "Way too many changes. Maximum allowed number of is: "$1 $pr_number
  exit 1
fi
