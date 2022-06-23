## Rclone Backup script

### Setup
* Clone this repo to your homedir
* Install rclone from apt
* Config Rclone
* `cp sync_list.sh backup.sh`
* `cp exlude_files.txt.sample exclude_files.txt`
* Open `backup.sh` in your editor and configure a few things
    * `RCLONE_REMOTE=` should be set to the name for your rclone remote you created aboce
    * `BWLIMIT=` This changes your bandwidth limiters for different times if you want them configured
    * the `sync <DIR> ${RCLONE_REMOTE}:<FOLDER>` lines before the `unlock` line are where you configure what you want backed up, and which folders it goes into in gdrive
        * This is relative to the root_folder_id above if you set it, or your base google drive directory otherwise
* cron setup (optional)
    * fix the file permissons on cron.allow `sudo chmod 644 /etc/cron.allow`
    * add yourself to cron.allow ```echo `whoami` | sudo tee /etc/cron.allow```
    * `crontab -e` add this script to your cron jobs on a schedule you'd like

### Restore Process
* `cp sync_list.sh restore.sh`
    * Set it up the same way as backup.sh above, just swap the order of the sync items
    * ``sync ${RCLONE_REMOTE}:<FOLDER> <LOCAL_DIR>

You can call backup.sh with no flags to back up silently, or with the `-v` flag to see verbose output of the backup jobs
