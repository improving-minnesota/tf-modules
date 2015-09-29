#cloud-config
mounts:
  - [ xvdh, /var/lib/drone ]
runcmd:
  - [ curl, -sSL, "https://get.docker.com/", -o, /tmp/docker.sh ]
  - [ chmod, "u+x", /tmp/docker.sh]
  - [ cloud-init-per, once, sh, /tmp/docker.sh ]
  - "${drone_command}"
${additional_user_data}
