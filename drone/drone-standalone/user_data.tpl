#cloud-config
mounts:
  - [ xvdh, /var/lib/drone ]
runcmd:
  - [ cloud-init-per, once, curl, -sSL, https://get.docker.com/, |, sh]
  - "${drone_command}"
${additional_user_data}
