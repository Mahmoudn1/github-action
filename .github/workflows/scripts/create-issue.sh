#!/bin/bash

added_text="${{ steps.extract-modified-lines.outputs.added }}"
removed_text="${{ steps.extract-modified-lines.outputs.removed }}"

title="CMS Change PR ${{ github.event.pull_request.number }}"
echo "$added_text"
echo "$removed_text"

# Create table for added lines
added_table="**Added Lines:**\n\n| Key | Value |\n|-----|-------|\n"
IFS='!@@!!' read -r -a added_lines_array <<< "$added_text"
for i in "${!added_lines_array[@]}"; do
IFS=':' read -r key value <<< "${added_lines_array[i]}"
added_table+="| $key | $value |\n"
done

echo "$added_table"

# Create table for removed lines
removed_table="**Removed Lines:**\n\n| Key | Value |\n|-----|-------|\n"
IFS='!@@!!' read -r -a removed_lines_array <<< "$removed_text"
for i in "${!removed_lines_array[@]}"; do
IFS=':' read -r key value <<< "${removed_lines_array[i]}"
removed_table+="| $key | $value |\n"
done

echo "$removed_table"

# Combine both tables in the body
body="$added_table\n\n$removed_table"

status="[\"Todo\"]"

response=$(curl -L \
-X POST \
-H "Accept: application/vnd.github+json" \
-H "X-GitHub-Api-Version: 2022-11-28" \
-H "Authorization: Bearer ${{ secrets.GITHUB_TOKEN }}" \
https://api.github.com/repos/Mahmoudn1/github-action/issues \
-d "{\"title\":\"$title\",\"body\":\"$body\",\"status\":$status}")

# Set the output variable
issue_id=$(echo "$response" | jq -r '.node_id')
echo "::set-output name=issue_id::${issue_id}"