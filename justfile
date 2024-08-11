build-sysext name version="latest" arch="x86-64": squashfs_tools
    #!/usr/bin/env bash
    set -euxo pipefail
    IMG="{{ name }}-{{ version }}-{{ arch }}"
    PATH="{{ name }}/"sysext"/$IMG"
    /usr/bin/mksquashfs $PATH $IMG.raw

squashfs_tools:
    sudo apt install squashfs-tools
