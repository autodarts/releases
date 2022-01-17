# Changelog

## 2022-01-17

### Board Manager `0.16.0`
* We updated the Config page. It now lists all of the available devices in a dropdown and only shows resolutions that are common across all devices.
* The Config page now also shows the Board State Bar and Controls at the top.
* The Config page now allows to revert the Motion Detection and Dart Detection settings to their defaults. The default settings are based on the chosen resolution.

### Board Client `0.16.0`
* Support for the new Board Manager `0.16.0`.
* Dart Detection: We updated the fallback algorithm when there is only one camera that can see the dart. It should be more accurate now, albeit still bad. If only one camera sees the dart, detections may vary.
* Dart Detection: We added a check for the intersection angle between every pair of two lines. If the intersection angle is less than 5 degrees, the intersection is ignored. This is to counteract problems with inaccuracies where two lines are almost parallel. This only applies in cases where there are three lines.
* Cam: We simplified the startup of the cams so that cam startup does not block the initialization of other modules.
* V4L2: The Board Client now uses the `v4l2-ctl` command internally to list the available devices and sets reasonable defauls when generating the default config.
* The Board Client now sends some user statistics to the Board Server such as Client Version, OS Version information, Config, Calibration, and Distortion parameters.
* Config, Calibration, and Distortion settings are now loaded directly at startup and are not depending on the Cam initialization any longer.
* Config: We updated the default settings to more reasonable defaults. Settings now scale with the `height` as apposed to the product of `height` and `width` (total number of pixels).

### Downloads
* `autodarts0.16.0.linux-amd64.opencv4.2.0.zip` - Linux - 64bit - Intel Processor - OpenCV 4.2.0 - Use this for Ubuntu etc.
* `autodarts0.16.0.linux-arm64.opencv4.1.1.zip` - Linux - 64bit - ARM Processor - OpenCV 4.1.1 - Use this for Jetson Nano
* `autodarts0.16.0.linux-armv7l.opencv4.5.5.zip` - Linux - 32bit - ARM Processor - OpenCV 4.5.5 - Use this for Raspberry Pi