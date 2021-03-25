## TEMPLATE FOR YOUR MAKEFILE APPLICATION
#########################################

## IN CASE OF "VERSION-STANDALONE" MODULE ACTIVATION
# include mk/modules/version-standalone.mk
# APP_NAME = <YOUR_APP_NAME>
# VERSION_MAJOR = 0
# VERSION_MINOR = 0
# VERSION_PATCH = 0
# VERSION_PRE_ID = 
# VERSION_PRE_NB = 0
## END "VERSION-STANDALONE" MODULE

## IN CASE OF "SPLASH" MODULE ACTIVATION
# include mk/modules/splash.mk 
# _TITLE := \
# H4sIAHJYqF4AA3WQSQ7AIAhF956CuOnGhC3H8ABNHO5/iH4Uh6b2G8wTQRARVS1EJF90IjiRl6q+L9p9kDicb8R9g\
# SRe6jzhScmkbBXyKjuxwYheScOwsWWX1dTCnt7iKHMygN3KnFwfQvRzHoazCUYUTN/gsazu+WObUCQgub+w2a8eCS\
# Z3B6kBAAA=
## END "SPLASH" MODULE

## THE MAIN INCLUDE MUST BE THE LAST INCLUDE FOR THE FRAMEWORK
include mk/main.mk

# PUBLIC TASKS
###############
PHONY += test
ifeq ($(HELP),true)
test: .init		##@MyApp Test my app
	@echo "Usage: make test MANDAT=... [options]"
	@echo
	@echo "The $(_BOLD)test$(_END) rule is an example to create a rule with help"
	@echo
	@echo "${_WHITE}Mandatories:${_END}"
	$(call _PRINT_OPTION,MANDAT,,Mandatories field 1)
	@echo
	@echo "${_WHITE}Options:${_END}"
	$(call _PRINT_OPTION,OPT,Default,Optionnal element with default value)
	@echo
	@echo "${_WHITE}Example:${_END}"
	@echo "  make gh-test MANDAT=..."
	@echo "  make gh-test MANDAT=... OPT=..."
	@echo 
else
MANDAT?=
OPT=default
test: .init		
	$(call _PRINT_CMD,Command title)
	$(call _PRINT_TASK,Task title)
	@echo 'test: $(MANDAT) $(OPT)'
endif

# PRIVATE TASKS
################
