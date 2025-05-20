FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt update && apt install -y \
  build-essential cmake ninja-build git wget curl \
  python3.10 python3.10-dev python3-pip swig \
  qtbase5-dev qttools5-dev qttools5-dev-tools \
  libqt5svg5-dev \
  libboost-all-dev libeigen3-dev libgl1-mesa-dev libx11-dev libxi-dev \
  libxext-dev libxt-dev libxmu-dev libglu1-mesa-dev \
  libfreetype-dev libjpeg-dev libpng-dev libtbb-dev \
  libjsoncpp-dev libhdf5-dev pkg-config \
  libfontconfig1-dev libxerces-c-dev libvtk9-dev libmedc-dev

# Symlink python → python3.10
RUN ln -sf /usr/bin/python3.10 /usr/bin/python

# ✅ Install correct Qt-bound PySide2
RUN apt update && apt install -y \
  python3-pyside2.qtcore \
  python3-pyside2.qtgui \
  python3-pyside2.qtsvg \
  python3-pyside2.qtwidgets \
  python3-pyside2.qtnetwork

# Create working directory
WORKDIR /opt

# Build and install yaml-cpp
RUN git clone https://github.com/jbeder/yaml-cpp.git && \
    cd yaml-cpp && mkdir build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j$(nproc) && make install

# Build and install pybind11
RUN git clone https://github.com/pybind/pybind11.git && \
    cd pybind11 && mkdir build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j$(nproc) && make install

# Build and install Coin3D
RUN git clone https://github.com/coin3d/coin.git /opt/coin && \
    cmake -S /opt/coin -B /opt/coin/build -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build /opt/coin/build --parallel && \
    cmake --install /opt/coin/build


# Build and install Pivy
RUN git clone https://github.com/FreeCAD/pivy.git && \
    cd pivy && \
    python3.10 -m pip install . --user

# Build and install OpenCASCADE
RUN git clone https://github.com/Open-Cascade-SAS/OCCT.git /opt/occt && \
    cmake -S /opt/occt -B /opt/occt/build \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DBUILD_MODULE_Draw=OFF \
      -DBUILD_LIBRARY_TYPE=Shared && \
    cmake --build /opt/occt/build --parallel && \
    cmake --install /opt/occt/build

# Setup Library Paths...
ENV LD_LIBRARY_PATH="/usr/local/lib:/lib:/usr/lib"

# Clone and build FreeCAD
RUN git clone https://github.com/FreeCAD/FreeCAD.git && \
    cd FreeCAD && \
    git submodule update --init --recursive && \
    mkdir build && cd build && \
    cmake .. \
      -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DPYTHON_EXECUTABLE=/usr/bin/python3.10 \
      -DCMAKE_PREFIX_PATH="/usr/local" \
      -DFREECAD_USE_EXTERNAL_PIVY=ON \
      -DFREECAD_BUILD_FEM=OFF \
      -DFREECAD_BUILD_SMESH=OFF \
      -DFREECAD_BUILD_MESH_PART=OFF && \
    ninja

ENV XDG_RUNTIME_DIR=/tmp/runtime-root

WORKDIR /opt/FreeCAD/build
CMD ["/bin/bash"]

