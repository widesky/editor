#!/bin/sh
#
# Run widesky-editor in a container

set -e

VERSION="latest"
IMAGE="wideskycloud/editor:$VERSION"

EDITOR="widesky-editor"
DOCKER_RUN_OPTIONS="--rm "

# Setup volume mounts for resources that can be
# used by the editor
if [ "$(pwd)" != '/' ]; then
    DOCKER_RUN_OPTIONS=" -v $(pwd):$(pwd)"
fi

# Only allocate tty if one is detected
if [ -t 0 ] && [ -t 1 ]; then
    DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -t"
fi

# `localhost` to be treated as the host's local network. Not the containers.
DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS --network host"

# Always set -i to support piped and terminal input in run/exec
DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -i"

exec docker run --rm $DOCKER_RUN_OPTIONS -w "$(pwd)" $IMAGE ${EDITOR} "$@"
