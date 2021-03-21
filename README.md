# docker-php-nginx-base

+ nginx is listening to port 8080
+ it's a private docker repository, so you need to log in first
    + `doctl registry login`
+ mount the app in `/application` with root in `/application/public`

## Behavior

All calls with /api/ will be routed to index.php anytime!

If there is an index.html nginx will route all calls there (if no /api/ included),
else nginx will take index.php.

```
location / {
    try_files $uri $uri/ /index.html /index.php$is_args$args;
}

location ~ ^/api/ {
    try_files $uri /index.php$is_args$args;
}
```

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
