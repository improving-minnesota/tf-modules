#cloud-config
mounts:
  - [ xvdh, /opt/sonarqube ]
runcmd:
  - [ curl, -sSL, "https://get.docker.com/", -o, /tmp/docker.sh ]
  - [ chmod, "u+x", /tmp/docker.sh]
  - [ cloud-init-per, once, sh, /tmp/docker.sh ]
  - "${sonar_command}"
write_files:
  - path: /etc/default/sonarqube
    permissions: '0600'
    content: |
      IMAGE="${image}"
      DB_USERNAME="${db_username}"
      DB_PASSWORD="${db_password}"
      DB_URL="${db_url}"
  - path: /etc/sonarqube/run
    permissions: '0700'
    content: |
      #!/bin/bash
      . /etc/default/sonarqube
      docker run \
        -d \
        -p 9000:9000 \
        -e SONARQUBE_JDBC_USERNAME="$${DB_USERNAME}" \
        -e SONARQUBE_JDBC_PASSWORD="$${DB_PASSWORD}" \
        -e SONARQUBE_JDBC_URL="$${DB_URL}" \
        -v /opt/sonarqube:/opt/sonarqube \
        "$${IMAGE}"
${additional_user_data}
