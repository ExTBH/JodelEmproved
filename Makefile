TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Jodel


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JodelEMPROVED

JodelEMPROVED_FILES = $(shell find Hooks/ -type f -iname "*.m")
JodelEMPROVED_CFLAGS = -fobjc-arc
JodelEMPROVED_CFLAGS += -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"'

include $(THEOS_MAKE_PATH)/tweak.mk
