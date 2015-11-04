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
      GITHUB_ORG="${github_org}"
      WORKERS="${workers}"
      DATABASE_DRIVER="${db_driver}"
      DATABASE_CONFIG="${db_config}"
      IMAGE="${image}"
  - path: /etc/drone/run
    permissions: '0700'
    content: |
      #!/bin/bash
      . /etc/default/drone
      docker run \
        -d \
        -p 80:8000 \
        -e REMOTE_DRIVER=github \
        -e REMOTE_CONFIG=https://github.com?client_id=$${GITHUB_CLIENT}&client_secret=$${GITHUB_SECRET}?open=true&orgs=$${GITHUB_ORGS} \
        -e DATABASE_DRIVER=$${DATABASE_DRIVER} \
        -e DATABASE_CONFIG=$${DATABASE_CONFIG} \
        -e DRONE_WORKER_NODES="$${WORKERS}" \
        -e DOCKER_HOST=unix:///var/run/docker.sock \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /var/lib/drone:/var/lib/drone \
        "$${IMAGE}"
${additional_user_data}
