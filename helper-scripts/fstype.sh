#!/usr/bin/env bash

# take device as argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <device>" >&2
  exit 1
fi

PARTITIONS=$(lsblk -pl -o NAME,FSTYPE | tail -n +2)
DEVICE_NAME=$1

# if device = argument then print fstype
IFS=$'\n'
for line in $PARTITIONS; do
 # Extract the device name and filesystem type
  DEVICE=$(echo "$line" | awk '{print $1}')
  FSTYPE=$(echo "$line" | awk '{print $2}')
  
  if [ "$DEVICE" = "$DEVICE_NAME" ]; then
    echo "$FSTYPE" >&2
    if [ "$FSTYPE" = "" ]; then
      echo "No file system type assigned to $DEVICE_NAME" >&2
      exit 1
    fi
    exit 0
  fi
done

echo "Device $DEVICE_NAME not found" >&2
exit 1

