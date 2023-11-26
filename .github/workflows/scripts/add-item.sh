#!/bin/bash

issue_id="${{ steps.create-issue.outputs.issue_id }}"
response=$(curl --request POST \
    --url https://api.github.com/graphql \
    --header 'Authorization: Bearer ${{ secrets.MY_SECRET }}' \
    --data '{"query":"mutation {addProjectV2ItemById(input: {projectId: \"PVT_kwHOBYJ8084AYkeK\" contentId: \"'"$issue_id"'\"}) {item {id}}}"}')

echo "$response"
