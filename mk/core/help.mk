# HELP
#######
# Regrouping all functions, rules and vars about help display.

DEPS += perl

# Labeling
LB_HELP_RULE            := Rule
LB_HELP_OPTIONS         := Options
LB_HELP_PRINT_HELP_RULE := Print help for a specific rule.
LB_HELP_DISPLAY_DEBUG   := Display informations for debugging purpose.
LB_HELP_DISPLAY_QUIET   := Toggle to quiet mode with less element to prompt.
LB_DEFAULT_SELECT_RULE  := Please select a rule.

# Define the default goal to the main help
.DEFAULT_GOAL := default

# Var to define if help display is requested for a rule.
HELP ?= false

# Function to generate the main help based on the makefile list and attached comments.
# Based on @HarasimowiczKamil comments.
# https://gist.github.com/prwhite/8168133#gistcomment-1727513
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "Usage: make [$(LB_HELP_RULE)] [$(LB_HELP_OPTIONS)]\n\n"; \
	for (sort keys %help) { \
	print "${_WHITE}$$_:${_END}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${_YELLOW}$$_->[0]${_END}$$sep${_GREEN}$$_->[1]${_END}\n"; \
	}; \
	print "\n"; }

HELP_AMF_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\!(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "Usage: make [$(LB_HELP_RULE)] [$(LB_HELP_OPTIONS)]\n\n"; \
	for (sort keys %help) { \
	print "${_WHITE}$$_:${_END}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${_YELLOW}$$_->[0]${_END}$$sep${_GREEN}$$_->[1]${_END}\n"; \
	}; \
	print "\n"; }

# Function to generate options to display into global and rules help display.
OPTION_FUN = \
	$$sep1 = " " x (18 - length "$(1)"); \
	$$sep2 = " " x (14 - length "$(2)"); \
	@desc = split "°", "$(3)"; \
	$$desc = join "\n".(" " x 34), @desc; \
	print "  $(_CYAN)$(1)$(_END)$$sep1$(_BOLD)$(2)$(_END)$$sep2$(_GREEN)$$desc$(_END)\n";

define _PRINT_OPTION
	@perl -e '$(OPTION_FUN)'
endef

define _OPT_DISPLAY
	@echo "$(LB_HELP_OPTIONS):"
	$(call _PRINT_OPTION,HELP,false,$(LB_HELP_PRINT_HELP_RULE))
	$(call _PRINT_OPTION,DEBUG,false,$(LB_HELP_DISPLAY_DEBUG))
	$(call _PRINT_OPTION,QUIET,false,$(LB_HELP_DISPLAY_QUIET))
	@echo 
endef

# Global help
# It generated from rules comments. For a rule to be displayed into the global help page 
# it necessary to add comment at the end of rule title line with tow hash '##' continue
# with an '@' to define a group (fully attached) and followed by the description.
PHONY += help
help: .init                ##@Xtra Display this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)
	$(call _OPT_DISPLAY)

amf: .init					##@Xtra Display specific AMF help
	@perl -e '$(HELP_AMF_FUN)' $(MAKEFILE_LIST)
	$(call _OPT_DISPLAY)

# Default rule
# It permit to display the global help page if no rules was defined.
PHONY += default
default: help
	@echo "$(_IRED)$(_WHITE)$(_BOLD) $(call repeat_word_length, ,$(LB_DEFAULT_SELECT_RULE)) $(_END)"
	@echo "$(_IRED)$(_WHITE)$(_BOLD) $(LB_DEFAULT_SELECT_RULE) $(_END)"
	@echo "$(_IRED)$(_WHITE)$(_BOLD) $(call repeat_word_length, ,$(LB_DEFAULT_SELECT_RULE)) $(_END)"
	@echo 