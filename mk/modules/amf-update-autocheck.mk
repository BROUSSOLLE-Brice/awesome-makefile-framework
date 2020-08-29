# AMF UPDATE AUTOCHECK MODULE
###############################
# This module, when it's activated, automaticaly check if a new version of BBR-AMF
# is ready to be updated. 
# This module check version on every commands.

AMF_VERSION_CHECK_UPDT := true

ifeq ($(AMF_VERSION_CHECK_UPDT),true)
INIT += _AMF_CHECK_UPDATE
endif