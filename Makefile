include ./mk/modules/version-standalone.mk \
		./mk/modules/splash.mk \
		./mk/modules/gh-release.mk \
		./mk/modules/changelog-git-diff.mk \
		./mk/main.mk 

APP_NAME = awsome-makefile-framework
VERSION_MAJOR = 0
VERSION_MINOR = 1
VERSION_PATCH = 1
VERSION_PRE_ID = 
VERSION_PRE_NB = 0

_TITLE := \
H4sIAHJYqF4AA3WQSQ7AIAhF956CuOnGhC3H8ABNHO5/iH4Uh6b2G8wTQRARVS1EJF90IjiRl6q+L9p9kDicb8R9g\
SRe6jzhScmkbBXyKjuxwYheScOwsWWX1dTCnt7iKHMygN3KnFwfQvRzHoazCUYUTN/gsazu+WObUCQgub+w2a8eCS\
Z3B6kBAAA=

DIST_FOLDER = ./dist
PRE_RELEASE_FILES_MODIFICATION= ./README.md ./templates/installer ./mk/vars.mk

# PUBLIC TASKS
###############

PHONY += release
ifeq ($(HELP),true)
release: .init       ##@Publishing Create the release package
	@echo "Usage: make release"
	@echo
	@echo "The $(_BOLD)release$(_END) rule create the final package of the release."
	@echo
	@echo "${_WHITE}Mandatories:${_END}"
	$(call _PRINT_OPTION,GH_USER,,Github User)
	$(call _PRINT_OPTION,GH_TOKEN_FILE,,File path to Github token file)
	@echo
	@echo "${_WHITE}Options:${_END}"
	$(call _PRINT_OPTION,GH_DRAFT,$(GH_DRAFT),Set the release as draft)
	@echo
	@echo "${_WHITE}Example:${_END}"
	@echo "  make release GH_USER=... GH_TOKEN_FILE=..."
	@echo "  make release GH_USER=... GH_TOKEN_FILE=... GH_DRAFT=true"
	@echo 
else
release: .init
	$(call _PRINT_CMD,Create the release package)
	$(call _release_package)
	@echo
endif

# PRIVATE TASKS
################
GIT_POST_BUMP_HOOK += _release_package
define _release_package
	$(call _PRINT_TASK,Generate final folder for release)
	$(call _PRINT_SUBTASK,Create folder)
	@mkdir -p $(DIST_FOLDER)/$(APP_NAME)-v$(VERSION)
	$(call _PRINT_SUBTASK,Copy sources)
	@cp -R ./mk $(DIST_FOLDER)/$(APP_NAME)-v$(VERSION)/mk
	$(call _PRINT_TASK,Clean package)
	@rm -rf $(DIST_FOLDER)/$(APP_NAME)-v$(VERSION)/mk/**/*.bak 
	@rm -rf $(DIST_FOLDER)/$(APP_NAME)-v$(VERSION)/mk/.cache/*
	$(call _PRINT_TASK,Compress release)
	@cd $(DIST_FOLDER)/$(APP_NAME)-v$(VERSION) && tar -czf ../$(APP_NAME)-v$(VERSION).tar.gz . 
	$(call _PRINT_TASK,Clean '$(DIST_FOLDER)' folder)
	@rm -rf $(DIST_FOLDER)/$(APP_NAME)-v$(VERSION)
	@echo "$(_BOLD)$(_YELLOW)Release file '$(DIST_FOLDER)/$(APP_NAME)-v$(VERSION).tar.gz' is ready.$(_END)"
endef

GIT_PRE_BUMP_HOOK += _pre_bump
define _pre_bump
	$(call _PRINT_TASK,Replace version information $(1) to $(2))
	$(foreach file,$(PRE_RELEASE_FILES_MODIFICATION),$(call _replace_in_file,$(1),$(2),$(file))${\n})
endef

GIT_POST_RELEASE_HOOK += _post_release
define _post_release
	@$(MAKE) gh-release \
		GH_USER=$(GH_USER) \
		GH_TOKEN_FILE=$(GH_TOKEN_FILE) \
		GH_DRAFT=$(GH_DRAFT) \
		GH_ASSETS="./dist/awsome-makefile-framework-v$(1).tar.gz ./templates/installer"
endef

define _replace_in_file
	$(call _PRINT_SUBTASK,Modify $(3))
	@sed -i.bak -E 's@$(1)@$(2)@g' "$(3)"
endef



