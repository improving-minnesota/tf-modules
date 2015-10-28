docker run \
  -d \
  -p 9000:9000 \
  -e SONARQUBE_JDBC_USERNAME="${db_username}" \
  -e SONARQUBE_JDBC_PASSWORD="${db_password}" \
  -e SONARQUBE_JDBC_URL="${db_url}" \
  -v /opt/sonarqube:/opt/sonarqube \
  "${image}"
