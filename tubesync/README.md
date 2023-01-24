*****!!!This doesn't work yet!!!*****

# Home assistant add-on: TubeSync

Youtube PVR

## About

This addon is based on the [docker image](https://github.com/meeb/tubesync).

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add my Hass.io add-ons repository][repository] to your Hass.io instance.
1. Install this add-on.
1. Click the `Save` button to store your configuration.
1. Make the directory /share/tubesync to store your downloaded files
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.
1. Open WebUI should work via ingress or <your-ip>:port.

## Configuration

```
port : 4848 #port you want to run on.
```

Webui can be found at `<your-ip>:port`.

[repository]: https://github.com/googanhiem/gords-ha-addons
