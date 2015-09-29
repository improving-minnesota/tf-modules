docker run \
  -d \
  -p 80:80 \
  -e DRONE_GITHUB_CLIENT=${github_client} \
  -e DRONE_GITHUB_SECRET=${github_secret} \
  -e DRONE_GITHUB_OPEN=true \
  -e DRONE_GITHUB_ORGS=${github_orgs} \
  -e DRONE_WORKER_NODES=${workers} \
  -e DOCKER_HOST=unix:///var/run/docker.sock \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/drone:/var/lib/drone \
  drone/drone:latest
