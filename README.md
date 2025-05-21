# FreeCAD-dev (Local Source, Full Dev Environment)

This project provides a complete FreeCAD development setup using:

- Docker (Ubuntu 22.04 base)
- Local source clone of FreeCAD
- OpenCASCADE 7.6.3 built from source
- Full VSCode integration with build + debug support

---

## ✅ Prerequisites

- VSCode with the **Dev Containers** extension
- Your FreeCAD fork cloned into: `FreeCAD-dev/FreeCAD`
- Docker installed

---

## 🛠 Folder Structure

```
FreeCAD-dev/
├── Dockerfile
├── .devcontainer/
│   └── devcontainer.json
├── .vscode/
│   ├── launch.json
│   └── tasks.json
├── build.sh
├── rebuild.sh
├── clean.sh
└── FreeCAD/      # ← Your forked source
```

---

## 🚀 Getting Started

### 1. Build the container image

```bash
docker build --no-cache -t freecad-dev .
```

### 2. Reopen the folder in VSCode

```plaintext
Ctrl+Shift+P → Dev Containers: Reopen in Container
```

### 3. Configure and build FreeCAD

```bash
./build.sh         # or ./rebuild.sh
cd FreeCAD/build
ninja              # build
```

---

## 🐞 Debugging in VSCode

- Open a `.cpp` file (like `MainWindow.cpp`)
- Set a breakpoint
- Press `F5` to launch the FreeCAD GUI with GDB attached

---

## 📌 Notes

- OCCT 7.6.3 is built inside the container and installed to `/opt/occt-install`
- CMake is explicitly pointed to that install to avoid header/linker issues
- All development and Git operations happen on your **local FreeCAD fork**

---

## 🧼 Cleanup

```bash
./clean.sh
```

Removes the build directory. Use `./rebuild.sh` to wipe + rebuild clean.

---

## 🔒 Git Hygiene

This setup **does not touch your FreeCAD fork** with config files.

All tooling lives in `FreeCAD-dev/`, outside the source tree.

---