#! /usr/bin/env python3

import os
import sys
import catkin_pkg.package


if len(sys.argv) >= 2:
    skip_pkgs = set(sys.argv[1:])
else:
    skip_pkgs = set()

system_dir = os.getenv("TUE_SYSTEM_DIR")
packages = (f.path for f in os.scandir(os.path.join(system_dir, "src")) if f.is_dir())

install_build_pkgs = set()
build_pkgs = set()

for pkg_path in packages:
    pkg = os.path.split(pkg_path)[-1]
    for msg_type in ["action", "msg", "srv"]:
        if os.path.isdir(os.path.join(pkg_path, msg_type)):
            install_build_pkgs.add(pkg)
            break

    if os.path.isfile(os.path.join(pkg_path, "setup.py")):
        catkin_package = catkin_pkg.package.parse_package(
            os.path.join(pkg_path, catkin_pkg.package.PACKAGE_MANIFEST_FILENAME)
        )
        for dep in catkin_package.build_depends:
            if "cpp" in dep.name:  # Might be replaced by a better check to determine their is cpp code in this pkg
                install_build_pkgs.add(pkg)
                break
        else:
            build_pkgs.add(pkg)

print(
    "INSTALL_BUILD_PKGS=({}); BUILD_PKGS=({})".format(
        " ".join(install_build_pkgs.difference(skip_pkgs)), " ".join(build_pkgs.difference(skip_pkgs))
    )
)
