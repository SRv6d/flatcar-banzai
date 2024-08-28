{
  name = "esplora.service",
  enabled = true,
  contents = m%"
    [Unit]
    Description=Esplora mainnet electrum server
    Requires=bitcoind.service
    Requires=mnt-data.mount

    [Service]
    TimeoutStartSec=0
    ExecStartPre=-/usr/bin/docker rm --force esplora
    ExecStart=/usr/bin/docker run \
        --name esplora \
        --pull always \
        -v /etc/esplora:/etc/esplora:ro \
        -v /mnt/data/esplora:/mnt/data/esplora:rw \
        --net=host \
        blockstream/esplora
    ExecStop=/usr/bin/docker stop esplora
    Restart=always
    RestartSec=5s

    [Install]
    WantedBy=multi-user.target
    "%
}
