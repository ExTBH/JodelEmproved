export ARCHS = arm64
TARGET := iphone:clang:14.5:14.0
INSTALL_TARGET_PROCESSES = Jodel


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JodelEmproved
JodelEmproved_FILES = Tweak.x JDEViewController.m  $(wildcard Classes/*.m)
JodelEmproved_FILES += Utils/Logging/JELog.m
JodelEmproved_CFLAGS = -fobjc-arc -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"'


include $(THEOS_MAKE_PATH)/tweak.mk
