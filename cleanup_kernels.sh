#!/bin/bash

# Get the currently running kernel version
current_kernel=$(uname -r)

# List all installed kernels (excluding HWE generic packages)
kernels_list=$(dpkg --list | grep linux-image | awk '{print $2}' | grep -v "linux-image-generic-hwe")

# Keep the two most recent kernels, sorted by version
kernels_to_keep=$(echo "$kernels_list" | sort -V | tail -n 2)

# Find kernels that are not the current or the two most recent ones, and mark them for removal
kernels_to_remove=$(echo "$kernels_list" | grep -v -e "$current_kernel" -e "$kernels_to_keep" | tr '\n' ' ')

# If there are kernels to remove, purge them using dpkg and apt
if [ -n "$kernels_to_remove" ]; then
    echo "Removing old kernels..."
    sudo apt-get remove --purge -y $kernels_to_remove
    sudo apt-get autoremove --purge -y
    sudo update-grub
else
    echo "No old kernels to remove."
fi

# Check /boot directory for old kernel files (vmlinuz)
echo "Checking /boot for old kernel files..."
for file in /boot/*; do
    if [[ "$file" =~ vmlinuz-([0-9]+\.[0-9]+\.[0-9]+-[0-9]+) ]]; then
        kernel_version="${BASH_REMATCH[1]}"
        # Remove if the version is not one of the ones to keep
        if [[ ! "$kernels_to_keep" =~ "$kernel_version" ]]; then
            echo "Removing: $file"
            sudo rm -f "$file"
        fi
    fi
done

# Check /boot for old initrd.img files and remove old ones
for file in /boot/*initrd.img*; do
    if [[ "$file" =~ initrd.img-([0-9]+\.[0-9]+\.[0-9]+-[0-9]+) ]]; then
        kernel_version="${BASH_REMATCH[1]}"
        # Remove if the version is not one of the ones to keep
        if [[ ! "$kernels_to_keep" =~ "$kernel_version" ]]; then
            echo "Removing: $file"
            sudo rm -f "$file"
        fi
    fi
done

# Check /boot for old System.map files and remove old ones
for file in /boot/*System.map*; do
    if [[ "$file" =~ System.map-([0-9]+\.[0-9]+\.[0-9]+-[0-9]+) ]]; then
        kernel_version="${BASH_REMATCH[1]}"
        # Remove if the version is not one of the ones to keep
        if [[ ! "$kernels_to_keep" =~ "$kernel_version" ]]; then
            echo "Removing: $file"
            sudo rm -f "$file"
        fi
    fi
done

echo "Old kernel cleanup in /boot completed."

