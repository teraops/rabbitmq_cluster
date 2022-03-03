#!/bin/sh

docker network remove pl-network
docker rm /service-bus /receiver /sender

docker network create pl-network
docker run -d --name service-bus rmq:latest --net pl-network 
docker network connect --alias rmq-broker  pl-network service-bus

# until docker exec -it service-bus rabbitmqctl cluster_status; do
#     echo "Waiting for service-bus container..."
#     sleep 0.5
# done
sleep 10
docker run -itd --name=receiver --net pl-network -v ${PWD}/rbmq_rec_sender:/data  python:latest python3.8 /data/receive.py
docker network connect --alias rmq-receiver  pl-network receiver

#docker run -dit --rm --name=sender --net pl-network -v ${PWD}/rbmq_rec_sender:/data  python:latest python3.8 /data/send.py && tail -f /dev/null
docker run -itd --name=sender --net pl-network -v ${PWD}/rbmq_rec_sender:/data  python:latest python3.8 /data/send.py
docker network connect --alias rmq-sender  pl-network sender
