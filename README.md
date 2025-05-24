# FreeCAD-dev (Native Host Build, Full Dev Environment)

This project provides a complete FreeCAD development setup using:

- Native Linux build (Linux Mint 21.3 / Ubuntu 22.04 base)
- Python 3.12 with system-wide Shiboken2 & PySide2
- Local source clone of FreeCAD
- Full VSCode integration with build + debug support

---

## ✅ Prerequisites

- VSCode with the C++ and CMake extensions
- Your FreeCAD fork cloned into: `FreeCAD-dev/FreeCAD`
- Python 3.12 installed via APT (not virtualenv)
- CMake ≥ 3.22 recommended

---

## 🛠 Folder Structure

```
FreeCAD-dev/
├── .vscode/
│   ├── launch.json       # F5 launches debug build
│   └── tasks.json        # Manual build/run tasks
├── run.sh                # (optional) launch helper
└── FreeCAD/              # ← Your forked source
```

---

## 🚀 Getting Started (Host Native)

```bash
sudo apt install build-essential cmake ninja-build git \
  qttools5-dev qttools5-dev-tools libqt5svg5-dev \
  libboost-all-dev libeigen3-dev libgl1-mesa-dev \
  libglu1-mesa-dev libfreetype-dev libjsoncpp-dev \
  libhdf5-dev libxerces-c-dev libvtk9-dev libmedc-dev \
  libyaml-cpp-dev libocct-*-dev libshiboken2-dev libpyside2-dev \
  python3.12-dev
```

### 1. Configure

```bash
cmake -S FreeCAD -B FreeCAD/build/debug \
  -DCMAKE_BUILD_TYPE=Debug \
  -DPYTHON_EXECUTABLE=/usr/bin/python3.12 \
  -DFC_VERSION_SUFFIX="+longracks"
```

### 2. Build

```bash
cmake --build FreeCAD/build/debug --parallel 8
```

### 3. Run

```bash
LD_LIBRARY_PATH=FreeCAD/build/debug/lib ./FreeCAD/build/debug/bin/FreeCAD
```

---

## 🐞 Debugging in VSCode

- F5 launches your build with GDB and environment setup
- `Build FreeCAD (host)` and `Run FreeCAD (host)` tasks available
- Breakpoints, watch, memory views fully supported

---

## 📌 Notes

- Docker-based development was deprecated due to OpenGL/Qt GUI failures (`xcb` context issues)
- Native build offers full integration, OpenGL support, and faster dev cycles
- Your FreeCAD fork remains untouched — all tooling lives in `FreeCAD-dev/`

---

## 🔄 Syncing with Upstream

```bash
cd FreeCAD
git fetch upstream
git merge upstream/main
git push origin main
```

---

## 🧼 Cleanup

```bash
rm -rf FreeCAD/build/debug
```

Or use `./clean.sh` if you've kept script-based tooling.

---

## 🛠️ Maintainer Notes

- Current build uses Python 3.12 — be sure Shiboken2/PySide2 are ABI-matched
- Custom version suffix (`+longracks`) appears in splash/About dialog
