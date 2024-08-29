{
  name = "electrs.service",
  enabled = true,
  contents = m%"
    [Unit]
    Description=Electrs electrum server
    Requires=bitcoind.service
    Requires=mnt-data.mount

    [Service]
    TimeoutStartSec=0
    ExecStartPre=-/usr/bin/docker rm --force electrs
    ExecStart=/usr/bin/docker run \
        --name electrs \
        --pull always \
        -v /etc/electrs:/etc/electrs:ro \
        -v /mnt/data/electrs:/mnt/data/electrs:rw \
        --net=host \
        srv6d/electrs:0.10.5
    ExecStop=/usr/bin/docker stop electrs
    Restart=always
    RestartSec=5s

    [Install]
    WantedBy=multi-user.target
    "%
}
