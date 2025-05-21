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
  libfontconfig1-dev libxerces-c-dev libvtk9-dev libmedc-dev \
  libyaml-cpp-dev \
  libocct-data-exchange-dev \
  libocct-foundation-dev \
  libocct-modeling-algorithms-dev \
  libocct-modeling-data-dev \
  libocct-visualization-dev \
  gdb

# Symlink python → python3.10
RUN ln -sf /usr/bin/python3.10 /usr/bin/python

# Install correct Qt-bound PySide2
RUN apt update && apt install -y \
  python3-pyside2.qtcore \
  python3-pyside2.qtgui \
  python3-pyside2.qtsvg \
  python3-pyside2.qtwidgets \
  python3-pyside2.qtnetwork

# Create working directory
WORKDIR /opt

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

# Build and install OpenCASCADE 7.6.3
RUN git clone https://github.com/Open-Cascade-SAS/OCCT.git /opt/occt && \
    cd /opt/occt && \
    git checkout V7_6_3 && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/opt/occt-install \
      -DBUILD_MODULE_Draw=OFF \
      -DBUILD_LIBRARY_TYPE=Shared \
      -DBUILD_CMAKE_TARGETS=ON && \
    cmake --build . --parallel && \
    cmake --install .


# Setup Library Paths...
ENV LD_LIBRARY_PATH="/opt/occt-install/lib:/usr/local/lib:/lib:/usr/lib"

# Runtime setup
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
WORKDIR /opt/FreeCAD/build
CMD ["/bin/bash"]


