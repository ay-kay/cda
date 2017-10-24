TARGET = iphone::9.0:9.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = cda
cda_FILES = main.mm
cda_PRIVATE_FRAMEWORKS = MobileCoreServices

include $(THEOS_MAKE_PATH)/tool.mk
