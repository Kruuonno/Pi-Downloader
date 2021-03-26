#sudo umount /dev/sdb1
#sudo -i
sudo mkdir /home/pi/data
grep -q 'data' /etc/fstab || printf '# data\n/dev/sdb1    /home/pi/data    ext4    defaults    0    2\n' >> /etc/fstab
exit
sudo mount -a
sudo chmod 1777 /home/pi/data

