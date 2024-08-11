build-sysext name version="latest" arch="x86-64": squashfs_tools
    #!/usr/bin/env bash
    set -euxo pipefail
    EXT_NAME="{{ name }}-{{ version }}-{{ arch }}"
    PATH="{{ name }}/"sysext"/$EXT_NAME"
    /usr/bin/mksquashfs $PATH $EXT_NAME.raw

squashfs_tools:
    sudo apt install squashfs-tools
