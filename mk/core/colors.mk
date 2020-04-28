# COLORS
#########
# List all variables to manage colors and typo on the terminal.

DEPS += tput

# Typo
_END   := $(shell tput sgr0)
_BOLD  := $(shell tput bold)
_UNDER := $(shell tput smul)
_REV   := $(shell tput rev)

# Colors
_GREY   := $(shell tput setaf 0)
_RED    := $(shell tput setaf 1)
_GREEN  := $(shell tput setaf 2)
_YELLOW := $(shell tput setaf 3)
_BLUE   := $(shell tput setaf 4)
_PURPLE := $(shell tput setaf 5)
_CYAN   := $(shell tput setaf 6)
_WHITE  := $(shell tput setaf 7)

# Inverted, i.e. colored backgrounds
_IGREY   := $(shell tput setab 0)
_IRED    := $(shell tput setab 1)
_IGREEN  := $(shell tput setab 2)
_IYELLOW := $(shell tput setab 3)
_IBLUE   := $(shell tput setab 4)
_IPURPLE := $(shell tput setab 5)
_ICYAN   := $(shell tput setab 6)
_IWHITE  := $(shell tput setab 7)