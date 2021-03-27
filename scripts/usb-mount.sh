#sudo umount /dev/sdb1
#sudo -i
mkdir /home/pi/data
echo "/dev/sdb1    /home/pi/data    ntfs-3g     uid=pi,gid=pi 0 0" | sudo tee -a /etc/fstab
#sudo grep -q 'data' /etc/fstab || printf '# data\n//dev/sdb1 /home/pi/data ntfs-3g uid=pi,gid=pi 0 0\n' >> /etc/fstab
sudo chmod 1777 /home/pi/data
sudo mount -a

