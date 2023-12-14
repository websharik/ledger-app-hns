ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif

include $(BOLOS_SDK)/Makefile.defines

#
# Version
#

MAJOR = 1
MINOR = 0
PATCH = 4

#
# App
#

APPNAME = "Handshake"
ICONNAME = nanos_icon_hns.gif
APPVERSION = $(MAJOR).$(MINOR).$(PATCH)

APP_LOAD_PARAMS = --appFlags 0xa50 --path "" --curve secp256k1 \
                  $(COMMON_LOAD_PARAMS)
APP_SOURCE_PATH = src vendor/bech32 vendor/base58
SDK_SOURCE_PATH = lib_stusb lib_stusb_impl lib_u2f qrcode

ifeq ($(TARGET_NAME),TARGET_NANOX)
SDK_SOURCE_PATH += lib_blewbxx lib_blewbxx_impl lib_ux
ICONNAME = nanox_icon_hns.gif
endif

# Ledger maintainers put these here.
# APP_LOAD_PARAMS += --tlvraw 9F:01
# DEFINES += HAVE_PENDING_REVIEW_SCREEN

#
# Platform
#

DEFINES += OS_IO_SEPROXYHAL IO_SEPROXYHAL_BUFFER_SIZE_B=300
DEFINES += HAVE_BAGL HAVE_SPRINTF HAVE_SNPRINTF_FORMAT_U
DEFINES += HAVE_IO_USB HAVE_L4_USBLIB IO_USB_MAX_ENDPOINTS=4
DEFINES += IO_HID_EP_LENGTH=64 HAVE_USB_APDU
DEFINES += TCS_LOADER_PATCH_VERSION=0
DEFINES += HNS_APP_MAJOR_VERSION=$(MAJOR)
DEFINES += HNS_APP_MINOR_VERSION=$(MINOR)
DEFINES += HNS_APP_PATCH_VERSION=$(PATCH)
DEFINES += UNUSED\(x\)=\(void\)x
DEFINES += APPVERSION=\"$(APPVERSION)\"
DEFINES += BLAKE_SDK

# U2F
DEFINES += HAVE_U2F HAVE_IO_U2F
DEFINES += U2F_PROXY_MAGIC=\"HNS\"
DEFINES += USB_SEGMENT_SIZE=64
DEFINES += BLE_SEGMENT_SIZE=32

# WebUSB
DEFINES += HAVE_WEBUSB WEBUSB_URL_SIZE_B=0 WEBUSB_URL=""

ifeq ($(TARGET_NAME),TARGET_NANOX)
DEFINES += HAVE_BLE BLE_COMMAND_TIMEOUT_MS=2000
DEFINES += HAVE_BLE_APDU
DEFINES += HAVE_UX_FLOW

DEFINES += HAVE_GLO096
DEFINES += HAVE_BAGL BAGL_WIDTH=128 BAGL_HEIGHT=64
DEFINES += HAVE_BAGL_ELLIPSIS
DEFINES += HAVE_BAGL_FONT_OPEN_SANS_REGULAR_11PX
DEFINES += HAVE_BAGL_FONT_OPEN_SANS_EXTRABOLD_11PX
DEFINES += HAVE_BAGL_FONT_OPEN_SANS_LIGHT_16PX
endif

#
# Detect Flow Support for Nano S
# (currently disabled due to memory consumption)
#

#ifneq ($(TARGET_NAME),TARGET_NANOX)
#ifneq ("$(wildcard $(BOLOS_SDK)/lib_ux/include/ux_flow_engine.h)","")
#DEFINES += HAVE_UX_FLOW
#SDK_SOURCE_PATH += lib_ux
#endif
#endif

#
# Debugging
#

DEBUG := 0
ifneq ($(DEBUG),0)
ifeq ($(TARGET_NAME),TARGET_NANOX)
DEFINES += HAVE_PRINTF PRINTF=mcu_usb_printf
else
DEFINES += HAVE_PRINTF PRINTF=screen_printf
endif
else
DEFINES += PRINTF\(...\)=
endif

#
# Compiler
#

ifneq ($(BOLOS_ENV),)
CLANGPATH := $(BOLOS_ENV)/clang-arm-fropi/bin/
GCCPATH := $(BOLOS_ENV)/gcc-arm-none-eabi-5_3-2016q1/bin/
endif

CC := $(CLANGPATH)clang
AS := $(GCCPATH)arm-none-eabi-gcc
LD := $(GCCPATH)arm-none-eabi-gcc

CFLAGS += -O3 -Os
CFLAGS += -Wno-typedef-redefinition
CFLAGS += -Wno-incompatible-pointer-types-discards-qualifiers
CFLAGS += -I/usr/include/
LDFLAGS += -O3 -Os
LDLIBS += -lm -lgcc -lc

#
# Rules
#

all: default

include $(BOLOS_SDK)/Makefile.glyphs

load: all
	python3 -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

delete:
	python3 -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)

include $(BOLOS_SDK)/Makefile.rules

dep/%.d: %.c Makefile

listvariants:
	@echo VARIANTS COIN hns

.PHONY: all load delete listvariants
