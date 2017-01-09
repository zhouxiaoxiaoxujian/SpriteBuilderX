#!/bin/bash
SCRIPT_PATH=`dirname "$0"`; SCRIPT_PATH=`eval "cd \"$SCRIPT_PATH\" && pwd"`
cd $SCRIPT_PATH

# Use the latest tag for short version (expected tag format "vn[.n[.n]]")
# or if there are no tags, we make up version 0.0
LATEST_TAG=$(git describe --tags --match 'v*' --abbrev=0 2>/dev/null) || LATEST_TAG="HEAD"
if [ $LATEST_TAG = "HEAD" ]; then
    LATEST_TAG="0.0"
else
    LATEST_TAG=${LATEST_TAG##v} # Remove the "v" from the front of the tag
fi
 
SHORT_VERSION="$LATEST_TAG"

echo $SHORT_VERSION