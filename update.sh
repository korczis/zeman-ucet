#! /usr/bin/env bash

git pull && bundle exec ./main.rb && git commit -a -m "update" && git push

