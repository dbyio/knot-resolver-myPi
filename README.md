# Simple docker image for Knot DNS Resolver

## Foreword

This image provides a DNS resolver service (with cache). It is intended for low traffic, capable of supporting a private, home network when run on a Raspberry Pi. It runs a single, mono-threaded DNS resolver instance, and does not intend to exploit the full capabilities and great performance that [Knot Resolver](https://www.knot-resolver.cz/) can otherwise provide.


## Building the knot-resolver image

This will use docker composer to build (or rebuild) the image.

```
sudo make build
```


## Install configuration files

```
sudo make install
```

In the ideal situation where you already have a working systemd docker-compose@ unit file, the installation process will also enable the unit. 


## Authorizing network blocks

By default, the DNS resolver will discard all requests. You *must* explicitely authorize network blocks to access the service (typically, your home network and other docker containers), by editing the .env file located in the /etc/docker/compose/knot-resolver directory. Authorized blocks are stored in the AUTHORIZED_BLOCKS environment variable (comma separated, no space). If you change the value, you'll need to compose down/up the docker container (not rebuild the image).
A sample setup is provided in the conf/config.env file.
