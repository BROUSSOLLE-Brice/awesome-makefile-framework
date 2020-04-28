# PRINTING MODULE
##################
#  All types of message displayed to terminal.

# Internal functions.
define _PRINT_ERROR
	@echo "${_BOLD}${_IRED} [ERROR] ${_END}"
	@echo "${_RED}$(_BOLD)$(1)$(_END)"
	@exit 2
endef

define _PRINT_SUCCESS
	@echo "${_BOLD}${_IGREEN} [SUCCESS] ${_END}"
	@echo "$(1)"
endef

define _PRINT_WARNING
	@echo "${_BOLD}${_YELLOW} [WARNING] ${_END}"
	@echo "${_YELLOW}$(1)${_END}"
endef

define _PRINT_CMD
	@echo "${_GREEN}│ $(1)"
	@echo "└─$(call repeat_word_length,─,$(1))─${_END}"
endef

define _PRINT_TASK
	@echo "$(_BOLD)∙ $(1)$(_END)"
endef

define _PRINT_SUBTASK
	@echo "   » $(1)."
endef

# Rules for external call.
_print_error:
	$(call _PRINT_ERROR,$(MSG))

_print_warning:
	$(call _PRINT_WARNING,$(MSG))

_print_success:
	$(call _PRINT_SUCCESS,$(MSG))

_print_task:
	$(call _PRINT_TASK,$(MSG))

_print_subtask:
	$(call _PRINT_SUBTASK,$(MSG))