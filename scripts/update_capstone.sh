#!/bin/sh
#
# Update the bundled capstone library

# Modify value to update capstone
CAPSTONE_REVISION="75c05281b4bc8e8c41a1ab7f91705401caa3832a"

set -eux


cd "$(dirname "$0")"/../

CAPSTONE_DIR=capstone
TEMP_DIR="$(mktemp -d /tmp/capstone-sys.XXXXXXXXXX)"
ARCHIVE="$TEMP_DIR/archive.zip"

URL="https://github.com/aquynh/capstone/archive/$CAPSTONE_REVISION.zip"
wget "$URL" -O "$ARCHIVE"

CS_TEMP_DIR="$TEMP_DIR/capstone"

unzip "$ARCHIVE" -d "$CS_TEMP_DIR"

CREATED_CS_DIR="$(find "$CS_TEMP_DIR" -mindepth 1 -maxdepth 1 -type d)"
num_lines=$(echo "$CREATED_CS_DIR" | wc -l)
if [ $num_lines -ne 1 ]; then
    echo "Expected only 1 subdirectory, found $num_lines" 1>&2
    exit 1
fi

rm -rf "$CAPSTONE_DIR"
cp -r "$CREATED_CS_DIR" "$CAPSTONE_DIR"

# cleanup temp dir
rm -rf "$TEMP_DIR"
