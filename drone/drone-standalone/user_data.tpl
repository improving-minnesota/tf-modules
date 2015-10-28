#cloud-config
mounts:
  - [ xvdh, /var/lib/drone ]
runcmd:
  - [ curl, -sSL, "https://get.docker.com/", -o, /tmp/docker.sh ]
  - [ chmod, "u+x", /tmp/docker.sh]
  - [ cloud-init-per, once, sh, /tmp/docker.sh ]
  - "${drone_command}"
write_files:
  - path: /etc/default/drone
    permissions: '0600'
    content: |
      GITHUB_CLIENT="${github_client}"
      GITHUB_SECRET="${github_secret}"
      GITHUB_ORGS="${github_orgs}"
      WORKERS="${workers}"
      IMAGE="${image}"
  - path: /etc/drone/run
    permissions: '0700'
    content: |
      #!/bin/bash
      . /etc/default/drone
      docker run \
        -d \
        -p 80:80 \
        -e DRONE_GITHUB_CLIENT="$${GITHUB_CLIENT}" \
        -e DRONE_GITHUB_SECRET="$${GITHUB_SECRET}" \
        -e DRONE_GITHUB_OPEN=true \
        -e DRONE_GITHUB_ORGS="$${GITHUB_ORGS}" \
        -e DRONE_WORKER_NODES="$${WORKERS}" \
        -e DOCKER_HOST=unix:///var/run/docker.sock \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /var/lib/drone:/var/lib/drone \
        "$${IMAGE}"
${additional_user_data}
