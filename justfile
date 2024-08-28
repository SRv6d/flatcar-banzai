BUTANE_VERSION := "v0.21.0"
BUTANE_BIN := "butane-" + arch() + "-" + if os() == "macos" { "apple-darwin" } else { "unknown-linux-gnu" }
BUTANE_CFG := "butane.yaml"

NICKEL_VERSION := "1.7.0"
NICKEL_BIN := "nickel-" + (if arch() == "aarch64" { "arm64" } else { arch() }) + "-" + if os() == "macos" { "apple-darwin" } else { "linux" }

build-sysext name version="latest" arch="x86-64": squashfs_tools
    #!/usr/bin/env bash
    set -euxo pipefail
    EXT_NAME="{{ name }}-{{ version }}-{{ arch }}"
    PATH="{{ name }}/"sysext"/$EXT_NAME"
    /usr/bin/mksquashfs $PATH $EXT_NAME.raw

validate-nickel file: _get_nickel_bin
    ./{{ NICKEL_BIN }} typecheck {{ file }}
    ./{{ NICKEL_BIN }} eval {{ file }} > /dev/null

validate-butane output="ignition.json": _get_butane_bin && _cleanup_butane_bin
    ./{{ BUTANE_BIN }} --files-dir . --strict --check {{ BUTANE_CFG }}

transpile-butane output="ignition.json": _get_butane_bin && _cleanup_butane_bin
    ./{{ BUTANE_BIN }} --files-dir . --strict {{ BUTANE_CFG }} > {{ output }}

squashfs_tools:
    sudo apt install squashfs-tools

_get_butane_bin:
    wget https://github.com/coreos/butane/releases/download/{{ BUTANE_VERSION }}/{{ BUTANE_BIN }}
    chmod +x {{ BUTANE_BIN }}

_get_nickel_bin:
    wget https://github.com/tweag/nickel/releases/download/{{ NICKEL_VERSION }}/{{ NICKEL_BIN }}
    chmod +x {{ NICKEL_BIN }}

_cleanup_butane_bin:
    rm {{ BUTANE_BIN }}
