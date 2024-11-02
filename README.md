# ledger-app-hns

This is a key management application for the Handshake Protocol. With support
for Ledger Nano S, Nano X and Nano S+, it allows users to create extended public
keys, addresses, and signatures for valid Handshake transactions. It can be used
with the hsd-ledger client library to interact with wallet
software.

# Build and install

```bash
sudo docker build -f Dockerfile.builder -t ledger-hns-builder .

sudo docker run --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) -e MODEL=NANOSP ledger-hns-builder

sudo docker run --privileged --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) -e MODEL=NANOSP -e DEBUG=1 ledger-hns-builder make load

sudo docker run --privileged --rm -ti -v "$(realpath .):/app" --user $(id -u):$(id -g) -e MODEL=NANOSP -e DEBUG=1 ledger-hns-builder make delete

```
