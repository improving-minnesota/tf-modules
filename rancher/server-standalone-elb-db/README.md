# Rancher Server w/ ELB and external database

This module provide a Rancher server EC2 that is exposed via an ELB and stores its data in the provided database connection

## Database

Ensure the database schema is set up correctly before launching:

Modify the values below with the desired `database`, `username`, and `password`

```
CREATE DATABASE IF NOT EXISTS <database> COLLATE = 'utf8_general_ci' CHARACTER SET = 'utf8';
GRANT ALL ON <database>.* TO '<username>'@'%' IDENTIFIED BY '<password>';
GRANT ALL ON <database>.* TO '<username>'@'localhost' IDENTIFIED BY '<password>';
```
