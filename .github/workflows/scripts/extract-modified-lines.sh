#!/bin/bash

branch=${GITHUB_HEAD_REF:-${GITHUB_REF#refs/heads/}}

# Fetch the latest changes from the remote repository
git fetch origin main
git fetch origin $branch

# Get the added lines between origin/main and origin/$branch

added_lines=$(git diff ${{github.event.before}}..${{github.sha}} -- CMS/internationalisation_de_DE.json | grep '^+' | tail -n +2 | sed 's/^+ //' | sed 's/,$//')
removed_lines=$(git diff ${{github.event.before}}..${{github.sha}} -- CMS/internationalisation_de_DE.json | grep '^-' | tail -n +2 | sed 's/^- //' | sed 's/,$//')

# Use comm to find common lines between added_lines and removed_lines
common_lines=$(comm -12 <(echo "$added_lines" | sort) <(echo "$removed_lines" | sort))

# Remove common lines from added_lines and removed_lines if exist
if [ -n "$common_lines" ]; then
added_lines=$(grep -vFf <(echo "$common_lines") <(echo "$added_lines"))
removed_lines=$(grep -vFf <(echo "$common_lines") <(echo "$removed_lines"))
fi

added_lines_single_line=$(echo "$added_lines" | tr '\n' '!@@!!' | sed 's/,$//')
removed_lines_single_line=$(echo "$removed_lines" | tr '\n' '!@@!!' | sed 's/,$//')

added_text_removed_quotes=$(echo "$added_lines_single_line"| tr -d '"')
removed_text_removed_quotes=$(echo "$removed_lines_single_line"| tr -d '"')

echo "::set-output name=added::${added_text_removed_quotes}"
echo "::set-output name=removed::${removed_text_removed_quotes}"
