# STANDARD VARS
################

# For debugging purpose
DEBUG       ?= false
SHELL_DEBUG := $(if $(filter $(DEBUG), false), > /dev/null 2>&1)

# For make function 'call' compatibility for huge text. The best practice is to create
# another variable.
COMMA = ,
