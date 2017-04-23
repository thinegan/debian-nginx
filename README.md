# debian-nginx
Dockerized nginx service, built on top of official [Debian](https://hub.docker.com/_/debian/) images with supervisor.

# Image tags
* thinegan/debian-nginx (Debian GNU/Linux 8)

# Installed packages
* [8.7, 8, jessie, latest (jessie/Dockerfile)](https://github.com/tianon/docker-brew-debian/blob/e8131d071a42b8e88cabbb0aa33023c7b66b7b93/jessie/Dockerfile)

# Image specific:
* supervisor
* nginx - v1.11.13

# Config:
* Dependencies Package:
  * bzip2
  * zip
  * libssl-dev
* host path : /home/www/public_html/dev.timeclone.com
* container path : /home/www/public_html/dev.timeclone.com

* Nginx Config /etc/nginx/nginx.conf
* Virtual Host Config /etc/nginx/sites-available/dev.timeclone.com
* SSL Link
  - /etc/ssl/certs:/etc/ssl/certs
  - /etc/ssl/private:/etc/ssl/private

* supervisor run : service nginx start
* exposed port 80 443
* default command: /usr/bin/supervisord

# Run example
```console
$docker-compose build
$docker-compose up -d

CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                                      NAMES
c8a86df9c41b        thinegan/debian-nginx   "/usr/bin/supervis..."   21 minutes ago      Up 21 minutes       0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   nginx1
708347cbab8c        thinegan/debian-php5    "docker-php-entryp..."   21 minutes ago      Up 21 minutes       9000/tcp                                   phpfpm2
f53cd7b554d1        thinegan/debian-php5    "docker-php-entryp..."   21 minutes ago      Up 21 minutes       9000/tcp                                   phpfpm3
9862be6d3b03        thinegan/debian-php5    "docker-php-entryp..."   21 minutes ago      Up 21 minutes       9000/tcp                                   phpfpm1

$curl https://dev.timeclone.com/test.php

```

# Issues
If you run into any problems with this image, please check (and potentially file new) issues on the [thinegan/debian-nginx](https://github.com/thinegan/debian-nginx) repo, which is the source for this image.

