#!/bin/bash

AIVIS_VOICEOVER_PATH=$(echo ${CLAUDE_PLUGIN_ROOT}/hooks/scripts/aivis-voiceover.sh)
CONTEXT=$(cat ${CLAUDE_PLUGIN_ROOT}/context/context.md)
FIXED_CONTEXT="${CONTEXT//AIVIS_VOICEOVER_PATH/$AIVIS_VOICEOVER_PATH}"

jq -n --arg context "$FIXED_CONTEXT" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: $context
  }
}'
