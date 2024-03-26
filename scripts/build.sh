#!/bin/bash

# This script is used to build all of the modules in the SDV pipeline.
# It requires *quite a lot* of disk space - be warned!

### VERSIONS ###

### NOTE ###
# Specify the versions of the Docker and Lilypad modules in VERSIONS.env

# Change to the directory that this script is in.
cd "$(dirname "$0")"

# Load the versions
source VERSIONS.env

# Check that the Docker versions are set
if [[ -z $SDV_V1_0 ]]; then
    echo "Please set the Docker versions in VERSIONS.env before building."
    exit 1
fi

# Check that HUGGINGFACE_TOKEN is set
if [[ -z $HUGGINGFACE_TOKEN ]]; then
    echo "Please set the HUGGINGFACE_TOKEN before building."
    exit 1
fi

# Build the Docker containers for each model
echo "Building Docker containers..."

# Turn on Docker BuildKit and cd to the docker directory
cd ../docker/
export DOCKER_BUILDKIT=1

# Build the v1.0 modules
docker build -f Dockerfile-sdv-xt-1.0 -t zorlin/sdv:v1.0-lilypad$SDV_V1_0 --target runner --build-arg HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN .

# Publish the Docker containers
echo "Publishing Docker containers..."
docker push zorlin/sdv:v1.0-lilypad$SDV_V1_0=1

# Inform the user they should test the new Docker containers before releasing the associated Lilypad modules
echo "Please test the new Docker containers prior to running release.sh."
echo
echo "The easiest way to test them is, well, Docker! Here's some commands to inspire you:"

echo "docker run -it --gpus all -v $PWD/outputs:/outputs -e PROMPT='a lilypad in space' -e STEPS=69 zorlin/sdv:v1.0-lilypad$SDV_V1_0"
echo
echo "Don't forget to update the README.md with the new versions!"

echo "Done! We have built and published the Docker containers for the SDXL Pipeline modules. You should now be ready to run ./scripts/release.sh to release the new Lilypad versions of the modules."
