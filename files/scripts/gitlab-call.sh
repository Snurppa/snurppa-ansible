#!/usr/bin/env zsh

curl -H "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://${GITLAB_SERVER:-gitlab.com}/api/v4$1"
