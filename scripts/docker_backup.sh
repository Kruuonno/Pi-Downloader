#!/bin/bash

# pushd ~/LMDS

[ -d ./backups ] || mkdir ./backups

#create the list of files to backup
echo "./docker-compose.yml" >list.txt
echo "./services/" >>list.txt
echo "./volumes/" >>list.txt

#setup variables
logfile=./backups/log_local.txt
backupfile="backup-$(date +"%Y-%m-%d_%H%M").tar.gz"

#compress the backups folders to archive
echo "compressing folders"
sudo tar -czf \
	./backups/$backupfile \
	-T list.txt

rm list.txt

#set permission for backup files
sudo chown pi:pi ./backups/backup*

#create local logfile and append the latest backup file to it
echo "backup saved to ./backups/$backupfile"
sudo touch $logfile
sudo chown pi:pi $logfile
echo $backupfile >>$logfile

#show size of archive file
du -h ./backups/$backupfile

#remove older local backup files
#to change backups retained,  change below +5 to whatever you want (days retained +1)
ls -t1 ./backups/backup* | tail -n +5 | sudo xargs rm -f
echo "recent four local backup files are saved in ~/LMDS/backups"



#cloud related - dropbox
if [ -f ./backups/dropbox ]; then

	#setup variables
	dropboxfolder=/LMDSBU
	dropboxuploader=~/Dropbox-Uploader/dropbox_uploader.sh
	dropboxlog=./backups/log_dropbox.txt

	#upload new backup to dropbox
	echo "uploading to dropbox"
	$dropboxuploader upload ./backups/$backupfile $backupfile

	#list older files to be deleted from cloud (exludes last 7)
	#to change dropbox backups retained, change below -4 to whatever you want
	echo "checking for old backups on dropbox"
	files=$($dropboxuploader list $dropboxfolder | awk {' print $3 '} | tail -n +2 | head -n -4)

	#write files to be deleted to dropbox logfile
	sudo touch $dropboxlog
	sudo chown pi:pi $dropboxlog
	echo $files | tr " " "\n" >$dropboxlog

	#delete files from dropbox as per logfile
	echo "deleting old backups from dropbox if they exist - last 4 files are kept"

	#check older files exist on dropbox, if yes then delete them
	if [ $( echo "$files" | grep -c "backup") -ne 0 ] ; then
		input=$dropboxlog
		while IFS= read -r file
		do
	    	$dropboxuploader delete $dropboxfolder/$file
		done < "$input"
	fi

	echo "backups deleted from dropbox" >>$dropboxlog

fi


#cloud related - google drive
if [ -f ./backups/rclone ]; then
	echo "synching to Google Drive"
	echo "latest 4 backup files are kept"
	#sync local backups to gdrive (older gdrive copies will be deleted)
	rclone sync -P ./backups --include "/backup*"  gdrive:/LMDSBU/
	echo "synch with Google Drive complete"
fi


popd
