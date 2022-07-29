#!/bin/bash

# this runs each time the container starts

echo "$(date)    post-start start" >> ~/status

#az login
#make cluster

echo "$(date)    post-start complete" >> ~/status
