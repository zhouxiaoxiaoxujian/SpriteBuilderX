#!/bin/bash
SCRIPT_PATH=`dirname "$0"`; SCRIPT_PATH=`eval "cd \"$SCRIPT_PATH\" && pwd"`
cd $SCRIPT_PATH

BUILD_NUMBER=$(git rev-list --no-merges --invert-grep --grep="@skip_version" --all-match --count HEAD)

echo $BUILD_NUMBER