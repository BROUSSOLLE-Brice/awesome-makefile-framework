# CORE
#######

# Init rule must be included on all public rules.
# To append your function to the init phase use "INIT += FUNC_NAME".
# To append your dependencies use "DEPS += dep_name".
.init:
	$(eval DEPS=$(sort $(call uniq,$(DEPS))))
	$(foreach dep,$(DEPS),$(if $(shell which $(dep)),, $(call _PRINT_ERROR,Dependenci '$(dep)' is missing.) ))
	$(foreach fn,$(INIT),$(call $(fn)))

PHONY += amf-deps
amf-deps: .init			#!@Dependencies List of dependencies
	$(call _PRINT_CMD, List of BBR-AMF dependecies)
	$(foreach dep,$(DEPS),$(call _PRINT_DEP,$(dep))${\n})

# Print dependency line for \n function hack for foreach makefile function
define _PRINT_DEP
	@echo " - $(1)"
endef

# To append a rule into .PHONY rule, append like "PHONY += rule_name"
.PHONY: $(PHONY)