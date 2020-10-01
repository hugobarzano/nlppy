#!/usr/bin/env bash
REPO=$(basename `git rev-parse --show-toplevel`)
docker run -p 4321:4321 $REPO
