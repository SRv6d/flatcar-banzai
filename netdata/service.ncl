{
  name = "netdata.service",
  enabled = true,
  contents = m%"
    [Unit]
    Description=Netdata
    Requires=mnt-data.mount
  
    [Service]
    TimeoutStartSec=0
    ExecStartPre=-/usr/bin/docker rm --force netdata
    ExecStart=/usr/bin/docker run \
        --name=netdata \
        --pull always \
        --pid=host \
        --network=host \
        -v /etc/netdata:/etc/netdata \
        -v netdatalib:/var/lib/netdata \
        -v netdatacache:/var/cache/netdata \
        -v /run/netdata:/run/netdata \
        -v /:/host/root:ro,rslave \
        -v /etc/passwd:/host/etc/passwd:ro \
        -v /etc/group:/host/etc/group:ro \
        -v /proc:/host/proc:ro \
        -v /sys:/host/sys:ro \
        -v /etc/os-release:/host/etc/os-release:ro \
        -v /var/log:/host/var/log:ro \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v /run/dbus:/run/dbus:ro \
        --cap-add SYS_PTRACE \
        --cap-add SYS_ADMIN \
        --security-opt apparmor=unconfined \
        netdata/netdata
    ExecStop=/usr/bin/docker stop netdata
    Restart=always
    RestartSec=5s
    RuntimeDirectory=netdata
  
    [Install]
    WantedBy=multi-user.target
    "%,
}
