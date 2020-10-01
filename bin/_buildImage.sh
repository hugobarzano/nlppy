#!/usr/bin/env bash
REPO=$(basename `git rev-parse --show-toplevel`)
docker build . --file Dockerfile --tag $REPO
