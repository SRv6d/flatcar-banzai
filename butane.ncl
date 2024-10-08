{
  variant = "flatcar",
  version = "1.1.0",
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
      }
    ]
  },
  systemd = {
    units = [
      {
        name = "mnt-data.mount",
        enabled = true,
        contents = m%"
          [Unit]
          Description=Data mount

          [Mount]
          What=/dev/disk/by-label/data1
          Where=/mnt/data
          Type=ext4

          [Install]
          WantedBy=multi-user.target
        "%
      },
      {
        name = "docker.service",
        enabled = true
      },
      import "electrs/service.ncl",
      import "netdata/service.ncl"
    ]
  }
}
