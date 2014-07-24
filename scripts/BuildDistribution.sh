#!/bin/bash

echo ""

CCB_VERSION=$1

# Change to the script's working directory no matter from where the script was called (except if there are symlinks used)
# Solution from: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo Script working directory: $SCRIPT_DIR
cd "$SCRIPT_DIR"

# Remove build directory
cd ..
CCB_DIR=$(pwd)

rm -Rf build/
rm -Rf SpriteBuilder/build/

./scripts/CreateAllGeneratedFiles.sh $1

# Clean and build CocosBuilder
echo "=== CLEANING PROJECT ==="

cd SpriteBuilder/
xcodebuild -alltargets clean | egrep -A 5 "(error):|(SUCCEEDED \*\*)|(FAILED \*\*)"

echo "=== BUILDING SPRITEBUILDER === (please be patient)"
xcodebuild -target SpriteBuilderX -configuration Release build | egrep -A 5 "(error):|(SUCCEEDED \*\*)|(FAILED \*\*)"

# Create archives
echo "=== ZIPPING UP FILES ==="
cd ..
mkdir build
cp -R SpriteBuilder/build/Release/SpriteBuilderX.app build/SpriteBuilderX.app
cp -R SpriteBuilder/build/Release/SpriteBuilderX.app.dSYM build/SpriteBuilderX.app.dSYM

cd build/
zip -q -r "SpriteBuilderX.app.dSYM.zip" SpriteBuilderX.app.dSYM

echo ""
echo "SpriteBuilder Distribution Build complete!"
echo "You can now open SpriteBuilder/SpriteBuilder.xcodeproj"
