#!/bin/sh -x

set -a && source .env && set +a

cat SLAP/Controllers/Secrets.swift.template \
   | sed "s|%API_KEY%|$API_KEY|g"  \
   > SLAP/Controllers/Secrets.swift
