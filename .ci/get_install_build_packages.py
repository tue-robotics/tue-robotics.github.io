#! /usr/bin/env python3

import os
import sys
import catkin_pkg.package


if len(sys.argv) >= 2:
    skip_pkgs = set(sys.argv[1:])
else:
    skip_pkgs = set()

# TODO(anyone): remove try...except when tue-env is updated to new variable names
try:
    ws_dir = os.environ["TUE_ENV_WS_DIR"]
except KeyError:
    ws_dir = os.environ["TUE_WS_DIR"]

packages = (f.path for f in os.scandir(os.path.join(ws_dir, "src")) if f.is_dir())

install_build_pkgs = set()  # All packages that need to be build and require all deps to be installed
build_pkgs = set()  # All packages that need to be build

for pkg_path in packages:
    pkg = os.path.split(pkg_path)[-1]

    # Messages need to build and require there depencies
    for msg_type in ["action", "msg", "srv"]:
        if os.path.isdir(os.path.join(pkg_path, msg_type)):
            install_build_pkgs.add(pkg)
            break

    # Pkg with python modules need to build to be added to PYTHONPATH
    if os.path.isfile(os.path.join(pkg_path, "setup.py")):
        catkin_package = catkin_pkg.package.parse_package(
            os.path.join(pkg_path, catkin_pkg.package.PACKAGE_MANIFEST_FILENAME)
        )
        # If cpp code in pkg, deps need to be installed
        for dep in catkin_package.build_depends:
            if "cpp" in dep.name:  # Might be replaced by a better check to determine their is cpp code in this pkg
                install_build_pkgs.add(pkg)
                break
        else:
            build_pkgs.add(pkg)
print(
    f"INSTALL_BUILD_PKGS=({' '.join(install_build_pkgs.difference(skip_pkgs))}); BUILD_PKGS=({' '.join(build_pkgs.difference(skip_pkgs))})"
)
