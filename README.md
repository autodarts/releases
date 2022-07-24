# Autodarts.io

You can install autodarts on a Linux system by using this single command.
It will automatically download the latest version and install a systemd service to automatically start autodarts on startup.

```bash
bash <(curl -sL get.autodarts.io)
```

Example output:

```
> bash <(curl -sL get.autodarts.io)
Downloading latest version v0.16.1.
Downloading and extracting 0.16.1/autodarts0.16.1.linux-arm64.tar.gz.
autodarts
Creating systemd service for autodarts to start on system startup.
We will need sudo access to do that.
Enabling systemd service.
Starting autodarts.
Finished.
```
