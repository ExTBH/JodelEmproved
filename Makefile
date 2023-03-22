TARGET := iphone:clang:15.5:13.0 # iOS 16 SDK Causes Crashes
INSTALL_TARGET_PROCESSES = Jodel


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JodelEMPROVED

JodelEMPROVED_FILES = $(shell find Source/ -type f \( -name "*.m" -o -name "*.swift" \))
JodelEMPROVED_CFLAGS = -fobjc-arc
JodelEMPROVED_CFLAGS += -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"'

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
