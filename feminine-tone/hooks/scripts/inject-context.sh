#!/bin/bash

CONTEXT=$(cat ${CLAUDE_PLUGIN_ROOT}/context/context.md)

jq -n --arg context "$CONTEXT" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $context
  }
}'
