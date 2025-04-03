#!/bin/sh -x

set -a && source .env && set +a

cat Secrets/Secrets.swift.template \
   | sed "s|%API_KEY%|$API_KEY|g"  \
   > UIKit/SLAP/Constants/Secrets.swift
