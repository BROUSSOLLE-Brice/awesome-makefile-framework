# VERSION TYPE STANDALONE MODULE
#################################
# This module is made for all applications who don't have integrated SemVer machanism 
# like Golang or Makefiles frameworks :D 
# This module is not a core element. To use it you must include it into the master makefile.

DEPS += git sed

# Labeling
LB_GIT_PUSH_ASK = Do you want push branch and tag
LB_GIT_SEND_REPO = Send git modification to repository
LB_GIT_SEND_COMMITS = Send commits
LB_GIT_SEND_TAGS = Send tags

BUMP_TYPE ?= patch
PRE_ID    ?= $(if $(VERSION_PRE_ID), $(VERSION_PRE_ID), alpha)

BUMP_ALLOWED_TYPES := major minor patch pre-major pre-minor pre-patch pre release
PRE_ID_ALLOWED := alpha beta rc

BT := $(filter $(BUMP_TYPE),$(BUMP_ALLOWED_TYPES))
PI := $(filter $(PRE_ID),$(PRE_ID_ALLOWED))

define CLEAN_PRE
	$(eval VERSION_PRE_ID=)
	$(eval VERSION_PRE_NB=0)
endef

define UPDATE_PRE
	$(eval VERSION_PRE_ID=$(PI))
	$(eval VERSION_PRE_NB=$(shell echo $$(($(VERSION_PRE_NB)+1))))
endef

INIT+= GET_VERSION
define GET_VERSION
	$(eval VERSION = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH))
	$(if $(filter-out ,$(VERSION_PRE_ID)),$(eval VERSION := $(VERSION)-$(VERSION_PRE_ID).$(VERSION_PRE_NB)))
endef

PHONY += version 
version: .init 				##@Xtra Display application version.
PHONY += bump 
ifeq ($(HELP),true)
bump: .init   				##@Publishing Bump application version.
	@echo "Usage: make bump BUMP_TYPE=... [PRE_ID=...]"
	@echo
	@echo "The $(_BOLD)bump$(_END) rule update the version number following the semver specification."
	@echo "It checking if git modification are not committed, generating git tag and push"
	@echo "the final vesion to your repository."
	@echo
	@echo "${_WHITE}Options:${_END}"
	$(call _PRINT_OPTION,BUMP_TYPE,patch,Bump the version of your application.\
°Available values are°$(_BOLD)$(foreach val,$(BUMP_ALLOWED_TYPES),$(val)$(comma))$(_END) )
	$(call _PRINT_OPTION,PRE_ID,rc,Set the pre-release id between version and\
°the pre-release version number.)
	@echo
	@echo "${_WHITE}Example:${_END}"
	@echo "  make bump BUMP_TYPE=prepatch PRE_ID=rc"
	@echo "  make bump BUMP_TYPE=minor"
	@echo 
else
bump: .init
	$(call _PRINT_CMD,Bump app version)
	$(call _PRINT_TASK,Check parameters)
	@if [ -z "$(BT)" ]; then make \
		_print_error MSG="BUMP_TYPE '$(BUMP_TYPE)' is not valid.\
		\nAllowed values are:\n$(BUMP_ALLOWED_TYPES)"; fi
	@if [ -z "$(PI)" ]; then make \
		_print_error MSG="PRE_ID '$(PRE_ID)' is not valid.\
		\nAllowed values are:\n$(PRE_ID_ALLOWED)"; fi
	$(call _PRINT_TASK,Check for git modifications)
	@if ! git diff-index --quiet HEAD  --; then make \
		_print_error MSG="Some modifications are not committed yet.\
		\nPlease commit changes first."; fi
	
	$(call _PRINT_TASK,Calculate new app version)
ifeq ($(BUMP_TYPE), patch)
	$(call _PRINT_SUBTASK,Patch version increment)
	$(eval VERSION_PATCH=$(shell echo $$(($(VERSION_PATCH)+1))))
	$(call CLEAN_PRE)
endif

ifeq ($(BUMP_TYPE), pre-patch)
	$(call _PRINT_SUBTASK,PRE Patch version increment)
	$(eval VERSION_PATCH=$(shell echo $$(($(VERSION_PATCH)+1))))
	$(eval VERSION_PRE_NB=0)
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), minor)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MINOR=$(shell echo $$(($(VERSION_MINOR)+1))))
	$(eval VERSION_PATCH=0)
	$(call CLEAN_PRE)
endif

ifeq ($(BUMP_TYPE), pre-minor)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MINOR=$(shell echo $$(($(VERSION_MINOR)+1))))
	$(eval VERSION_PATCH=0)
	$(eval VERSION_PRE_NB=0)
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), major)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MAJOR=$(shell echo $$(($(VERSION_MAJOR)+1))))
	$(eval VERSION_PATCH=0)
	$(eval VERSION_MINOR=0)
	$(call CLEAN_PRE)
endif

ifeq ($(BUMP_TYPE), pre-major)
	$(call _PRINT_SUBTASK,Minor version increment)
	$(eval VERSION_MAJOR=$(shell echo $$(($(VERSION_MAJOR)+1))))
	$(eval VERSION_PATCH=0)
	$(eval VERSION_MINOR=0)
	$(eval VERSION_PRE_NB=0)
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), pre)
	$(call _PRINT_SUBTASK,Pre version increment)
	$(if $(filter-out $(PI),$(VERSION_PRE_ID)),$(eval VERSION_PRE_NB := 0))
	$(call UPDATE_PRE)
endif

ifeq ($(BUMP_TYPE), release)
	$(call _PRINT_SUBTASK,Finalize the release)
	$(call CLEAN_PRE)
endif
	$(eval PREVIOUS_VERSION=$(VERSION))
	$(call GET_VERSION)
	$(call _PRINT_SUBTASK,new version is $(_BOLD)$(_GREEN)$(VERSION) $(_END))
	
	# TODO: Try to find a method to prioritize hooks
	$(foreach fn,$(GIT_PRE_RELEASE_HOOK),$(call $(fn),$(PREVIOUS_VERSION),$(VERSION)))

	$(call _PRINT_TASK,Apply new version into files)
	@sed -i.bak -E 's@^VERSION_PATCH =.+@VERSION_PATCH = $(VERSION_PATCH)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_MINOR =.+@VERSION_MINOR = $(VERSION_MINOR)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_MAJOR =.+@VERSION_MAJOR = $(VERSION_MAJOR)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_PRE_ID =.+@VERSION_PRE_ID = $(VERSION_PRE_ID)@g' ./Makefile
	@sed -i.bak -E 's@^VERSION_PRE_NB =.+@VERSION_PRE_NB = $(VERSION_PRE_NB)@g' ./Makefile

# TODO: Try to find a method to prioritize hooks
	$(foreach fn,$(GIT_PRE_BUMP_HOOK),$(call $(fn),$(PREVIOUS_VERSION),$(VERSION)))

	$(call _PRINT_TASK,Apply new version into git)
	@git add . $(SHELL_DEBUG)
	@git commit -m "v$(VERSION)" $(SHELL_DEBUG)
	@git tag v$(VERSION) $(SHELL_DEBUG)

# TODO: Try to find a method to prioritize hooks
	$(foreach fn,$(GIT_POST_BUMP_HOOK),$(call $(fn),$(VERSION)))
	
	@if $(MAKE) .prompt-yesno MSG="$(LB_GIT_PUSH_ASK)" 2> /dev/null; then \
		$(MAKE) _print_task MSG="$(LB_GIT_SEND_REPO)"; \
		$(MAKE) _print_subtask MSG="$(LB_GIT_SEND_COMMITS)"; \
		git push $(SHELL_DEBUG); \
		$(MAKE) _print_subtask MSG="$(LB_GIT_SEND_TAGS)"; \
		git push --tags $(SHELL_DEBUG); \
	fi
	
# TODO: Try to find a method to prioritize hooks
	$(foreach fn,$(GIT_POST_RELEASE_HOOK),$(call $(fn),$(VERSION)))
endif
