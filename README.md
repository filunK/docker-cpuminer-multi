# docker-cpuminer-multi

[cpuminer-multi](https://github.com/tpruvot/cpuminer-multi) with Container

## Required Environment Variables

Following Environment Variables are required:

| Parameter | Default | Description |
| :-: | :-: | :-- |
| ALGOLITHM | "" | An algorithm to use |
| THREADS | 1 | A number of thread to run|
| URL | "" | A URL of connection pool to connect |
| USER | "" | A user name to connect URL |
| PASSWORD | "" | A password to connect URL |

## Building Instructions

### Build Simple

``` bash
docker build \
    --compress \
    -f ./Dockerfile \
    -t cpuminer-multi:latest \
    .

```

### Build Multi-arch

__KNOWN ISSUE__: __The image for Architecture ``linux/arm64`` cannot build with ``docker buildx`` on ``Linux/amd64`` host.__

``` bash
docker buildx create \
    --name cpuminer-multi-builder \
    --driver docker-container \
    # You can override required platforms as you like
    --platform linux/amd64,linux/arm64

docker buildx use cpuminer-multi-builder

docker buildx build \
    -t yourAccount/cpuminer-multi:latest \
    -t yourAccount/cpuminer-multi:1.3.7 \
    -t yourAccount/cpuminer-multi:1.3.7_alpine \
    -t yourAccount/cpuminer-multi:1.3.7_alpine3.17.0 \
    -f ./Dockerfile \
    --push \
    .
```

## Templates

### BitZeny

[BitZeny info](https://bitzeny.tech/)

``` bash
docker run \
    -e ALGOLITHM=yescryptr8 \
    -e URL="stratum+tcp://from/to" \
    -e USER=****** \
    -e PASSWORD=****** \
    -e THREADS=1 \
    --name cpuminer-multi-bitzeny \
    cpuminer-multi:latest
```
