# UPDATES
##########
# Regroup all functions for managing updates of the core

DEPS += curl grep sed head

LB_UPDATES_NO_NEEDS := BBR-AMF already up-to-date.
LB_UPDATES_NEEDS := A new version of BBR-AMF is available.
LB_UPDATES_CMD := Launch command 'make amf-update'.
LB_UPDATES_CURRENT_VERSION := Local version
LB_UPDATES_NEXT_VERSION := Latest version
LB_UPDATES_QUESTION_READY := Are you ready to update BBR-AMF
LB_UPDATES_START := Updating AMF-BBR
LB_UPDATES_DOWNLOAD := Downloading sources

PHONY += amf-update
amf-update: .init		#!@Core Check for updates
	$(call _PRINT_CMD, Check for BBR-AMF updates)
	$(call _AMF_GET_LATEST_VERSION)
	$(if $(filter $(AMF_LATEST_VERSION), $(AMF_VERSION)),\
		$(call _AMF_NO_UPDATE_NEEDS),\
		$(call _AMF_UPDATE_TASK))

PHONY += amf-version
amf-version: .init		#!@Core Get BBR-AMF Version
	@echo $(AMF_VERSION)

define _AMF_CHECK_UPDATE
	$(call _AMF_GET_LATEST_VERSION)
	$(if $(filter-out $(AMF_LATEST_VERSION), $(AMF_VERSION)),$(call _AMF_UPDATE_NEEDS))
endef

define _AMF_GET_LATEST_VERSION
	$(if $(filter-out $(AMF_VERSION_EARLY_MODE),false),$(eval AMF_UPDATE_ENDPOINT=""),$(eval AMF_UPDATE_ENDPOINT="/latest"))
	$(eval AMF_LATEST_VERSION="$(shell curl \
		--silent "https://api.github.com/repos/$(AMF_REPOSITORY)/releases$(AMF_UPDATE_ENDPOINT)" \
		| grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1 \
	)")
endef

define _AMF_NO_UPDATE_NEEDS
	@echo "${_BOLD}${_GREEN}$(LB_UPDATES_NO_NEEDS)${_END}"
endef

define _AMF_UPDATE_NEEDS
	@echo "${_BOLD}${_YELLOW}$(LB_UPDATES_NEEDS)${_END}"
	@echo "${_YELLOW}$(LB_UPDATES_CMD)${_END}"
endef

define _AMF_UPDATE_TASK
	@echo "${_BOLD}${_YELLOW}$(LB_UPDATES_NEEDS)${_END}"
	@echo "$(LB_UPDATES_CURRENT_VERSION) : $(AMF_VERSION)"
	@echo "$(LB_UPDATES_NEXT_VERSION) : $(AMF_LATEST_VERSION)"
	@if $(MAKE) .prompt-yesno MSG="$(LB_UPDATES_QUESTION_READY)" 2> /dev/null; then \
		$(MAKE) _print_task MSG="$(LB_UPDATES_START) $(AMF_LATEST_VERSION)"; \
		$(MAKE) _print_subtask MSG="$(LB_UPDATES_DOWNLOAD)"; \
		curl -sL "https://github.com/$(AMF_REPOSITORY)/releases/download/$(AMF_LATEST_VERSION)/installer" \
		| sh; \
	fi
endef