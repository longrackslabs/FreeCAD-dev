# FreeCAD-dev

A clean, source-built FreeCAD development environment using Docker.

- Builds FreeCAD `master` from source
- Includes OpenCASCADE (OCCT), Coin3D, Pivy, PySide2, and Qt
- Supports GUI (X11) and CLI (FreeCADCmd) use
- Faster and leaner than the official AppImage

## Getting Started

### Build the image

```bash
docker build --no-cache -t freecad-dev .
```

### Run FreeCAD (GUI on Linux/X11)

```bash
xhost +local:docker
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  freecad-dev ./bin/FreeCAD
```

### Run FreeCAD (CLI only)

```bash
docker run -it --rm freecad-dev ./bin/FreeCADCmd
```

## What's Included

- Ubuntu 22.04 base
- Python 3.10
- Qt 5.15 with PySide2 (installed via apt)
- Coin3D (from source)
- Pivy (built against system Coin3D)
- OpenCASCADE (OCCT from GitHub)
- yaml-cpp, pybind11, Boost, MED, VTK

## Notes

- GUI modules like AddonManager, Draft, BIM work out of the box
- No PySide2 crashes or Qt symbol issues
- Submodules (like OndselSolver) are initialized automatically
- X11 GUI works on Linux; WSL2/macOS requires additional config

## License

FreeCAD is licensed under the LGPL2+.

This container is an independent development environment and not officially affiliated with the FreeCAD project. See: https://www.freecad.org