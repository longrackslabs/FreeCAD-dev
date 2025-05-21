#!/bin/bash
set -e

./clean.sh
./build.sh
cd FreeCAD/build
ninja

