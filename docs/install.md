# Install ledger-app-hns

- [Docker Install](#docker-install)
  - [Build and Load app](#build-and-load-app)
  - [Only Build app (for emulator)](#only-build-app-for-emulator)
- [Non-Docker Install](#non-docker-install)

Docker is the recommended way to build the app and load it onto a device.

## Docker Install

Ensure [Docker][docker] installed and running on your machine.

```sh
$ git clone https://github.com/handshake-org/ledger-app-hns.git
$ cd ledger-app-hns

# Build the builder image
$ docker build -f Dockerfile.builder -t ledger-hns-builder .
```

With the builder ready, either build the app and load to device, or only build
the app for use with an emulator.

Once the app is on a device, install the [client library][hsd-ledger] to
interact with it.

### Build and Load app

1. Connect the Ledger Nano S to your machine via USB.
2. Unlock the device.
3. Navigate to the device's main menu.

Build the app and load it on device:

```sh
# Set the model to one of NANOS, NANOX, NANOSP
$ docker run --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) \
      --privileged -v "/dev/bus/usb:/dev/bus/usb" \
      -e MODEL=NANOSP ledger-hns-builder:latest -- load
```

> **Note:** the above `docker run` command uses the `--privileged` flag, which
> gives the docker container full access to your host machine. If you know the
> location of your connected Ledger Nano S you can >replace the `--privileged`
> tag with `--device=/path/to/usb/device`.

- Follow the terminal and on-device instructions (this process takes a while).

### Only Build app (for emulator)

```sh
# Set the model to one of NANOS, NANOX, NANOSP
$ docker run --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) \
      -e MODEL=NANOX ledger-hns-builder:latest
```

The built app will be at `./build/[model]/bin/app.elf`

To run the app in [Speculos][speculos]:

```sh
# Set the build folder appropriately
# Set the model to one of nanos, nanox, nanosp
$ docker run --rm -ti -v \
  "$(realpath .)/build/nanox/bin:/speculos/apps" \
  --publish 9999:9999 --publish 5000:5000 \
  ghcr.io/ledgerhq/speculos \
  --display headless \
  --model nanox \
  apps/app.elf
```

This starts a web server, access it at http://127.0.0.1:5000

For more info on speculos, check out their [readme and docs][speculos].

### Configuration

To build the app with a different version of SDK / OS, pass in an environment
variable when creating the builder:

```sh
# Build an app for Nano X with older SDK (https://github.com/LedgerHQ/ledger-secure-sdk/tags)
$ docker build -f Dockerfile.builder -t ledger-hns-builder --build-arg NANOX_SDK_TAG=v5.7.0 .
```

To build with the debug flag set (prints logs in the emulator),
suffix `-- DEBUG=1` which is passed on to `make`:

```sh
$ docker run --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) \
      -e MODEL=NANOX ledger-hns-builder:latest -- DEBUG=1
```

## Non-Docker Install

**macOS and Windows are not supported.** If you are _not_ running Linux, please
follow the Docker instructions above.

To load the app on your Ledger Nanos S without using Docker:

- Follow the setup instructions [here][setup].
- Run `make load` in the root of this git repo.
- Follow the terminal and on-device instructions (this process takes a while).

Once the app is on a device, install the [client library][hsd-ledger] to
interact with it.

[docker]: https://www.docker.com/get-started
[hsd-ledger]: https://github.com/handshake-org/hsd-ledger
[speculos]: https://github.com/LedgerHQ/speculos
[setup]: https://developers.ledger.com/docs/nano-app/load/
