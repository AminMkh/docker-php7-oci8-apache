# Docker php7-oci8-apache

This image is built on the [official PHP docker image](https://hub.docker.com/_/php/)

It contains PHP 7, Apache 2, Oracle's OCI8 extension.

You can use it to connect your docker instance with Oracle DB.

To use this image, docker-compose is prefered:

```
docker-compose up
```

Then go to 

http://localhost/

and you should see the PHP Info page, with OCI8 enabled
