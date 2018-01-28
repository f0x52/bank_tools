#!/usr/bin/env bash
sort -k3 -n $1 | grep -v ^# | grep -v -- ' -' | perl -pe's/( -[\\d.]+)/\\e[31;1m\$1\\e[0m/' | awk '$2>150'
