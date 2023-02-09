#!/bin/bash

PLATFORM=$(uname)
if ! [ "$PLATFORM" = "Linux" ]; then 
    echo "Platform is not 'linux', and hence is not supported by this script." && exit 1
fi

echo "Checking if curl is installed"
if ! dpkg-query -W -f='${Status}' curl | grep "ok installed" > /dev/null; then sudo apt install curl; fi
echo "Checking if perl is installed"
if ! dpkg-query -W -f='${Status}' perl | grep "ok installed" > /dev/null; then sudo apt install perl; fi
echo "Checking if build-essential is installed"
if ! dpkg-query -W -f='${Status}' build-essential | grep "ok installed" > /dev/null; then sudo apt install build-essential; fi

VERSION=$(echo $(uname -r) | grep -oP "\d+\.\d+")

IS_ODROID="false"
if [ -x "$(command -v odroid-tweaks)" ]; then 
    IS_ODROID="true"
    VERSION=$(uname -r)
fi

IS_TEGRA="false"
if [ -x "$(command -v jetson_clocks)" ]; then IS_TEGRA="true"; fi

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
elif $IS_TEGRA; then
    curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/Kconfig
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/Makefile
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_ctrl.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_debugfs.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_driver.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_entity.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_isight.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_metadata.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_queue.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_status.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_v4l2.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvc_video.c
	curl -O -J -L -s https://raw.githubusercontent.com/autodarts/releases/main/uvc/${VERSION}-tegra/uvcvideo.h
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

echo "Creating backup of official driver file"
sudo mv /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko.bak

echo "Copying hacked driver"
sudo cp ./uvcvideo.ko /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko

echo "Loading hacked driver in running kernel"
sudo rmmod uvcvideo
sudo insmod /lib/modules/$(uname -r)/kernel/drivers/media/usb/uvc/uvcvideo.ko

echo "Cleaning up temporary files"
sudo rm -rf /tmp/uvc

echo "Done"