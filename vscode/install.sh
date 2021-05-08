#!/bin/sh

SCRIPT_DIR=$(dirname $0)

cat "$SCRIPT_DIR/extensions" | while read line
do
  code --install-extension $line
done
