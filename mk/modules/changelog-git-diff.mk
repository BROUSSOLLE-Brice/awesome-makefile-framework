# AMF CHANGELOG WITH GIT DIFF MODULE
####################################
# This module, when it's activated, add capability of modify Changelog file
# based on git commits descriptions 
#
# VERSION variable is mandatory

DEPS += awk sed git

GIT_PRE_BUMP_HOOK += _CHANGELOG_CREATE_RELEASE

CHANGELOG_URL = https://github.com/BROUSSOLLE-Brice/awsome-makefile-framework

# PHONY =+ test-changelog
# test-changelog: .init
# 	$(call _CHANGELOG_CREATE_RELEASE)

define _CHANGELOG_CREATE_RELEASE
	$(call _PRINT_TASK,Generate Changelog modification from git diff)
	$(call _CHANGELOG_LIST)
	@sed -i.bak -E "/## \[Unreleased\]/r $(PROJECT_DIR).tmp-comments.bak" $(PROJECT_DIR)CHANGELOG.md
	$(call _CHANGELOG_COMPARE)
	@sed -i.bak -E "/\[Unreleased\]:.*/r $(PROJECT_DIR).tmp-comments.bak" $(PROJECT_DIR)CHANGELOG.md
	@awk '!p{p=sub(/\[Unreleased\]:.*/,x)}1' $(PROJECT_DIR)CHANGELOG.md > $(PROJECT_DIR)CHANGELOG.md.bak
	@rm -f "$(PROJECT_DIR)CHANGELOG.md"
	@mv -f "$(PROJECT_DIR)CHANGELOG.md.bak" "$(PROJECT_DIR)CHANGELOG.md"$(\n)
endef

define _CHANGELOG_LIST
	$(eval _GIT_LAST_TAG=$(shell git describe --tags --abbrev=0))
	@echo "" > $(PROJECT_DIR).tmp-comments.bak
	@echo "### Added" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "### Changed" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "### Deprecated" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "### Removed" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "### Fixed" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "### Security" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "## [$(VERSION)] - $(shell date +'%Y-%m-%d')" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	@echo "### Commit comments"  >> $(PROJECT_DIR).tmp-comments.bak
	@echo "" >> $(PROJECT_DIR).tmp-comments.bak
	$(foreach hash,$(shell git log $(_GIT_LAST_TAG)..HEAD --pretty=format:"%H"), $(call _CHANGELOG_PRINT_COMMIT,$(hash)))
endef

define _CHANGELOG_PRINT_COMMIT
	$(eval _GIT_COMMIT_CONTENT=$(shell git log --format=%B -n 1 $(1)))
	@echo - $(subst ',\',$(subst ",\", $(_GIT_COMMIT_CONTENT))) >> $(PROJECT_DIR).tmp-comments.bak$(\n)
endef

define _CHANGELOG_COMPARE
	$(eval _GIT_LAST_TAG=$(shell git describe --tags --abbrev=0))
	@echo "[Unreleased]: $(CHANGELOG_URL)compare/v$(VERSION)...master" > $(PROJECT_DIR).tmp-comments.bak
	@echo "[$(VERSION)]: $(CHANGELOG_URL)compare/$(_GIT_LAST_TAG)...v$(VERSION)" >> $(PROJECT_DIR).tmp-comments.bak
endef