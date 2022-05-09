#!/usr/bin/env zsh

curl -H "PRIVATE-TOKEN: $GL_PAT" "https://gitlab.com/api/v4$1"
