#!/usr/bin/env bash
set -euo pipefail
# https://wiki.lineageos.org/devices/ocean/install/

command -v adb
adb devices

read -p "Connect the device to your PC via USB."

adb -d reboot bootloader
fastboot devices
shasum -a 256 ./boot.img # should match b71ec075a899ea9d47ff536f614529deec8ec67a16f57033be9c5931c0d25c7b
read -p "Should match b71ec075a899ea9d47ff536f614529deec8ec67a16f57033be9c5931c0d25c7b"

fastboot oem get_unlock_data 2> ./unlock.data
cat ./unlock.data          |
  grep "bootloader"        |
  tail +2                  |
  sed 's/(bootloader) //g' |
  tr -d '\r\n'             |
  tee ./unlock.code; echo
# note that the phone needs to have a SIM card inserted
# follow instructions at https://en-us.support.motorola.com/app/standalone/bootloader/unlock-your-device-b

fastboot flash boot boot.img
read -p "If the flash exits 0, you can ignore an 'Image not signed or corrupt' message."
read -p "Using the volume keys, find 'boot into recovery' and press the power button."
read -p "You should now see the lineagos logo. Press 'Apply Update' and 'Apply from ADB'."
# https://wiki.lineageos.org/devices/ocean/install/#ensuring-all-firmware-partitions-are-consistent

adb -d sideload copy-partitions-20220613-signed.zip

read -p "Advanced > reboot to recovery"
read -p "Now tap Factory Reset, then Format data / factory reset and continue with the formatting process."

# https://wiki.lineageos.org/devices/ocean/install/#installing-add-ons
# https://wiki.lineageos.org/gapps/

adb -d sideload ./lineage-21.0-20240716-nightly-ocean-signed.zip
read -p "Reboot to recovery and sideload the gapps package."
adb -d sideload ./MindTheGapps-14.0.0-arm64-20240612_135921.zip
read -p 'When presented with a screen that says Signature verification failed, click Yes. It is expected as add-ons are not signed with LineageOS’s official key!'
