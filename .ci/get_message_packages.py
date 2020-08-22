#! /usr/bin/env python3

import os
import sys


if len(sys.argv) >= 2:
    skip_pkgs = set(sys.argv[1:])
else:
    skip_pkgs = set()

system_dir = os.getenv("TUE_SYSTEM_DIR")
packages = [f.path for f in os.scandir(os.path.join(system_dir, "src")) if f.is_dir()]

msg_pkgs = set()

for pkg_path in packages:
    pkg = os.path.split(pkg_path)[-1]
    for msg_type in ["action", "msg", "srv"]:
        if os.path.isdir(os.path.join(pkg_path, msg_type)):
            msg_pkgs.add(pkg)
            break

print("\n".join(msg_pkgs.difference(skip_pkgs)))





