#!/usr/bin/env bashio
# shellcheck shell=bash
set -e

FOLDERS=$(bashio::addon.config | jq -r ".folders")
EXTERNAL_FOLDER=$(bashio::config 'external_folder')
ENABLE_SNAPS=$(bashio::config 'snapshots')
SNAPSHOT_TIME=$(bashio::config 'snapshot_keep_days')

if ! bashio::config.has_value 'external_device'; then
  bashio::log.info "Detected devices..."
  ls -h1 /dev/sd*
  echo "sda" && cat /sys/class/block/sda/device/{model,vendor}
  echo "sdb" && cat /sys/class/block/sdb/device/{model,vendor}
  echo "sdc" && cat /sys/class/block/sdc/device/{model,vendor} 

  bashio::log.info "Select your device and insert it in the 'external_device' addon option."
  bashio::log.info "For example: \"External_device: /dev/sda1\""
  bashio::log.info "Then restart the addon for the first sync."

else
  bashio::log.info "Starting sync..."
  EXTERNAL_DEVICE=$(bashio::config 'external_device')


  bashio::log.info "Mounting device ${EXTERNAL_DEVICE}"
  mkdir -p /external
  mount "${EXTERNAL_DEVICE}" /external
  if [ "$ENABLE_SNAPS" == "true" ]; then
    mkdir -p "/external/snapshot"
  fi

  folder_count=$(echo "$FOLDERS" | jq -r '. | length')
  for (( i=0; i<folder_count; i=i+1 )); do
    local=$(echo "$FOLDERS" | jq -r ".[$i].source")
    options=$(echo "$FOLDERS" | jq -r ".[$i].options // \"-avuh --delete\"")
      
    bashio::log.info "Sync ${local} -> ${EXTERNAL_DEVICE}/${EXTERNAL_FOLDER} with options \"${options}\""

    # Check if the local folder is empty
    if [ -z "$(ls -A $local)" ]; then
      bashio::log.info "Local folder ${local} is empty. Skipping synchronization."
    else
      # Get the current date in the format YYYY-MM-DD
      current_date=$(date +'%Y-%m-%d')
      # shellcheck disable=SC2086
      if [ "$ENABLE_SNAPS" == "true" ]; then
        bashio::log.info "Making snapshot"
        mkdir -p "/external/snapshot/${current_date}"
      fi
      
      # Modify rsync command based on enable_snaps option
      if [ "$ENABLE_SNAPS" == "true" ]; then
        rsync_options="${options} --backup --backup-dir=/external/snapshot/${current_date}"
      else
        rsync_options="${options}"
      fi
      set -x
      rsync ${rsync_options} "$local" "/external/${EXTERNAL_FOLDER}"
      set +x

      # Remove snapshot folders older than 2 months
      find /external/snapshot -type d -name "????-??-??" -mtime +${SNAPSHOT_TIME} -exec rm -r {} \;
    fi
  done


  umount /external
  bashio::log.info "Synced all folders"
fi
