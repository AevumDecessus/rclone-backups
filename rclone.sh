#!/usr/bin/env bash
set -e
SCRIPTNAME=$(basename $0)
PIDFILE="/tmp/lock/${SCRIPTNAME}"

RCLONE=/usr/bin/rclone
BWLIMIT="04:30,off 12:30,6M"
VERBOSE=0

EXCLUDE=/home/fixer/backups/exclude_files.txt

function sync() {
  if [ ${VERBOSE} == 1 ]; then
    echo "Syncing ${1} to ${2}"
    ${RCLONE} sync $1 $2 --exclude-from ${EXCLUDE} --progress --bwlimit "${BWLIMIT}"
  else
    ${RCLONE} sync $1 $2 --exclude-from ${EXCLUDE} --quiet --bwlimit "${BWLIMIT}"
  fi
}

function lock() {
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

while getopts ":v" options; do
  case "${options}" in
    v)
      VERBOSE=1
      ;;
  esac
done
lock

sync /tank0/misc/Fragforce_Video opendrive:FF_Video
sync /tank0/camera/originals opendrive:originals
sync /tank0/camera/originals dropbox:originals
sync /tank0/digikam opendrive:digikam
sync /tank0/digikam dropbox:digikam
sync /tank0/calibre opendrive:calibre
sync /tank0/gopro opendrive:gopro
sync /tank0/photos opendrive:photos
sync /tank0/photos dropbox:photos
sync /tank0/secure opensecret:secure
sync opendrive:crypt dropbox:crypt

unlock
