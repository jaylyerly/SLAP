#!/bin/sh -x

set -a && source .env && set +a

cat Secrets/Secrets.swift.template \
   | sed "s|%API_KEY%|$API_KEY|g"  \
   | sed "s|%PROJ%|SLAP|g"  \
   > UIKit/SLAP/Constants/Secrets.swift

cat Secrets/Secrets.swift.template \
   | sed "s|%API_KEY%|$API_KEY|g"  \
   | sed "s|%PROJ%|SLAPUI|g"  \
   > SwiftUI/SLAPUI/Controllers/Secrets.swift
