# usb-backup (Home Assistant Addon)

Plug in a usb drive and backup home assistant. This uses rsync and is based on the amazing work of Poeschl and his [rsync local](https://github.com/Poeschl/Hassio-Addons/tree/main/rsync-local)

![Addon Stage][stage-badge]
![Supports aarch64 Architecture][aarch64-badge]
![Supports amd64 Architecture][amd64-badge]
![Supports armhf Architecture][armhf-badge]
![Supports armv7 Architecture][armv7-badge]
![Supports i386 Architecture][i386-badge]

[![Add repository on my Home Assistant][repository-badge]][repository-url]
[![Install on my Home Assistant][install-badge]][install-url]

[aarch64-badge]: https://img.shields.io/badge/aarch64-yes-green.svg?style=for-the-badge
[amd64-badge]: https://img.shields.io/badge/amd64-yes-green.svg?style=for-the-badge
[armhf-badge]: https://img.shields.io/badge/armhf-yes-green.svg?style=for-the-badge
[armv7-badge]: https://img.shields.io/badge/armv7-yes-green.svg?style=for-the-badge
[i386-badge]: https://img.shields.io/badge/i386-yes-green.svg?style=for-the-badge
[stage-badge]: https://img.shields.io/badge/Addon%20stage-stable-green.svg?style=for-the-badge
[install-badge]: https://img.shields.io/badge/Install%20on%20my-Home%20Assistant-41BDF5?logo=home-assistant&style=for-the-badge
[repository-badge]: https://img.shields.io/badge/Add%20repository%20to%20my-Home%20Assistant-41BDF5?logo=home-assistant&style=for-the-badge

[install-url]: https://my.home-assistant.io/redirect/supervisor_addon?addon=f2011bf5_usb-backup
[repository-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fgooganhiem%2Fgords-ha-addons

# How-to
1. Plug in a usb drive large enough to fit your files
2. Run the addon once with the `external device` empty, check the log and note the `/dev/sd**` of the usb drive you want to use. Copy this into the `external device` section. (typically `/dev/sda1` for rpi, and `/dev/sdb1` for x86 - double check!) 
3. Click start and check logs. Don't `Start at boot` or run with `Watchdog`. By default this backs up all folders available to the addon. Note: if you have network drive mounted to media/share/backup it will be backed-up as well.
4. It only runs if you click start. So write an automation to trigger it automatically/regularly - (see automation example at the bottom of this [doc](https://github.com/googanhiem/gords-ha-addons/blob/main/usb-backup/DOCS.md))

### Requirements
 - USB drive (or thumb drive) formatted with a linux native filesystem - for best results use EXT3, EXT4 or BTRFS (this addon only has access to the first 3 partitions, so try to use fewer). Other filesystems may work, but could have issues.
 - The drive should be at least ~30% larger than your install if you're using snapshots
 - A Home Assistant device that can power a usb drive*

*if you're using rpi, make sure its with a powered drive or powered usb hub. Some rpi usb ports are a little underpowered - underpowered drives cause write errors (a usb thumb drive uses less energy, so might be a good option if you're not backing up too often).

## MORE INFO HERE: [DOCS.md](https://github.com/googanhiem/gords-ha-addons/blob/main/usb-backup/DOCS.md)
