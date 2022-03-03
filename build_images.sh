#!/bin/sh
cd rabbitmq
docker build -t rmq -f Dockerfile_RabbitMQ .
docker tag rmq:latest rmq:3.8.27
cd ..
cd python38
docker build -t python -f Dockerfile_python .
docker tag python:latest python:3.8.10
cd ..
