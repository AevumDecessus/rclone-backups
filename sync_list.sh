#!/usr/bin/env bash
# Rclone sync script to backup/restore selected 
# directories to/from rclone destinations

set -e
SCRIPTNAME=$(basename $0)
SCRIPT_DIR=$(dirname "$0")
PIDFILE="/tmp/lock/${SCRIPTNAME}"

RCLONE=`which rclone`
BWLIMIT="04:30,off 12:30,6M"
VERBOSE=0
RCLONE_REMOTE=opendrive

EXCLUDE="${SCRIPT_DIR}/exclude_files.txt"

. ${SCRIPT_DIR}/rclone_functions.sh

lock

sync /home/`whoami`/backups ${RCLONE_REMOTE}:backups

unlock
