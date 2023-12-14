# ledger-app-hns

This is a key management application for the Handshake Protocol. With support
for both the Ledger Nano S and Ledger Nano X, it allows users to create extended
public keys, addresses, and signatures for valid Handshake transactions. It
can be used with the [hsd-ledger][hsd-ledger] client library to interact with
wallet software.

This document serves as an overview of the relevant technical and licensing
details for this application. For more general information on developing
for Ledger personal security devices please read the official Ledger developer
documentation [here][ledger].

For a walk-through of a Ledger application, check out the [nanos-app-sia][sia]
project. The Nebulous Inc. developers have done a wonderful job of documenting
both the high-level architecture and low-level implementation details of
Nano S app development.

<br/>

## Linux Install

To load the app on your Ledger Nanos S without using Docker:
- Follow the setup instructions [here][setup].
- Run `make load` in the root of this git repo.
- Follow the terminal and on-device instructions (this process takes a while).

Once installation is complete, install the [client library][hsd-ledger].

>Note: macOS and Windows are not supported. If you are _not_ running Linux,
please follow the Docker instructions below.

[setup]: https://developers.ledger.com/docs/nano-app/load/

<br/>

## Docker Install

If you are running [Linux](#linux-host), the only dependency is Docker. If you
are running [macOS](#macos-or-windows-host) or [Windows](#macos-or-windows-host)
you will also need to setup a Python virtualenv and install developer tools
provided by Ledger. Detailed instructions for each host environment are below.

Once installation is complete, install the [client library][hsd-ledger].

>Note: all example commands begin with the $ symbol. This symbol signifies
a shell command prompt. The command prompt in your shell may be different.
Do not copy the $ symbol when using the commands in your shell.

<br/>

### Linux Host
#### Install Dependencies
First, be sure to have [Docker](https://www.docker.com/get-started) installed
and running on your machine.

#### Install `ledger-app-hns`

Clone the git repo:
```bash
$ git clone https://github.com/handshake-org/ledger-app-hns.git
$ cd ledger-app-hns
```

- Connect the Ledger Nano S to your machine via USB.
- Unlock the device.
- Navigate to the device's main menu.

If your device is running firmware v1.6.0, run:
```bash
$ docker build --build-arg CACHE_BUST="$(date)" -f Dockerfile.build -t ledger-app-hns-build .
$ docker run --rm --privileged ledger-app-hns-build make load
```

If your device is running firmware v1.5.5, run:
```bash
$ docker build --build-arg GIT_REF="nanos-1553" --build-arg CACHE_BUST="$(date)" -f Dockerfile.build -t ledger-app-hns-build .
$ docker run --rm --privileged ledger-app-hns-build make load
```

>Note: the above `docker run` command uses the `--privileged` flag, which gives
>the docker container full access to your host machine. If you know the location
>of your connected Ledger Nano S you can >replace the `--privileged` tag
>with `--device=/path/to/usb/device`.

- Follow the terminal and on-device instructions (this process takes a while).

##### Nano X

If you are using a Nano X, run:

```bash
$ docker build --build-arg GIT_NAME="nanox-secure-sdk" --build-arg GIT_REF="1.2.4-5.1" \
               --build-arg CACHE_BUST="$(date)" -f Dockerfile.build -t ledger-app-hns-build .
$ docker run --rm --privileged ledger-app-hns-build make load
```

<br/>

### macOS or Windows Host
#### Install Dependencies
First, be sure to have the following development dependencies installed on
your machine:
- [Docker](https://www.docker.com/get-started)
- Python 2.7 development environment (`python2`, `python2-dev`, `virtualenv`)
- `make`
- `gcc`
- `g++`
- `git`

Next, create a directory to store the [Nano S Secure SDK][sdk] and the Python
virtual environment for the [Python Loader tool][loader]. The SDK is used in
`ledger-app-hns` to interact with the device's operating system and crypto
libraries. The loader tool loads compiled applications onto your Ledger Nano S.

It does not matter where you store the SDK or the virtual environment.
For simplicity, this guide stores them together in a directory called
`ledger-tools`.

To begin, open a terminal shell and run:
```bash
$ mkdir ledger-tools
$ cd ledger-tools
```

#### Install Nano S Secure SDK
Before installing the SDK, you will need to know what firmware version is
running on your Ledger Nano S. If you do not know how to check your firmware
version, follow the instructions [here][firmware]. This application supports
`v1.6.0 and `v1.5.5`.

Clone the git repo:
```bash
$ git clone https://github.com/ledgerhq/nanos-secure-sdk.git
```

If your device is running firmware v1.6.0 checkout the `nanos-1612` branch:
```bash
$ git checkout nanos-1612
```

If your device is running firmware v1.5.5 checkout the `nanos-1553` branch:
```bash
$ git checkout nanos-1553
```

Set the `BOLOS_SDK` environment variable to the absolute path
  of the SDK repo:
```bash
$ cd nanos-secure-sdk
$ export BOLOS_SDK=`pwd`
$ cd ..
```

#### Install Python Loader for Ledger Nano S
Now, you will need to install the Python [loader tool][loader]. This process
will involve: navigating back to the root of the `ledger-tools` directory,
creating and activating a Python virtual environment, and installing the
`ledgerblue` loader tools.

Run:
```bash
$ virtualenv ledger
$ source ledger/bin/activate
$ pip install ledgerblue
$ pip install Pillow
```

#### Install `ledger-app-hns`
We are ready to install the application! This process will involve: cloning
the git repo into the `ledger-tools` directory, checking out the branch that
corresponds to your device's firmware version, compiling the application, and
loading it onto your device. The last two steps are triggered by one
`make` command.

Clone the git repo:
```bash
$ git clone https://github.com/handshake-org/ledger-app-hns.git
$ cd ledger-app-hns
```

- Start Docker.
- Connect the Ledger Nano S to your machine via USB.
- Unlock the device.
- Navigate to the device's main menu.

If your device is running firmware v1.6.0, run:
```bash
$ make docker-load
```

If your device is running firmware v1.5.5, run:
```bash
$ GIT_REF="nanos-1553" make docker-load
```

- Follow the terminal and on-device instructions (this process takes a while).

[sdk]: https://github.com/ledgerhq/nanos-secure-sdk
[loader]: https://github.com/ledgerhq/blue-loader-python
[firmware]: https://support.ledger.com/hc/en-us/articles/360002997193-Check-the-firmware-version

<br/>

## Build Apps Only (for emulator)

To build both Nano S and Nano X apps using Docker:

```bash
$ make docker-build-all
```

This will run the build in a docker container and copy the final builds to
`/bin/hns-nanos.elf` and `/bin/hns-nanox.elf`

These two binaries can be executed inside the
[Speculos emulator](https://github.com/LedgerHQ/speculos).
For example, to run the built Nano S app in the emulator from docker:

```
docker run -v \
  /path/to/ledger-app-hns/bin:/speculos/apps \
  --publish 5900:5900 \
  -it \
  ledgerhq/speculos \
  --display headless \
  --vnc-port 5900 \
  --vnc-password=xyz \
  apps/hns-nanos.elf \
  --model nanos
```

The command is explained in detail in the Speculos docs. Just note the path
to the `/bin` directory and `model` argument. The emulated device can be
accessed using a VNC client. On OSX, the `--vnc-password` argument is required
and will be requested by the VNC client.

## Tests

A suite of tests have been added to the [client library][tests]. They include
device tests with mocked transaction data, and end-to-end tests involving an
active, `hsd` node. All tests require a Ledger Nano S configured with the
following test seed:

```
abandon abandon abandon abandon abandon abandon
abandon abandon abandon abandon abandon about
```

[tests]: https://github.com/handshake-org/hsd-ledger#end-to-end-tests
## Contribution and License Agreement

If you contribute code to this project, you are implicitly allowing your code
to be distributed under the MIT license. You are also implicitly verifying that
all code is your original work. `</legalese>`

<br/>

## License

- Copyright (c) 2018, Boyma Fahnbulleh (MIT License).

Parts of this software are based on [ledger-app-btc][btc],
[blue-app-nano][nano], [nanos-app-sia][sia], [hnsd][hnsd],
and [ledger-app-eth-dockerized][docker].

### ledger-app-btc

- Copyright (c) 2016, Ledger (Apache License).

### blue-app-nano

- Copyright (c) 2018, Mart Roosmaa (Apache License).

### nanos-app-sia

- Copyright (c) 2018, Nebulous Inc. (MIT License).

### hnsd

- Copyright (c) 2018, Christopher Jeffrey (MIT License).

### ledger-app-eth-dockerized

- No License

See LICENSE for more info.

[hsd-ledger]: https://github.com/handshake-org/hsd-ledger
[ledger]: https://developers.ledger.com/
[apdu]: https://en.wikipedia.org/wiki/Smart_card_application_protocol_data_unit
[sia]: https://gitlab.com/nebulouslabs/nanos-app-sia
[btc]: https://github.com/ledgerhq/ledger-app-btc
[nano]: https://github.com/roosmaa/blue-app-nano
[hnsd]: https://github.com/handshake-org/hnsd
[docker]: https://github.com/mkrufky/ledger-app-eth-dockerized
