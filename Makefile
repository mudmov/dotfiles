# Clean build directories
clean:
	@echo "Cleaning Neovim build directory..."
	rm -rf $(NVIM_BUILD_DIR)
	@echo "Build directory cleaned."# Makefile for Neovim installation from binary and dotfiles setup

# Configuration variables
DOTFILES_DIR := $(shell pwd)  # Current directory (assuming we're in the dotfiles repo)
NVIM_CONFIG_PACKAGE := nvim-light  # The directory name in your dotfiles repo for nvim config
NVIM_BUILD_DIR := $(HOME)/nvim-build

# Common dependencies across all package managers
COMMON_DEPS := cmake unzip curl git

# Package-specific dependencies (only the differences)
ifeq ($(PKG_MANAGER),apt)
  SPECIFIC_DEPS := ninja-build gettext build-essential
else ifeq ($(PKG_MANAGER),dnf)
  SPECIFIC_DEPS := ninja-build make gcc
else ifeq ($(PKG_MANAGER),brew)
  SPECIFIC_DEPS := ninja gettext
endif

# Combine common and specific dependencies
NVIM_DEPS := $(COMMON_DEPS) $(SPECIFIC_DEPS)

# Detect if running as root
ifeq ($(shell id -u),0)
  # Running as root, don't use sudo
  SUDO :=
else
  # Not running as root, use sudo
  SUDO := sudo
endif

# Detect package manager and set install command
ifneq ($(shell command -v apt-get 2> /dev/null),)
  PKG_INSTALL := $(SUDO) apt-get update && $(SUDO) apt-get install -y
  PKG_MANAGER := apt
else ifneq ($(shell command -v dnf 2> /dev/null),)
  PKG_INSTALL := $(SUDO) dnf install -y
  PKG_MANAGER := dnf
else ifneq ($(shell command -v brew 2> /dev/null),)
  PKG_INSTALL := brew install
  PKG_MANAGER := brew
else
  $(error Could not find a supported package manager (apt, dnf, or brew))
endif

# Declare phony targets
.PHONY: all help install-stow install-nvim-deps install-nvim stow clean

# Default target
all: install-stow install-nvim stow

# Help target
help:
	@echo "Neovim Installation and Dotfiles Setup Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make              Run the complete setup (build neovim and stow configs)"
	@echo "  make install-nvim Build and install Neovim from source"
	@echo "  make install-stow Install GNU Stow package"
	@echo "  make stow         Stow your Neovim configuration"
	@echo "  make clean        Clean build directories"
	@echo "  make help         Show this help message"
	@echo ""
	@echo "Configuration:"
	@echo "  DOTFILES_DIR      = $(DOTFILES_DIR)"
	@echo "  NVIM_CONFIG_PACKAGE = $(NVIM_CONFIG_PACKAGE)"
	@echo "  NVIM_BUILD_DIR    = $(NVIM_BUILD_DIR)"
	@echo ""
	@echo "Detected package manager: $(PKG_MANAGER)"

# Install stow using package manager
install-stow:
	@echo "Installing GNU Stow..."
	$(PKG_INSTALL) stow

# Install Neovim dependencies
install-nvim-deps:
	@echo "Installing Neovim build dependencies..."
	$(PKG_INSTALL) $(NVIM_DEPS)

# Build Neovim from source
install-nvim: install-nvim-deps
	@echo "Building Neovim from source..."
	mkdir -p $(NVIM_BUILD_DIR)
	if [ -d "$(NVIM_BUILD_DIR)/neovim" ]; then \
		cd $(NVIM_BUILD_DIR)/neovim && git pull; \
	else \
		git clone https://github.com/neovim/neovim.git $(NVIM_BUILD_DIR)/neovim; \
	fi
	cd $(NVIM_BUILD_DIR)/neovim && \
	make CMAKE_BUILD_TYPE=Release && \
	$(SUDO) make install
	@echo "Neovim built and installed successfully!"
	nvim --version

# Stow Neovim configuration files
stow: install-stow
	@echo "Stowing Neovim configuration..."
	stow -v $(NVIM_CONFIG_PACKAGE)
	@echo "Neovim configuration successfully stowed!"