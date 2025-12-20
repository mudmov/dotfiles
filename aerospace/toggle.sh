#!/bin/bash

TARGET_WORKSPACE=$1
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

if [ "$CURRENT_WORKSPACE" = "$TARGET_WORKSPACE" ]; then
    aerospace workspace-back-and-forth
else
    aerospace workspace "$TARGET_WORKSPACE"
fi


