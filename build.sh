#!/bin/bash
set -e

cd FreeCAD
mkdir -p build
cd build

cmake .. -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DPYTHON_EXECUTABLE=/usr/bin/python3.10 \
  -DFREECAD_USE_EXTERNAL_PIVY=ON \
  -DFREECAD_BUILD_FEM=OFF \
  -DFREECAD_BUILD_SMESH=OFF \
  -DFREECAD_BUILD_MESH_PART=OFF \
  -DOCC_INCLUDE_DIR=/opt/occt-install/include/opencascade \
  -DOCC_LIBRARY_DIR=/opt/occt-install/lib \
  -DOpenCASCADE_DIR=/opt/occt-install/lib/cmake/opencascade

