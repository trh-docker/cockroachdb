#!/bin/bash
docker build -t quay.io/spivegin/cockroachdb_only:latest .
docker push quay.io/spivegin/cockroachdb_only:latest
