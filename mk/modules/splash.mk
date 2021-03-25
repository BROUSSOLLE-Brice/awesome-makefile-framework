# SPLASH SCREEN MODULE
#######################
# Display a Splash screen on all public rules.
# It contains some information about the current app (name, version).

DEPS += base64 gzip

# Problem of MacOS Base64 app have a different decode parameter.
_OS_BASE64_DECODE_ARG := $(if $(filter-out darwin, $(UNAME_S)), "-D", "-d")

# Title of the splash screen
# it's gziped and base64 encoded.
# to create, create a file 'Splach', paste all you need into it and save.
# Run the command `cat Splach | gzip | base64` and set into the master makefile
# a new variable _TITLE with the result as value.
_TITLE := H4sIACXLpV4AAwvJV0hKVUhJTcvMS03h4gIA7syxMQ8AAAA=

ifeq ($(QUIET),) 
INIT += _SPLASH
define _SPLASH
	@echo
	@echo "${_TITLE}" | base64 $(_OS_BASE64_DECODE_ARG) | zcat
	@echo 
	@echo "┌──────$(call repeat_word_length,─,$(APP_NAME))──┬─────────$(call repeat_word_length,─,$(VERSION))─┐"
	@echo "│ App ${_IGREY} ${_BOLD}${_RED}${APP_NAME} ${_END} │ Version ${_BOLD}${_GREEN}${VERSION}${_END} │"
	@echo "└──────$(call repeat_word_length,─,$(APP_NAME))──┴─────────$(call repeat_word_length,─,$(VERSION))─┘"
endef
endif

feq ($(HELP),true)
splash-generator: .init  	#!@Splash Generate spash encoded 
	@echo "Usage: make splash-generator BANNER_FILE=..."
	@echo
	@echo "The $(_BOLD)splash-generator$(_END) rule generate the encoded banner."
	@echo
	@echo "${_WHITE}Mandatories:${_END}"
	$(call _PRINT_OPTION,BANNER_FILE,,File to convert)
	@echo
	@echo "${_WHITE}Example:${_END}"
	@echo "  make splash-generator BANNER_FILE=... "
	@echo 
else
BANNER_FILE?=
splash-generator: .init
	$(call _PRINT_CMD,Generate encoded banner)
	@if [ -z "$(BANNER_FILE)" ]; then make \
		_print_error MSG="BANNER_FILE '$(BANNER_FILE)' is not valid."; fi
ifneq ("$(wildcard $(BANNER_FILE))","")
	@echo
	@cat $(BANNER_FILE) | gzip | base64 
else 
	$(call _PRINT_ERROR,BANNER_FILE '$(BANNER_FILE)' not exist.)
endif
endif