#### Run JIRA with docker

1. Build service image from Dockerfile:

```sh
    docker run --name mysql_db -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -p 127.0.0.1:3306:3306 -d mysql:5.5.54
```

2. Create database for JIRA:

```sh
    docker exec -it mysql_db mysql
```

        CREATE DATABASE jira_database;

        ALTER DATABASE jira_database CHARACTER SET utf8 COLLATE utf8_bin;

3. Make directory for JIRA_HOME:

```sh
    mkdir jira
```

```sh
    sudo chown -R daemon jira
```

4. Build image from Dockerfile:

```sh
    docker build -t jira_img .
```

5. Run JIRA:

```sh
    docker run --name jira_app -p 8080:8080 -v /home/$USER/jira:/var/atlassian/jira --link mysql_db:database -d jira_img
```
