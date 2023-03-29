# Changelog

## 2023-03-29

### Board Client `0.18.2`

- We fixed a bug that could lead to bad performance on low-end devices.
- We fixed a bug where the board always needed to be reset after retart.
- We introduced a watermark on the live streams.

## 2023-03-27

### Board Client `0.18.1`

- We fixed a memory leak in the `/api/img/live` andpoint that was called by the backend to create the live board.
- We switched to the updated board connection logic.

## 2023-03-10

### Board Client `0.18.0`

- Windows and MacOS are now officially supported.
- Windows performance was drastically improved by running the cameras directly in MJPG mode. Before there was a bug where this setting was not correctly set.
- We added a new "Distortion" tab in the Board Manager that allows to create the `distortion.json` directly from within the Board Manager. The board client will then calculate the `distortion.json` and activate it. This can take a couple of minutes to compute, so be patient.
- We added new endpoints for MJPG streams, `/api/streams`
  - `/api/streams/live` can be used to live stream the cams while the Board Client is detecting.
  - You can use the `cam=<cam_id>` query parameter to select a specific cam.
  - You can use the `update=<always|onChange|onDart>` query parameter to control how often the stream is updated.
    - `always` updates after every main loop iteration.
    - `onChange` updates whenever there is a change in the image.
    - `onDart` updates after a dart has been detected and after the takeout.
  - You can use the `warp=true` query parameter to get the frontal view after the board calibration has been applied.
  - A good setting for streaming with OBS would be this `http://<board_ip>:3180/api/streams/live?cam=0&warp=true&update=onDart`.

## 2023-03-09

### Board Client `0.18.0-rc1`

- We added new endpoints for MJPG streams, `/api/streams`
  - `/api/streams/live` can be used to live stream the cams while the Board Client is detecting.
  - You can use the `cam=<cam_id>` query parameter to select a specific cam.
  - You can use the `update=<always|onChange|onDart>` query parameter to control how often the stream is updated.
    - `always` updates after every main loop iteration.
    - `onChange` updates whenever there is a change in the image.
    - `onDart` updates after a dart has been detected and after the takeout.
  - You can use the `warp=true` query parameter to get the frontal view after the board calibration has been applied.
  - A good setting for streaming with OBS would be this `http://<board_ip>:3180/api/streams/live?cam=0&warp=true&update=onDart`.
- We fixed a couple of race conditions when accessing detection state information.
- Windows performance should now be on par with MacOS and Linux.
- Bug fixes.

## 2023-03-08

### Board Client `0.18.0-beta8`

- We re-wrote the API with a faster router implementation.
- Bug fixes.

## 2023-03-07

### Board Client `0.18.0-beta7`

- Fix MJPG bug on linux.

## 2023-03-06

### Board Client `0.18.0-beta6`

- Fix bug where the MJPG stream would encode for every connected client.

### Board Client `0.18.0-beta5`

- Ignore OBS Virtual Camera.

### Board Client `0.18.0-beta4`

- We fixed a bug where broadcasting messages could block.
- Bug fixes.

## 2023-03-02

### Board Client `0.18.0-beta3`

- We fixed a bug in Windows where the cameras did not start in MJPG mode. This boosts FPS on Windows to the same level as Linux and MacOS.
- Bug fixes.

## 2023-03-01

### Board Client `0.18.0-beta2`

- We added support for the checkerboard cam calibration. You can find it in the Distortion tab in the Board Manager.
- Bug fixes.

## 2022-07-25

### Board Client `0.17.0`

- We added device listing support for Windows, Linux, and MacOS. Now the available cameras will be correctly populated in the Board Manager for all OSes.
- We removed the synchronization mechanism that aligned FPS in the main loop with the lowest FPS coming from the cams. Overall this should give more stable performance.
- We fixed a bug where cameras were not correctly freed when one of the cams had failed, resulting in segmentation fault crashes.
- We added two flags to the `autodarts` binary:
  - If you run `autodarts --version`, it will return the Board Client version.
  - If you run `autodarts --opencv-info`, it will return build information on the included OpenCV build.
- We optimized the included OpenCV version to use a pre-compiled version of the `libjpeg-turbo` library with optimizers for different kernel architectures.
- We reduced the footprint of the included OpenCV version to only bundle the necessary libraries, which overall reduced the size of the binaries.
- We added support for Windows, Linux, and MacOS to retrieve host information from all OSes.
- **Most importantly, we added support for Windows and provide an executable for Windows for the first time. Windows, however, is quite picky when it comes to connecting multiple cameras to the same USB port. It is adviced to connect every camera individually to different USB ports. I have tested on multiple machines, and this generally seems to work. It is not guaranteed to work, though. Windows support is still young, and things might break. So, be patient.**

## 2022-01-24

### Board Client `0.16.1`

- We fixed a bug with the undistortion where different resolutions to the `distortion.json` resolution caused problems.

## 2022-01-17

### Board Manager `0.16.0`

- We updated the Config page. It now lists all of the available devices in a dropdown and only shows resolutions that are common across all devices.
- The Config page now also shows the Board State Bar and Controls at the top.
- The Config page now allows to revert the Motion Detection and Dart Detection settings to their defaults. The default settings are based on the chosen resolution.

### Board Client `0.16.0`

- Support for the new Board Manager `0.16.0`.
- Dart Detection: We updated the fallback algorithm when there is only one camera that can see the dart. It should be more accurate now, albeit still bad. If only one camera sees the dart, detections may vary.
- Dart Detection: We added a check for the intersection angle between every pair of two lines. If the intersection angle is less than 5 degrees, the intersection is ignored. This is to counteract problems with inaccuracies where two lines are almost parallel. This only applies in cases where there are three lines.
- Cam: We simplified the startup of the cams so that cam startup does not block the initialization of other modules.
- V4L2: The Board Client now uses the `v4l2-ctl` command internally to list the available devices and sets reasonable defauls when generating the default config.
- The Board Client now sends some user statistics to the Board Server such as Client Version, OS Version information, Config, Calibration, and Distortion parameters.
- Config, Calibration, and Distortion settings are now loaded directly at startup and are not depending on the Cam initialization any longer.
- Config: We updated the default settings to more reasonable defaults. Settings now scale with the `height` as apposed to the product of `height` and `width` (total number of pixels).
