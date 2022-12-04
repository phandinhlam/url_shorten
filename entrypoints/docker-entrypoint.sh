#!/bin/sh

set -e

bundle check || bundle install --binstubs="$BUNDLE_BIN"

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi
yarn install --check-files
bundle exec rails s -b 0.0.0.0
