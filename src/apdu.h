/**
 * apdu.h - header file for apdu commands
 * Copyright (c) 2018, Boyma Fahnbulleh (MIT License).
 * https://github.com/boymanjor/ledger-app-hns
 */
#ifndef _HNS_APDU_H
#define _HNS_APDU_H

#include <stdint.h>
#include "utils.h"

/**
 * Offsets used to parse APDU header.
 */

#define HNS_OFFSET_CLA 0x00
#define HNS_OFFSET_INS 0x01
#define HNS_OFFSET_P1 0x02
#define HNS_OFFSET_P2 0x03
#define HNS_OFFSET_LC 0x04
#define HNS_OFFSET_CDATA 0x05

/**
 * Standard APDU status words.
 */

#define HNS_OK 0x9000
#define HNS_INCORRECT_P1 0x6Af1
#define HNS_INCORRECT_P2 0x6Af2
#define HNS_INCORRECT_LC 0x6700
#define HNS_INCORRECT_CDATA 0x6a80
#define HNS_INS_NOT_SUPPORTED 0x6d00
#define HNS_CLA_NOT_SUPPORTED 0x6e00
#define HNS_SECURITY_CONDITION_NOT_SATISFIED 0x6982
#define HNS_CONDITIONS_OF_USE_NOT_SATISFIED 0x6985

/**
 * App specific APDU status words.
 */

#define HNS_CANNOT_INIT_BLAKE2B_CTX 0x13
#define HNS_CANNOT_ENCODE_ADDRESS 0x14
#define HNS_CANNOT_READ_BIP44_PATH 0x15
#define HNS_CANNOT_READ_TX_VERSION 0x16
#define HNS_CANNOT_READ_TX_LOCKTIME 0x17
#define HNS_CANNOT_READ_INPUTS_LEN 0x18
#define HNS_CANNOT_READ_OUTPUTS_LEN 0x19
#define HNS_CANNOT_READ_OUTPUTS_SIZE 0x1a
#define HNS_CANNOT_READ_INPUT_INDEX 0x1b
#define HNS_CANNOT_READ_SIGHASH_TYPE 0x1c
#define HNS_CANNOT_READ_SCRIPT_LEN 0x1d
#define HNS_CANNOT_PEEK_SCRIPT_LEN 0x1e
#define HNS_INCORRECT_INPUT_INDEX 0x1f
#define HNS_INCORRECT_SIGHASH_TYPE 0x20
#define HNS_INCORRECT_PARSER_STATE 0x21
#define HNS_INCORRECT_SIGNATURE_PATH 0x22
#define HNS_CANNOT_ENCODE_XPUB 0x23
#define HNS_INCORRECT_INPUTS_LEN 0x24
#define HNS_INCORRECT_ADDR_PATH 0x25
#define HNS_CACHE_WRITE_ERROR 0x26
#define HNS_CACHE_FLUSH_ERROR 0x27
#define HNS_CANNOT_UPDATE_UI 0x28

/**
 * Returns the application's version number.
 *
 * In:
 * @param p1 is first instruction param
 * @param p2 is second instruction param
 * @param len is length of the command data buffer
 *
 * Out:
 * @param in is the command data buffer
 * @param out is the output buffer
 * @param flags is bit array for apdu exchange flags
 * @return the status word
 */

volatile uint16_t
hns_apdu_get_app_version(
  uint8_t p1,
  uint8_t p2,
  uint16_t len,
  volatile uint8_t *in,
  volatile uint8_t *out,
  volatile uint8_t *flags
);

/**
 * Derives a public key, extended public key, and/or bech32 address.
 *
 * In:
 * @param p1 is first instruction param
 * @param p2 is second instruction param
 * @param len is length of the command data buffer
 *
 * Out:
 * @param in is the command data buffer
 * @param out is the output buffer
 * @param flags is bit array for apdu exchange flags
 * @return the status word
 */

volatile uint16_t
hns_apdu_get_public_key(
  uint8_t p1,
  uint8_t p2,
  uint16_t len,
  volatile uint8_t *in,
  volatile uint8_t *out,
  volatile uint8_t *flags
);

/**
 * Parses transaction details and signs transaction inputs.
 *
 * In:
 * @param p1 is first instruction param
 * @param p2 is second instruction param
 * @param len is length of the command data buffer
 *
 * Out:
 * @param in is the command data buffer
 * @param out is the output buffer
 * @param flags is bit array for apdu exchange flags
 * @return the status word
 */

volatile uint16_t
hns_apdu_get_input_signature(
  uint8_t p1,
  uint8_t p2,
  uint16_t len,
  volatile uint8_t *in,
  volatile uint8_t *out,
  volatile uint8_t *flags
);
#endif
