# Autodarts Board Client

You can install autodarts on a Linux system by using this single command.
It will automatically download the latest version and install a systemd service to automatically start autodarts on startup.
You might have to install `curl` on your machine beforehand.
You can do so with `sudo apt install curl`.

```bash
bash <(curl -sL get.autodarts.io)
```

If you do not want the autostart systemd service to be installed, you can use the `-n` flag as follows.

```bash
bash <(curl -sL get.autodarts.io) -n
```

If you do not want the automatic updater systemd service to be installed, you can use the `-u` flag as follows. This service updates your autodarts instance to the latest stable release on every system start.

```bash
bash <(curl -sL get.autodarts.io) -u
```

If you want to install a specific version, say, `0.16.0`, then you can append the required version to the command as follows.
This can be helpful if you want to downgrade to an earlier version.
This also works with the `-n` and `-u` flag from before, but make sure these flags come before the required version.

```bash
bash <(curl -sL get.autodarts.io) 0.16.0
```

You can control the the `autodarts.service` with the `systemctl` command.

```bash
sudo systemctl start autodarts
sudo systemctl stop autodarts
sudo systemctl restart autodarts
sudo systemctl status autodarts
sudo systemctl disable autodarts
sudo systemctl enable autodarts
```

If you want to see the log output, you can use the following command.

```bash
journalctl -u autodarts -f
```

For Windows and MacOS, which are not well tested, you can go to the releases pages and download the individual versions directly from there.
Make sure that you download the correct version for your Mac, Intel vs Apple Silicon (`amd64` vs `arm64`).

## UVC Hack

If your setup requires the UVC hack, you can now install it with the following command.

```bash
bash <(curl -sL get.autodarts.io/uvc)
```

You can reset the system to the original driver file by passing the `--uninstall` flag as follows.

```bash
bash <(curl -sL get.autodarts.io/uvc) --uninstall
```
