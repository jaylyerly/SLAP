#!/bin/sh -x

set -a && source .env && set +a

cat SLAP/Constants/Secrets.swift.template \
   | sed "s|%API_KEY%|$API_KEY|g"  \
   > SLAP/Constants/Secrets.swift
