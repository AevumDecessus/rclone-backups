#!/usr/bin/env bash
# This is just an imported script, don't run it itself
set -e
function sync() {
  if [ ${VERBOSE} == 1 ]; then
    echo "Syncing ${1} to ${2}"
    ${RCLONE} sync $1 $2 --exclude-from ${EXCLUDE} --progress --bwlimit "${BWLIMIT}"
  else
    ${RCLONE} sync $1 $2 --exclude-from ${EXCLUDE} --quiet --bwlimit "${BWLIMIT}"
  fi
}

function lock() {
  check_tempdir
  exec 200>$PIDFILE
  flock -n 200 || exit 1
  pid=$$
  if [ ${VERBOSE} == 1 ]; then
    echo "Locking file"
  fi
  echo $pid 1>&200
}

function unlock() {
  if [ ${VERBOSE} == 1 ]; then
    echo "unlocking file"
  fi
  flock -u 200
}

function check_tempdir() {
  if [ ! -d /tmp/lock ]; then
    mkdir /tmp/lock
  fi
}

while getopts ":v" options; do
  case "${options}" in
    v)
      VERBOSE=1
      ;;
  esac
done
