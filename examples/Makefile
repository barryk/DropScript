##
# Makefile for DropScript examples
# Wilfredo Sanchez | wsanchez@opensource.apple.com
##

INSTALL_DIR := $(shell grep 'INSTALL_PATH = ' ../DropScript.pbproj/project.pbxproj | \
                       sed -e 's/.*INSTALL_PATH = \([^;]*\);.*/\1/' -e 's/^"\([^"]*\)"/\1/') #"
SCRIPT_DIR   = Example Scripts

SCRIPT_EXTS = *.sh

SH_SCRIPTS := $(shell ls $(SCRIPT_EXTS))
SCRIPTS     = $(SH_SCRIPTS)

DIRS = . Subversion Terminal #cvs-support

DOCS = README

.PHONY: all
all: $(SH_SCRIPTS)
	mkdir -p "$(BUILT_PRODUCTS_DIR)/$(SCRIPT_DIR)";
	for file in $(DOCS); do									\
	  install -c -m 444 "$${file}" "$(BUILT_PRODUCTS_DIR)/$(SCRIPT_DIR)";			\
	done
	for dir in $(DIRS); do									\
	  mkdir -p "$(BUILT_PRODUCTS_DIR)/$(SCRIPT_DIR)/$${dir}";				\
	  for file in $$(cd "$${dir}" && ls $(SCRIPT_EXTS)); do					\
	    install -c -m 555 "$${dir}/$${file}" "$(BUILT_PRODUCTS_DIR)/$(SCRIPT_DIR)/$${dir}";	\
	  done;											\
	done

.PHONY: clean
clean:
	rm -rf "$(BUILT_PRODUCTS_DIR)/$(SCRIPT_DIR)"

.PHONY: install
install: all
	install -d "$(DSTROOT)$(INSTALL_DIR)/$(SCRIPT_DIR)"
	cd "$(BUILT_PRODUCTS_DIR)" && pax -rw "$(SCRIPT_DIR)" "$(DSTROOT)$(INSTALL_DIR)"
