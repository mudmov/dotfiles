#!/usr/bin/env bash
# Dependency manifest for tmux package

DESCRIPTION="Terminal multiplexer with TPM plugin manager"
DEPS=(tmux git)

setup() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$tpm_dir" ]; then
        log_info "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi

    if [ -x "$tpm_dir/bin/install_plugins" ]; then
        log_info "Installing tmux plugins via TPM..."
        "$tpm_dir/bin/install_plugins"
    fi
}
