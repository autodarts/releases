#!/bin/bash

PLATFORM=$(uname)
if ! [ "$PLATFORM" = "Linux" ]; then 
    echo "Platform is not 'linux', and hence is not supported by this script." && exit 1
fi

if [[ $1 == "--uninstall" ]]; then
    if [ ! -f /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko.bak ]; then
        echo "UVC hack does not seem to be installed. No original driver file found." && exit 1
    fi
    echo "Restoring original uvc driver file"
    sudo mv /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko.bak /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko
    echo "Reloading uvc driver"
    sudo rmmod uvcvideo
    sudo insmod /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko
    echo "Done"
    exit
fi

echo "Checking if curl is installed"
if ! dpkg-query -W -f='${Status}' curl | grep "ok installed" > /dev/null; then sudo apt install curl; fi
echo "Checking if perl is installed"
if ! dpkg-query -W -f='${Status}' perl | grep "ok installed" > /dev/null; then sudo apt install perl; fi
echo "Checking if build-essential is installed"
if ! dpkg-query -W -f='${Status}' build-essential | grep "ok installed" > /dev/null; then sudo apt install build-essential; fi
echo "Checking if linux-headers are installed"
if [ ! -d /lib/modules/$(uname -r)/build ]; then sudo apt install linux-headers; fi

VERSION=$(echo $(uname -r) | grep -oP "\d+\.\d+")

IS_ODROID="false"
if [ -x "$(command -v odroid-tweaks)" ]; then 
    IS_ODROID="true"
    VERSION=$(uname -r)
fi

echo "Downloading files for kernel version $VERSION"

sudo rm -rf /tmp/uvc
mkdir -p /tmp/uvc
cd /tmp/uvc

if $IS_ODROID; then
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/Kconfig
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/Makefile
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_ctrl.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_debugfs.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_driver.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_entity.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_isight.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_metadata.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_queue.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_status.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_v4l2.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvc_video.c
    curl -O -J -L -s https://raw.githubusercontent.com/hardkernel/linux/${VERSION}/drivers/media/usb/uvc/uvcvideo.h
else
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/Kconfig
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/Makefile
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_ctrl.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_debugfs.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_driver.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_entity.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_isight.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_metadata.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_queue.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_status.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_v4l2.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvc_video.c
    curl -O -J -L -s https://raw.githubusercontent.com/torvalds/linux/v${VERSION}/drivers/media/usb/uvc/uvcvideo.h
fi

echo "Applying code patch"
perl -0pi -e 's/ctrl->dwMaxPayloadTransferSize = bandwidth;\n\t}\n}/ctrl->dwMaxPayloadTransferSize = bandwidth;\n\t}\n\tif (format->flags & UVC_FMT_FLAG_COMPRESSED) {\n\t\tctrl->dwMaxPayloadTransferSize = 0x300;\n\t}\n}/' uvc_video.c

echo "Compiling new uvc driver"
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd) modules

if [ ! -f /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko.bak ]; then
    echo "Creating backup of official driver file"
    sudo cp /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko.bak
fi

echo "Copying new uvc driver"
sudo cp ./uvcvideo.ko /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko

echo "Reloading uvc driver"
sudo rmmod uvcvideo
sudo insmod /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko

echo "Done"