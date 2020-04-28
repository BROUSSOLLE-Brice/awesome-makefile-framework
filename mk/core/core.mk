# CORE
#######

# New line hack for makefile function 'foreach'
# Answer from "bobbogo"
# https://stackoverflow.com/a/12529036
define \n


endef

# Init rule must be included on all public rules.
# To append your function to the init phase use "INIT += FUNC_NAME".
# To append your dependencies use "DEPS += dep_name".
.init:
	$(foreach dep,$(DEPS),$(if $(shell which $(dep)),, $(call _PRINT_ERROR,Dependenci '$(dep)' is missing.) ))
	$(foreach fn,$(INIT),$(call $(fn)))

PHONY += make-dep
amf-deps: .init 	
	$(call _PRINT_CMD, List of BBR-AMF dependecies)
	$(foreach dep,$(DEPS),$(call _PRINT_DEP,$(dep))${\n})

# Print dependency line for \n function hack for foreach makefile function
define _PRINT_DEP
	@echo " - $(1)"
endef

# To append a rule into .PHONY rule, append like "PHONY += rule_name"
.PHONY: $(PHONY)