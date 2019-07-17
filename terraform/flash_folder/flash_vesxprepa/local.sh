##### this file is to replace the esx template to overcome the limitation of esx clone info confliction
#!/bin/sh

# local configuration options

# Note: modify at your own risk!  If you do/use anything in this
# script that is not part of a stable API (relying on files to be in
# specific places, specific tools, specific output, etc) there is a
# possibility you will end up with a broken system after patching or
# upgrading.  Changes are not supported unless under direction of
# VMware support.

# Note: This script will not be run when UEFI secure boot is enabled.

# by default, vmk mac is duplicated from orginal template and not be able to chnage
# this command is to tell esx to follow hardware mac address
esxcli system settings advanced set -o /Net/FollowHardwareMac -i 1

###
# this shell is not cover this, but it is better to comment the system/uuid line under /etc/vmware/esx.conf
###

# get datastore mpx id by " vmkfstools -P /vmfs/volumes/datastore1 "" 
# resign datastore uuid. after clone, the uuid is kept same that cause join vc confliction
esxcli storage filesystem unmount -l datastore1
/usr/sbin/vmkfstools -C vmfs5 -b 1m -S datastore1 /vmfs/devices/disks/mpx.vmhba0:C0:T0:L0:3

# change filename to avoid storage resign
mv /etc/rc.local.d/local.sh /etc/rc.local.d/local.bak

# reboot machine
reboot
exit 0
