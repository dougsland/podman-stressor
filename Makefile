# Define the directories for installation
PREFIX ?= /usr/
BINDIR = $(PREFIX)/bin/
SHAREDIR = $(PREFIX)/share/podman-stressor
SHAREDIR_DOC = $(PREFIX)/share/doc/podman-stressor

# Define the list of scripts and files
SCRIPTS = cgroup \
	memory \
	podman \
	network \
	podman-operations \
	processes \
	volume \
	stress \
	systemd \
	system \
	date \
	selinux \
	constants

BIN_FILE = podman-stressor

DOCS = README.md LICENSE SECURITY.md NOTICE

# Default target
all:
	@echo "Available targets: install, uninstall"

# Install target
install:
	@install -d $(DESTDIR)$(SHAREDIR)
	@install -d $(DESTDIR)$(SHAREDIR_DOC)
	@install -d $(DESTDIR)$(BINDIR)
	@for script in $(SCRIPTS); do \
		install -m 755 $$script $(DESTDIR)$(SHAREDIR); \
	done
	@for doc in $(DOCS); do \
		install -m 644 $$doc $(DESTDIR)$(SHAREDIR_DOC); \
	done
	@install -m 755 $(BIN_FILE) $(DESTDIR)$(BINDIR);
	@echo "Installation complete."

# Uninstall target
uninstall:
	@for script in $(SCRIPTS); do \
		rm -f $(DESTDIR)$(SHAREDIR)/$$script; \
	done
	rm -rf $(DESTDIR)$(SHAREDIR)
	rm -rf $(DESTDIR)$(SHAREDIR_DOC)
	rm -f $(DESTDIR)$(BINDIR)/podman-stressor
	@echo "Uninstallation complete."

.PHONY: all install uninstall
