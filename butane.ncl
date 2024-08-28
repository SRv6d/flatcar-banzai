{
  variant = "flatcar",
  version = "1.0.0",
  storage = {
    filesystems = [
      {
        device = "/dev/sdb",
        format = "ext4",
        label = "data1"
      }
    ],
    directories = [
      {
        path = "/mnt/data/bitcoin",
        mode = 493,
        user = {
          name = "bitcoind"
        },
        group = {
          "name" = "bitcoind"
        }
      },
      {
        path = "/mnt/data/electrs",
        mode = 493,
        user = {
          name = "electrs"
        },
        group = {
          name = "electrs"
        }
      },
      {
        path = "/mnt/data/esplora",
        mode = 493,
        user = {
          name = "esplora"
        },
        group = {
          name = "esplora"
        }
      }
    ],
    files = [
      {
        path = "/etc/bitcoin/bitcoin.conf",
        contents = {
          local = "bitcoin/bitcoin.conf"
        }
      },
      {
        path = "/etc/electrs/config.toml",
        contents = {
          local = "electrs/config.toml"
        }
      },
      {
        path = "/etc/extensions/bitcoin-27.1-x86-64.raw",
        mode = 420,
        contents = {
          source = "https://github.com/SRv6d/flatcar-banzai/releases/download/10341053369/bitcoin-27.1-x86-64.raw",
          verification = {
            hash = "sha256-f9f63fe90827c47ce25299e323568f4ab0766932a7211024efbefffee1a478cc"
          }
        }
      },
      {
        path = "/etc/netdata/netdata.conf",
        contents = {
          local = "netdata/netdata.conf"
        }
      }
    ]
  },
  passwd = {
    users = [
      {
        name = "core",
        shell = "/sbin/nologin"
      },
      {
        name = "marvin.vogt",
        ssh_authorized_keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOELWzSrWOfYX4B7v0kYnIyQT3M3wVV1c6X+LpoJFDcI"
        ],
        groups = [
          "sudo",
          "docker"
        ]
      },
      {
        name = "bitcoind",
        system = true,
        no_create_home = true
      },
      {
        name = "electrs",
        system = true,
        no_create_home = true
      },
      {
        name = "esplora",
        system = true,
        no_create_home = true
      }
    ]
  },
  systemd = {
    units = [
      {
        name = "mnt-data.mount",
        enabled = true,
        contents = "[Unit]\nDescription=Data mount\n\n[Mount]\nWhat=/dev/disk/by-label/data1\nWhere=/mnt/data\nType=ext4\n\n[Install]\nWantedBy=multi-user.target\n"
      },
      {
        name = "docker.service",
        enabled = true
      },
      {
        name = "electrs.service",
        enabled = false,
        contents = "[Unit]\nDescription=Electrs electrum server\nRequires=bitcoind.service\nRequires=mnt-data.mount\n\n[Service]\nTimeoutStartSec=0\nExecStartPre=-/usr/bin/docker rm --force electrs\nExecStart=/usr/bin/docker run \\\n    --name electrs \\\n    --pull always \\\n    -v /etc/electrs:/etc/electrs:ro \\\n    -v /mnt/data/electrs:/mnt/data/electrs:rw \\\n    --net=host \\\n    srv6d/electrs:0.10.5\nExecStop=/usr/bin/docker stop electrs\nRestart=always\nRestartSec=5s\n\n[Install]\nWantedBy=multi-user.target\n"
      },
      {
        name = "esplora.service",
        enabled = true,
        contents = "[Unit]\nDescription=Esplora mainnet electrum server\nRequires=bitcoind.service\nRequires=mnt-data.mount\n\n[Service]\nTimeoutStartSec=0\nExecStartPre=-/usr/bin/docker rm --force esplora\nExecStart=/usr/bin/docker run \\\n    --name esplora \\\n    --pull always \\\n    -v /etc/esplora:/etc/esplora:ro \\\n    -v /mnt/data/esplora:/mnt/data/esplora:rw \\\n    --net=host \\\n    blockstream/esplora\nExecStop=/usr/bin/docker stop esplora\nRestart=always\nRestartSec=5s\n\n[Install]\nWantedBy=multi-user.target\n"
      },
      {
        name = "netdata.service",
        enabled = true,
        contents = "[Unit]\nDescription=Netdata\nRequires=mnt-data.mount\n\n[Service]\nTimeoutStartSec=0\nExecStartPre=-/usr/bin/docker rm --force netdata\nExecStart=/usr/bin/docker run \\\n    --name=netdata \\\n    --pull always \\\n    --pid=host \\\n    --network=host \\\n    -v /etc/netdata:/etc/netdata \\\n    -v netdatalib:/var/lib/netdata \\\n    -v netdatacache:/var/cache/netdata \\\n    -v /run/netdata:/run/netdata \\\n    -v /:/host/root:ro,rslave \\\n    -v /etc/passwd:/host/etc/passwd:ro \\\n    -v /etc/group:/host/etc/group:ro \\\n    -v /proc:/host/proc:ro \\\n    -v /sys:/host/sys:ro \\\n    -v /etc/os-release:/host/etc/os-release:ro \\\n    -v /var/log:/host/var/log:ro \\\n    -v /var/run/docker.sock:/var/run/docker.sock:ro \\\n    -v /run/dbus:/run/dbus:ro \\\n    --cap-add SYS_PTRACE \\\n    --cap-add SYS_ADMIN \\\n    --security-opt apparmor=unconfined \\\n    netdata/netdata\nExecStop=/usr/bin/docker stop netdata\nRestart=always\nRestartSec=5s\nRuntimeDirectory=netdata\n\n[Install]\nWantedBy=multi-user.target\n"
      }
    ]
  }
}
