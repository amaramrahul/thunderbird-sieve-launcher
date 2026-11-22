#!/bin/sh
# Packages the add-on in addon/ into sieve-launcher.xpi.
set -e
cd "$(dirname "$0")/addon"
rm -f ../sieve-launcher.xpi
zip -q -r ../sieve-launcher.xpi .
echo "Built sieve-launcher.xpi"
