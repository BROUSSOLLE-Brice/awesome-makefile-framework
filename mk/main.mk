# MAKEFILE FRAMEWORK BOOTSTRAP
###############################
# The bootstrap file must be included into the master Makefile. It could be recreated 
# to remove or include other core files. the '.init' must be copied to ansure the 
# framework stay functional.

# Include core elements
include mk/vars.mk \
		mk/core/mixins.mk \
		mk/core/colors.mk \
		mk/core/printing.mk \
		mk/core/help.mk \
		mk/core/core.mk

