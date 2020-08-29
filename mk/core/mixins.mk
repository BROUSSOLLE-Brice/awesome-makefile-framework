# MIXINS
#########
# Group of global functions.

# Labeling
LB_MIXINS_CHECK_IS_MISSING := %s is missing.
LB_MIXINS_ERROR_ROOT_USER := This command must be runned as root user or with sudo command.

# Register current shell user
_CURRENT_USER := $(shell whoami)

# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
	$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
	$(if $(value $1),, \
		$(call _PRINT_ERROR,$(shell printf "$(LB_MIXINS_CHECK_IS_MISSING)" "$1" )$(if $2, ($2)).))

# Repeat a character depending of word length
repeat_word_length = \
	$(shell perl -E "print '$(1)' \
		x $(shell echo "$(2)" | awk '{print length}')")

# https://stackoverflow.com/questions/16144115/makefile-remove-duplicate-words-without-sorting
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

# Check if current user is root
.as-root:
ifneq ($(_CURRENT_USER), root)
	$(call _PRINT_ERROR,$(LB_MIXINS_ERROR_ROOT_USER))
endif 

# Promt a "Yes/No" question
.prompt-yesno:
	@echo "$(_YELLOW)$(MSG)? [y/n]:$(_END)"
	@read -rs -n 1 yn && [[ -z $$yn ]] || [[ $$yn == [yY] ]] && echo Y >&2 || (echo N >&2 && exit 1)
