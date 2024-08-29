BUTANE_VERSION := "v0.21.0"
BUTANE_BIN := "butane-" + arch() + "-" + if os() == "macos" { "apple-darwin" } else { "unknown-linux-gnu" }
BUTANE_CFG := "butane.yaml"
NICKEL_VERSION := "1.7.0"
NICKEL_BIN := "nickel-" + (if arch() == "aarch64" { "arm64" } else { arch() }) + "-" + if os() == "macos" { "apple-darwin" } else { "linux" }
BIN_DIR := justfile_directory() / ".just" / "bin"

build-sysext name version="latest" arch="x86-64": squashfs_tools
    #!/usr/bin/env bash
    set -euxo pipefail
    EXT_NAME="{{ name }}-{{ version }}-{{ arch }}"
    PATH="{{ name }}/"sysext"/$EXT_NAME"
    /usr/bin/mksquashfs $PATH $EXT_NAME.raw

validate: validate-justfile validate-nickel validate-dockerfiles validate-butane validate-terraform

validate-justfile:
    just --check --fmt --unstable

validate-nickel file="butane.ncl": (_get_gh_bin "tweag" "nickel" NICKEL_VERSION NICKEL_BIN)
    {{ BIN_DIR }}/{{ NICKEL_BIN }} typecheck {{ file }}
    {{ BIN_DIR }}/{{ NICKEL_BIN }} eval {{ file }} > /dev/null

validate-dockerfiles:
    hadolint **/Dockerfile

validate-butane: _get_butane_bin
    {{ BIN_DIR }}/{{ BUTANE_BIN }} --files-dir . --strict --check {{ BUTANE_CFG }}

validate-terraform:
    terraform fmt -check

transpile-butane output="ignition.json": _get_butane_bin
    {{ BIN_DIR }}/{{ BUTANE_BIN }} --files-dir . --strict {{ BUTANE_CFG }} > {{ output }}

squashfs_tools:
    sudo apt install squashfs-tools

_get_butane_bin: (_get_gh_bin "coreos" "butane" BUTANE_VERSION BUTANE_BIN)

_get_gh_bin org repo version bin: _bin_dir
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ ! -x {{ BIN_DIR }}/{{ bin }} ]; then
        wget https://github.com/{{ org }}/{{ repo }}/releases/download/{{ version }}/{{ bin }} -O {{ BIN_DIR }}/{{ bin }}
        chmod +x {{ BIN_DIR }}/{{ bin }}
    fi

_bin_dir:
    #!/usr/bin/env bash
    if [ ! -d {{ BIN_DIR }} ]; then
        mkdir -p {{ BIN_DIR }}
    fi
