# About
This is simplified automatic backup solution using rsync for Home Assistant OS. It can backup all the main Home Assistant folders and mounted network drives. It also has the ability to snapshot overwritten/deleted files for easy recovery.

### Thanks
This is heavily based on the amazing work of Poeschl and his [rsync local](https://github.com/Poeschl/Hassio-Addons/tree/main/rsync-local)

***Warning: This is just one part of a backup solution, don't use this exclusively as its not perfect and may lose your data.***

# How-to
1. Plug in a usb drive large enough to fit your files
2. Run the addon once without `external device` and note the `/dev/sd**` of the usb drive. Copy this into the `external device` section. (if you have a rpi using an sd card its probably /dev/sda1, if your using x86 its likely /dev/sdb1 - double check!)
3. Click start and check logs. Don't `Start at boot` or run with `Watchdog`. By default this backs up all folders available to the addon. Note: if you have network drive mounted to media/share/backup it will be backed-up as well.
4. Write an automation to trigger it - (see automation example below)

### Requirements
 - USB drive (or thumb drive) formatted with a linux native filesystem - for best results use EXT3, EXT4 or BTRFS (this addon only has access to the first 3 partitions, so try to use fewer). Other filesystems may work, but could have issues.
 - The drive should be at least 30% larger than your install if you're using snapshots
 - A Home Assistant device that can power a usb drive*

*if you're using rpi, make sure its with a powered drive or powered usb hub. The some rpi usb ports are a little underpowered - underpowered drives cause write errors (a usb thumb drive uses less energy, so might be a good option if you're not backing up too often).

### Restoring backups
This backs up system folders and doesn't create Home Assistant backup files (used for easy/seamless backups and restores - [more info](https://www.home-assistant.io/common-tasks/os/#backups)), though if those exist they will be transferred to usb if you include the `backups` folder.

Using this with the [Sabeechen's Google Drive Backup](https://github.com/sabeechen/hassio-google-drive-backup) is a great start to a [3-2-1 backup solution](https://www.techtarget.com/searchdatabackup/definition/3-2-1-Backup-Strategy).

## Tech
This uses rsync, an advanced file copying tool. Specifically,

`rsync -avuh --delete --backup --backup-dir=/external/snapshot/ /source/ /usb-drive/backup`

`-avuh` - copies everything it finds and tried to maintain most details

`--delete` - When run more than once it will skip unchanged files and delete files that are gone - matching its source.

`--backup` - in the snapshot folder it will temporarily store files it deletes or overwrites if you need to recover them (disable this by turning off snapshots)

[More detail on the command](https://explainshell.com/explain?cmd=rsync+-avuh+--delete+--backup+--backup-dir%3D%2Fexternal%2Fsnapshot%2F+%2Fmedia%2F+%2Fexternal%2Fbackup)

## Security

In order to mount your external device the integrated AppArmor feature is disabled.
This addon has access to the devices with the path from the available `external_device` config option.

## Config

Example config:

```yaml
folders:
  - source: /config
  - source: /media/playlists
    options: '-archive --recursive --compress'
external_folder: backup
external_device: ''
snapshots: true
snapshot_keep_days: 60
```

### `folders`

The list of folders you want to sync with the remote machine. If this base folder is empty the addon will skip it (this is designed to prevent unmounted network drives from being deleted).

### `folders` - `source`

The source folder for rsync. (the addon has access to `config, share, media, backup and ssl`)

### `folders` - `options` (optional)

Use your own options for rsync. This string is replacing the default one and get directly to rsync. The default is `-avuh --delete`.

### `external_folder`

The base folder on the external usb drive or usb stick for syncing the folders. Sub-folders with the folders from above will be created there.
This path should not start with `/`.

### `external_device`

If you need to pin down a specific device to make your backup too, here is the option. Per default the device is `/dev/sda1`.
Make sure to adjust it when for example running Home Assistant from a external drive. The `sda1` will be a partition of the Home Assistant drive.

If no device is specified all available devices will be displayed in the log. No sync takes place without device.

Available options: `/dev/sda1`, `/dev/sda2`, `/dev/sda3`, `/dev/sdb1`, `/dev/sdb2`, `/dev/sdb3`, `/dev/sdc1`, `/dev/sdc2`, `/dev/sdc3`

### `snapshots`
Not true snapshots - These allow for files that are deleted or changed during an update to be stored for a set amount of time in dated `snapshot` folder. Think of it like a recycle bin - that also protects against file changes. You can choose how long they are stored by setting the `snapshot_keep_days`. Default is 60 days. Don't use snapshots if you're regularly deleting/changing large amounts of data to make space for other files - as the snapshots will take up space until cleaned.

## Automation example
This automation runes usb-backup after creating a restore point (which will be shored in the backups folder - this allows for easy hass backups).

```
alias: Run usb-backup every Sunday night
description: ""
trigger:
  - platform: time
    at: "03:00:00"
condition:
  - condition: time
    weekday:
      - sun
action:
  - service: hassio.backup_full
    data:
      name: Full Backup {{ now().strftime('%Y-%m-%d') }}
  - delay: "00:10:00"
  - service: hassio.addon_start
    data:
      addon: f2011bf5_usb-backup
mode: single
```
