# docker-php-nginx-base

+ nginx is listening to port 8080
+ it's a private docker repository, so you need to log in first

## Usage
in docker-compose
```yaml
version: '3.7'
services:
    nginx_and_php:
        container_name: project_api
        image: registry.digitalocean.com/bit/php-nginx-base:latest
        volumes:
            - ./backend:/application
        ports:
            - 80:8080
        command: ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
```
