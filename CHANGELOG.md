# Autodarts Detection Changelog

## 2023-03-11 - 0.23.3

- We updated the takeout detection to be more robust in situations where the board can move slightly.

## 2023-02-20 - 0.23.2

- We added a routine that cleans up the incorrectly created config directory.
- We changed the hand detection to account for screen shake.
- We changed some default parameters to allow for better dart and takeout detection.
- When changing camera settings in the Config tab, an auto-calibration will now be automatically performed.

## 2023-02-16 - 0.23.1

- We fixed a bug where the default config was not correctly created.

## 2023-02-14 - 0.23.0

This release focuses on the takeout detection and optimizing the number of parameters necessary to run Autodarts.

- We introduced a background mask that ignores any changes that happen outside of the board area. This might lead to
  darts that hit outside of the board area, e.g., on the surround, to not be detected any more (but they don't count
  anyway 😉). Miscounts because of people entering the room and passing by in the background of any camera image should
  now be a thing of the past.
- We re-implemented the takeout detection logic to be more robust. Takeout detections should now be more consistent. We
  also changed how the state logic works. As soon as a hand was detected in the image, the board client will no longer
  detect darts, and expect a takeout to follow. You can still click reset to get it back.
- The Board Manager Config page has been drastically overworked. Most of the parameters are no longer necessary because
  they are calculated based on the Calibration of the board. All parameters are now relative to the size of the board in
  the image instead of relative to the chosen resolution.
- We fixed a couple of bugs. Most notably the memory leak that was reported in Discord.

## 2023-11-14 - 0.22.0

- We drastically improved the accuracy of the detection algorihtm.
  - In our internal test with over 20 users, we reached an overall accuracy of **99.3%**, the median accuracy among
    all participants is **99.5**.
  - The group consisted of a wide variety of different users, ranging from low averages to very high averages.
  - All testers confirmed a much better game play and feeling because of the increased accuracy.
- We introduced a new look and feel for the Motion and the Dart tab in the Board Manager.
  - Motion tab:
    - The Motion tab now uses a new virtual dart board visualization that mimics the look of the Autodarts virtual
      board.
    - Differences are drawn in real time on the virtual board.
    - The upper image shows the difference in the current image compared to the latest stable image.
    - The lower image shows what Autodarts remembers as the darts that need to be taken out for the takeout to be
      registered.
  - Dart tab:
    - The Dart tab now uses a new virtual dart board visualization that mimics the look of the Autodarts virtual
      board.
    - Each row in the image corresponds to the respective dart in the current round.
    - Autodarts now uses a single cam fallback mechanism. The single cam detections are highlighted in the image in
      yellow.
      - Note that the single cam detection is not always used, and that the detected segment is not always the
        same as the ones the single cam detection calculates.
      - The final result of the detection is a combination of multiple things, including but not limited to, the
        intersections of the detected lines, the single cam detections, special heuristics.
      - When trying to understand a (now hopefully rare) miscount, use the Monitor tab (to see the lines) and the
        Dart tab (to see the single cam detections).
- We changed the format and the location of the config files of `autodarts`.
  - The old `config.ini` is migrated to the new `config.toml` file format.
  - The old `calibration.json` is also part of `config.toml`.
  - The old `distortion.json` is also part of `config.toml`.
  - The old `cam_controls.json` is also part of `config.toml`.
  - All of the old files will be migrated to the new `config.toml` format on launch, and the old files will be backed
    up.
  - There is a new location for the `config.toml` which differs on each operating system. The new paths are the
    established defaults for config files on each operating system.
    - Windows: The location of the `config.toml` is `%APPDATA%\autodarts\config.toml`
    - Linux: The location of the `config.toml` is `~/.config/autodarts/config.toml`
    - macOS: The location of the `config.toml` is `~/Library/Application Support/autodarts/config.toml`

## 2023-10-25 - 0.21.6

- We added support for the automatic calibration.
- Bug fixes.

## 2023-08-31 - 0.21.5

- We optimized how many messages are sent to the autodarts servers.

## 2023-08-30 - 0.21.4

- We fixed some bugs with the motion state propagation.
- We added support for the new Board Manager.

## 2023-08-29 - 0.21.3

- We optimized the motion detection speed.
- We addded a new `min_hand_frames` config parameter. A takeout is only detected when a hand was recnognized in the view
  for at least `min_hand_frames` number of frames. This should address the incorrect takeout detections when the second
  dart hit the first dart, resulting in a takeout being detected.
- We added back the `hand_wait_frames` and the `dart_wait_frames` config parameters that verrsion `0.20.1` and `0.20.2`
  reverted.
- The default values for the parameters are:
  - `min_hand_frames = 10`
  - `hand_wait_frames = 10`
  - `dart_wait_frames = 10`
- The new parameters can currently only be set directly in the `config.cfg` file.
- The takeout detection should again be more robust and faster than before.

## 2023-08-28 - 0.21.2

- We reverted the motion detection logic back to how it was in `0.20.1`.

## 2023-08-26 - 0.21.1

- We reverted the logic that detects takeouts to how it was priort to `0.20.2-beta10`.

## 2023-08-26 - 0.21.0

- We have significantly enhanced the performance of the detection algorithm, achieving up to an 8x increase in speed.
- Furthermore, we have optimized the main loop of the motion detection process, resulting in a remarkable 6x
  acceleration.
- Improvements have also been made to the takeout detection algorithm, yielding a 2x speedup.
- Introducing two new configuration parameters, `hand_wait_frames` and `dart_wait_frames`, now provides the ability to
  specify the number of frames to discard after a hand removal or a detected dart action. This level of control enhances
  the precision of the system's response.
- For seamless execution on MacOS (both Intel and Apple Silicon), essential dynamic libraries have been incorporated,
  streamlining the installation process using the conventional bash command mentioned earlier.
- A new feature allows the initiation of a benchmark through the `-benchmark` flag. This benchmark assesses the speed at
  which dart detection occurs on your specific machine.

These collective enhancements not only address issues such as double detections, premature takeout identifications, and
dynamic linking conflicts, but also result in a superior performance compared to all previous versions of autodarts.
Rigorous testing across diverse setups and machines underscores that this configuration stands as the optimal choice. In
all respects, this represents the pinnacle version to date.

### 2023-07-22 - 0.20.1

- Linux: We fixed a bug where the `cam_controls.json` file was not correctly created if it did not exist.
- Windows & MacOS: No meaningful changes.

### 2023-07-22 - 0.20.0

- Linux: We are pleased to announce that Autodarts now supports V4L2 camera controls natively. You can configure your
  camera settings directly from the Config tab in the Board Manager. The settings will be saved in a `cam_controls.json`
  file inside the config directory. Old `cams.sh` scripts will be backed up to `cams.sh.bak`, thereby ignoring the
  old `cams.sh` solution. The `cam_controls.json` only holds the settings that are different from the default values for
  the respective cameras. It is advised to only interact with the camera settings through the Board Manager.
- Windows & MacOS: No meaningful changes.

### 2023-07-13 - 0.19.3

- We now run all server requests in separate threads to not block other requests while one request is taking longer than
  expected.

### 2023-07-04 - 0.19.2

- We reverted the changes from `0.19.1` that lead to delayed detection transmissions to the servers.

### 2023-05-23 - 0.19.1

- We updated the default parameters for some hidden config parameters and added support for the parameters inside
  the `config.cfg` file.
- We fixed some timeout bugs for people with slower internet connection.

### 2023-04-13 - 0.19.0

- We optimized the detection algorithm. This is most likely only the first of a couple of updates to the detection
  algorithm. The detection algorithm has not been updated since the official start of the Autodarts Alpha, back in 2021.
- In our tests, we could - for the first time - consisently reach accuracy values above 99% (playing averages around
  50). An optimized setup is key here, of course. We think you can expect 0.5-2% of increase in your accuracy, depending
  on your setup.
- You might experience longer detection times because the algorithm does more work than it did before. In all our tests
  this was negligible, though.

### 2023-03-29 - 0.18.2

- We fixed a bug that could lead to bad performance on low-end devices.
- We fixed a bug where the board always needed to be reset after retart.
- We introduced a watermark on the live streams.

### 2023-03-27 - 0.18.1

- We fixed a memory leak in the `/api/img/live` andpoint that was called by the backend to create the live board.
- We switched to the updated board connection logic.

### 2023-03-10 - 0.18.0

- Windows and MacOS are now officially supported.
- Windows performance was drastically improved by running the cameras directly in MJPG mode. Before there was a bug
  where this setting was not correctly set.
- We added a new "Distortion" tab in the Board Manager that allows to create the `distortion.json` directly from within
  the Board Manager. The board client will then calculate the `distortion.json` and activate it. This can take a couple
  of minutes to compute, so be patient.
- We added new endpoints for MJPG streams, `/api/streams`
  - `/api/streams/live` can be used to live stream the cams while the Board Client is detecting.
  - You can use the `cam=<cam_id>` query parameter to select a specific cam.
  - You can use the `update=<always|onChange|onDart>` query parameter to control how often the stream is updated.
    - `always` updates after every main loop iteration.
    - `onChange` updates whenever there is a change in the image.
    - `onDart` updates after a dart has been detected and after the takeout.
  - You can use the `warp=true` query parameter to get the frontal view after the board calibration has been applied.
  - A good setting for streaming with OBS would be
    this `http://<board_ip>:3180/api/streams/live?cam=0&warp=true&update=onDart`.

### 2022-07-25 - 0.17.0

- We added device listing support for Windows, Linux, and MacOS. Now the available cameras will be correctly populated
  in the Board Manager for all OSes.
- We removed the synchronization mechanism that aligned FPS in the main loop with the lowest FPS coming from the cams.
  Overall this should give more stable performance.
- We fixed a bug where cameras were not correctly freed when one of the cams had failed, resulting in segmentation fault
  crashes.
- We added two flags to the `autodarts` binary:
  - If you run `autodarts --version`, it will return the Board Client version.
  - If you run `autodarts --opencv-info`, it will return build information on the included OpenCV build.
- We optimized the included OpenCV version to use a pre-compiled version of the `libjpeg-turbo` library with optimizers
  for different kernel architectures.
- We reduced the footprint of the included OpenCV version to only bundle the necessary libraries, which overall reduced
  the size of the binaries.
- We added support for Windows, Linux, and MacOS to retrieve host information from all OSes.
- **Most importantly, we added support for Windows and provide an executable for Windows for the first time. Windows,
  however, is quite picky when it comes to connecting multiple cameras to the same USB port. It is adviced to connect
  every camera individually to different USB ports. I have tested on multiple machines, and this generally seems to
  work. It is not guaranteed to work, though. Windows support is still young, and things might break. So, be patient.**

### 2022-01-24 - 0.16.1

- We fixed a bug with the undistortion where different resolutions to the `distortion.json` resolution caused problems.

### 2022-01-17 - 0.16.0

- Support for the new Board Manager `0.16.0`.
- Dart Detection: We updated the fallback algorithm when there is only one camera that can see the dart. It should be
  more accurate now, albeit still bad. If only one camera sees the dart, detections may vary.
- Dart Detection: We added a check for the intersection angle between every pair of two lines. If the intersection angle
  is less than 5 degrees, the intersection is ignored. This is to counteract problems with inaccuracies where two lines
  are almost parallel. This only applies in cases where there are three lines.
- Cam: We simplified the startup of the cams so that cam startup does not block the initialization of other modules.
- V4L2: The Board Client now uses the `v4l2-ctl` command internally to list the available devices and sets reasonable
  defauls when generating the default config.
- The Board Client now sends some user statistics to the Board Server such as Client Version, OS Version information,
  Config, Calibration, and Distortion parameters.
- Config, Calibration, and Distortion settings are now loaded directly at startup and are not depending on the Cam
  initialization any longer.
- Config: We updated the default settings to more reasonable defaults. Settings now scale with the `height` as apposed
  to the product of `height` and `width` (total number of pixels).
