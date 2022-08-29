TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Jodel

# before-package::
# 	@cp control layout/DEBIAN/control

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JodelEmproved
JodelEmproved_FILES = Tweak.x JDEViewController.m  $(wildcard Classes/*.m)
JodelEmproved_CFLAGS = -fobjc-arc -Wno-unguarded-availability-new

include $(THEOS_MAKE_PATH)/tweak.mk
