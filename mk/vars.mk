# STANDARD VARS
################

# For debugging purpose
DEBUG       ?= false
SHELL_DEBUG := $(if $(filter $(DEBUG), false), > /dev/null 2>&1)

# For prompting
QUIET?=

# New line hack for makefile function 'foreach'
# Answer from "bobbogo"
# https://stackoverflow.com/a/12529036
define \n


endef

# For make function 'call' compatibility for huge text. The best practice is to create
# another variable.
COMMA = ,

SPACE:=
SPACE+=

AMF_VERSION				      = "v0.1.1"
AMF_REPOSITORY 			    = "BROUSSOLLE-Brice/awsome-makefile-framework"
AMF_VERSION_EARLY_MODE 	= false
PROJECT_DIR             = $(dir $(abspath $(lastword $(MAKEFILE_LIST) ~ '..')))
