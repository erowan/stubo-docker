#!/bin/bash

case "$1" in
    start)
        echo "Starting MongoDB container..."
        docker run --name stubo-mongo -d mongo mongod --smallfiles --nojournal
        sleep 15 # Wait for mongo to start
        echo "create mongo capped tracker collection"
        docker run -it --link stubo-mongo:mongo --rm mongo sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/stubodb" --eval "db.createCollection(\"tracker\", {capped:true, size:50000000})"'  
        echo "Starting Redis container..."
        docker run --name stubo-redis -d redis redis-server --appendonly yes
   
        echo "Starting Stubo container..."
        docker run --name stubo-app -d --link stubo-mongo:mongo --link stubo-redis:redis -e STATSD_ADDR=ba-mgt-mi5 -P -t "erowan/stubo"
        echo "#####################################"
        echo "Stubo is now ready to use"        
        ;;
    stop)
        echo "Stopping stubo container..."
        docker stop stubo-app
        echo "Removing stubo container..."
        docker rm stubo-app
        echo "Stopping MongoDB container..."
        docker stop stubo-mongo
        echo "Removing MongoDB container..."
        docker rm stubo-mongo
        echo "Stopping Redis container..."
        docker stop stubo-redis
        echo "Removing Redis container..."
        docker rm stubo-redis
        ;;
        
    mongo-shell)
        docker run -it --link stubo-mongo:mongo --rm mongo sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/stubodb"'
        ;;
        
    stubo-logs)
        docker logs stubo-app 
        ;;   
       
    redis-shell)
        docker run -it --link stubo-redis:redis --rm redis sh -c 'exec redis-cli -h "$REDIS_PORT_6379_TCP_ADDR" -p "$REDIS_PORT_6379_TCP_PORT"' 
        ;;        
          
    build)
        echo "Setting up Stubo data container..."
        docker build -t erowan/stubo .
        ;;
*)
    echo $"Usage: $0 {start|stop|build|stubo-logs|mongo-shell|redis-shell}"
    exit 1
esac
exit 0
