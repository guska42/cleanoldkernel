This script is designed to clean up old kernels on an Ubuntu system, particularly when the /boot partition is small. It ensures that only the current and the two most recent kernels are kept, while all other old kernels are removed.


Identifies the current kernel that is in use by the system.
Lists all installed kernels on the system, excluding any HWE generic kernel packages.
Keeps the two most recent kernels in addition to the currently running kernel.
Removes all older kernels (those that are not the current or the two most recent) using the apt package manager.
Cleans up old kernel-related files in the /boot directory (like vmlinuz, initrd.img, and System.map files) that are no longer associated with the kernels being kept.
Updates the GRUB bootloader after the removal of the old kernels.
To schedule the script to run at every reboot:
Place the script in a desired location (e.g., /root/cleanup_kernels.sh).

Make the script executable: with chmod +x 
and 
crontab -e
Add the following line to ensure the script runs at every system reboot:
@reboot /root/cleanup_kernels.sh

License GNU GPL
