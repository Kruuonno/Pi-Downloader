sudo umount /dev/sdb1
sudo -i
grep -q 'data' /etc/fstab || 
printf '# data\n/dev/sdb1    ~/data    ext4    defaults    0    2\n' >> /etc/fstab
exit
