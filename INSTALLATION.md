# Starting

```
docker run --name redis -d -t adjs/redis
docker run --name iodocs --link redis:redis -d -t adjs/iodocs REDIS_URL=$REDIS_PORT forever start app.js
```

If you make any changes to the Docker config, you need to build:

```
docker build -t adjs/iodocs /home/core/share/code/adjs/iodocs
```

To fire up a docker container:

```

```
