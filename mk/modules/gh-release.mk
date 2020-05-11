# GITHUB RELEASE MODULE
#######################
# Help to make an release into github project
# It could include binaries or other files.
# Based on @maketips script
# https://maketips.net/tip/363/publish-and-upload-release-to-github-with-bash-and-curl

DEPS += curl git jq

GH_API_URL = https://api.github.com/repos/
GH_UPL_URL = https://uploads.github.com/repos/
GH_TARGET  = master

GH_USER   := 
GH_ASSETS := 

GH_PROJECT ?= $(APP_NAME)
GH_DRAFT   ?= false

ifeq ($(HELP),true)
gh-release: .init
	@echo "Usage: make gh-release GH_USER=... GH_TOKEN_FILE=... [options]"
	@echo
	@echo "The $(_BOLD)gh-release$(_END) rule create a release on Github with assets."
	@echo
	@echo "${_WHITE}Mandatories:${_END}"
	$(call _PRINT_OPTION,GH_USER,,Github User)
	$(call _PRINT_OPTION,GH_TOKEN_FILE,,File path to Github token file)
	@echo
	@echo "${_WHITE}Options:${_END}"
	$(call _PRINT_OPTION,GH_PROJECT,$(GH_PROJECT),Set Github project name.)
	$(call _PRINT_OPTION,GH_ASSETS,empty,List of assets or path of asset)
	$(call _PRINT_OPTION,GH_DRAFT,$(GH_DRAFT),Set the release as draft)
	@echo
	@echo "${_WHITE}Example:${_END}"
	@echo "  make gh-release GH_USER=... GH_TOKEN_FILE=..."
	@echo "  make gh-release GH_USER=... GH_TOKEN_FILE=... GH_ASSETS=\"./file1 ./path\""
	@echo "  make gh-release GH_USER=... GH_TOKEN_FILE=... GH_DRAFT=true"
	@echo 
else
gh-release: .init
	$(call _PRINT_CMD,Make or update Github Release)
		$(call _PRINT_TASK,Check Github parameters)
## TODO

	$(call _PRINT_TASK,Check Github repository rights)
	$(eval GH_TOKEN := $(shell cat $(GH_TOKEN_FILE)))
## TODO

	$(call _PRINT_TASK,Get Github release id)
	$(eval _RELEASE_ID=$(shell $(call _CALL_GH_API,GET,tags/v$(VERSION)) | jq '.id'))
	$(if $(filter $(_RELEASE_ID), null), $(call _GH_CREATE_RELEASE))
	
	$(call _PRINT_TASK,Push assets into github)
	$(foreach file,$(GH_ASSETS), @$(call _CALL_GH_UPL,POST,$(_RELEASE_ID)/assets?name=`basename $(file)`,$(file)) > ./mk/.cache/_GH_RESPONSE${\n}) 
	$(call _PRINT_TASK,Update release)
## TODO
endif

define _GH_CREATE_RELEASE
	$(shell mkdir -p ./mk/.cache)
	$(shell echo '{"body":""}' | jq -Mrc \
		--arg tag "v$(VERSION)" \
		--arg target "master" \
		--argjson draft $(GH_DRAFT) \
		--argjson pre `if [[ -z "$(VERSION_PRE_ID)" ]] ; then echo false; else echo true; fi` \
		'.tag_name = $$tag | .name = $$tag | .target_commitish = $$target | .draft = $$draft | .prerelease = $$pre' \
		> ./mk/.cache/_GH_REQUEST 
	)
	$(eval _RELEASE_ID=$(shell $(call _CALL_GH_API,POST,,$(shell cat ./mk/.cache/_GH_REQUEST)) | jq '.id'))
endef

_CALL_GH_API = curl -s \
	$(if $(3),--data '$(3)') \
	--user "$(GH_USER):$(GH_TOKEN)" \
	-X $(1) \
	$(GH_API_URL)$(GH_USER)/$(GH_PROJECT)/releases$(if $(2),/$(2))

_CALL_GH_UPL = curl -s \
	$(if $(3),--data-binary @"$(3)") \
	--user "$(GH_USER):$(GH_TOKEN)" \
	-H "Content-Type: application/octet-stream" \
	-X $(1) \
	$(GH_UPL_URL)$(GH_USER)/$(GH_PROJECT)/releases$(if $(2),/$(2))



