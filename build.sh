#/bin/sh

echo "Building xwalk app.."

PROJECT_DIR=/src

cd $PROJECT_DIR

# Install project dependencies
npm install

# Clean up prev build
rm -rf public
rm -f *.apk

# Build web app
./node_modules/webpack/bin/webpack.js

# Build xwalk app
python /crosswalk-$XWALK_VERSION/make_apk.py \
	--arch=arm \
	--package=com.lynxinnovation.usb.tester \
	--manifest="$PROJECT_DIR/public/manifest.json" \
	--app-version=1.0 \
	--icon="$PROJECT_DIR/icon.png" \
	--target-dir=$PROJECT_DIR


