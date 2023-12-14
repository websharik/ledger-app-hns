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

## Usage

See [Install](docs/install.md) for instructions on building and loading the app.

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
