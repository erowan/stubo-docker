stubo-docker
============

Docker install of standalone Stub-O-Matic

access
======

Docker has it's own repo for images. This build is using my public repo 
erowan/stubo. You need to create a docker.io account to use it. 


install
=======

https://docs.docker.com/installation/#installation

osx requires boot2docker

    install and run boot2docker
    To connect the Docker client (any shell) to the Docker daemon

    set the DOCKER_HOST env var returned from boot2docker

run 
===

linux and osx:

    $ git clone https://github.com/Stub-O-Matic/stubo-docker.git
    $ cd stubo-docker
    $ docker login
    $ ./stubo-env.sh stop
    $ ./stubo-env.sh start
    $ docker ps
    
usage
=====

    vuze-on-pc2:stubo-docker rowan$ pwd
    ./stubo-docker
    
    vuze-on-pc2:stubo-docker rowan$ ./stubo-env.sh start
    Starting MongoDB container...
    c604e2d934c05c75776d9edb0049ba8d324b66aa25869839f5db15b6391914a1
    Starting Redis container...
    be4fa53480272631c9aa0bbac67634a9b575005ec290afe55edd5f1d151fda3d
    Starting Stubo container...
    bd77c9769e244021c628e3ed0ae849d207cd02cfdc10d74d27727d4e46005165
    
    vuze-on-pc2:stubo-docker rowan$ docker ps
    CONTAINER ID        IMAGE                 COMMAND                CREATED             STATUS              PORTS                     NAMES
    bd77c9769e24        erowan/stubo:latest   "stubo -c /opt/stubo   31 minutes ago      Up 3 seconds        0.0.0.0:49162->8001/tcp   stubo-app                     
    be4fa5348027        redis:latest          "redis-server --appe   31 minutes ago      Up 3 seconds        6379/tcp                  stubo-app/redis,stubo-redis   
    c604e2d934c0        mongo:latest          "/entrypoint.sh mong   31 minutes ago      Up 4 seconds        27017/tcp                 stubo-app/mongo,stubo-mongo   
    
    vuze-on-pc2:stubo-docker rowan$ docker logs stubo-app
    2014-09-09 10:05:21,603 INFO  [stubo.utils][1:MainThread] reading config from file: /opt/stubo/stubo-app-matcher/etc/dev.ini
    2014-09-09 10:05:21,604 DEBUG [stubo.utils][1:MainThread] run_template-> {'getenv': <function <lambda> at 0x2dcfaa0>}
    2014-09-09 10:05:21,611 INFO  [stubo.service.run_stubo][1:MainThread] started with 50 worker threads
    2014-09-09 10:05:22,157 WARNI [stubo.service.run_stubo][1:MainThread] [Errno 2] No such file or directory: '/opt/stubo_ng/etc/cluster_name.txt'
    2014-09-09 10:05:22,159 DEBUG [stubo.service.run_stubo][1:MainThread] mongo params: {'tz_aware': True, 'db': 'stubodb', 'max_pool_size': 50, 'host': '172.17.0.27', 'w': '0', 'port': 27017}
    2014-09-09 10:05:22,164 DEBUG [stubo.model.db][1:MainThread] using db=stubodb
    2014-09-09 10:05:22,166 INFO  [stubo.service.run_stubo][1:MainThread] mongo server_info: {u'ok': 1.0, u'OpenSSLVersion': u'', u'bits': 64, u'javascriptEngine': u'V8', u'version': u'2.6.4', u'allocator': u'tcmalloc', u'versionArray': [2, 6, 4, 0], u'debug': False, u'compilerFlags': u'-Wnon-virtual-dtor -Woverloaded-virtual -fPIC -fno-strict-aliasing -ggdb -pthread -Wall -Wsign-compare -Wno-unknown-pragmas -Winvalid-pch -pipe -Werror -O3 -Wno-unused-function -Wno-deprecated-declarations -fno-builtin-memcmp', u'maxBsonObjectSize': 16777216, u'sysInfo': u'Linux build7.nj1.10gen.cc 2.6.32-431.3.1.el6.x86_64 #1 SMP Fri Jan 3 21:39:27 UTC 2014 x86_64 BOOST_LIB_VERSION=1_49', u'loaderFlags': u'-fPIC -pthread -Wl,-z,now -rdynamic', u'gitVersion': u'3a830be0eb92d772aa855ebb711ac91d658ee910'}
    2014-09-09 10:05:22,167 INFO  [stubo.service.run_stubo][1:MainThread] Starting with "{'tornado.port': '8001', 'mongo.host': '172.17.0.27', 'mongo.max_pool_size': '50', 'num_processes': 1, 'worker': 'thread', 'statsd_client': <statsd.client.StatsClient object at 0x243f110>, 'max_workers': '50', 'db_name': 'stubodb', 'graphite.host': 'http://stubo-graphite.com/', 'stubo_version': '0.6.0', 'redis.host': '172.17.0.28', 'redis_master.port': '6379', 'mongo.db': 'stubodb', 'cluster_name': 'unknown', 'redis.port': '6379', 'redis_master.host': '172.17.0.28', 'lb': '127.0.0.1', 'redis_master.db': '0', 'retry_interval': '10', 'mongo.port': '27017', 'request_cache_limit': 10, 'retry_count': '5', 'ext_cache': <dogpile.cache.region.CacheRegion object at 0x2e171d0>, 'mongo.tz_aware': 'true', 'executor': <concurrent.futures.thread.ThreadPoolExecutor object at 0x2439d90>, 'debug': True, 'mongo.w': '0', 'redis.db': '0', 'tornado.host': 'localhost'}" configuration
    
      
    -- docker has mapped the stubo-app's exposed 8001 port to a dynamically generated one of 49162 which you can see in the output of the 'docker ps'.
    -- you would point your browser to host:49162 to access the stubo app on linux
    -- Note on osx the host would be the virtualbox ip address which you can find with:
    
    vuze-on-pc2:stubo-docker rowan$ boot2docker ip
    
    The VM's Host only interface IP address is: 192.168.59.103          

build
=====
    
    Modify the Dockerfile, then
    $ ./stubo-env.sh build
     
push image
==========
    
    $ docker push "erowan/stubo"
    
notes
=====

The stubo-app is using the standard redis and mongodb containers hosted on docker.io:

    https://registry.hub.docker.com/_/mongo/
    https://registry.hub.docker.com/_/redis/
    
The stubo-app container is linking to them and using the environment variables those containers expose
to set the host & port connection params. This is done via the stubo config file an extract of which is shown below:

    mongo.host = {{getenv('MONGO_PORT_27017_TCP_ADDR')}}
    mongo.port = {{getenv('MONGO_PORT_27017_TCP_PORT')}}
    
    redis.host = {{getenv('REDIS_PORT_6379_TCP_ADDR')}}
    redis.port = {{getenv('REDIS_PORT_6379_TCP_PORT')}} 
    
use docker mongo client to connect to mongodb:

    docker run -it --link stubo-mongo:mongo --rm mongo sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/test"'    
    
use docker redis client to connect to redis:

    docker run -it --link stubo-redis:redis --rm redis sh -c 'exec redis-cli -h "$REDIS_PORT_6379_TCP_ADDR" -p "$REDIS_PORT_6379_TCP_PORT"'    
    
    
Be sure the host has an open port to itself (public IP on the stubo exposed port as stubo command files call stubo itself over HTTP).

I have encountered disk full issues on osx inside the VM. I had to delete all the container IDs listed from this command to resolve

    $ docker ps -a
    $ docker rm <containerID>
    $ docker images
    $ docker rm <imageID>

To see running processes in the VM

    $ boot2docker ssh
    docker@boot2docker:~$ top

It is also possible to ssh to the container via nsenter (see how-to-use-docker-on-os-x-the-missing-guide)


        
useful links
============

http://dockerbook.com/TheDockerBook_sample.pdf
http://developerblog.redhat.com/2014/05/15/practical-introduction-to-docker-containers/
https://blog.codecentric.de/en/2014/01/docker-networking-made-simple-3-ways-connect-lxc-containers/
http://viget.com/extend/how-to-use-docker-on-os-x-the-missing-guide    
              
    
