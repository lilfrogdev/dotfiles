# config.nu
#
# Installed by:
# version = "0.110.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -
use std/util "path add"
path add "/opt/homebrew/opt/curl/bin"
path add "/opt/homebrew/bin"
path add "~/.cargo/bin"
path add "~/.local/bin"
path add "~/go/bin"
$env.config.buffer_editor = "vi"
$env.config.show_banner = false

#starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

#vim mode
$env.config.buffer_editor = "nvim"

# SSH into VPS
alias "ssh lfdc" = ssh -i ~/.ssh/id_ed25519 lilfrogdev@187.124.242.250

# SSH tunnel for OpenClaw dashboard (then open http://localhost:18789)
alias "ssh lfdd" = ssh -i ~/.ssh/id_ed25519 -N -L 18789:127.0.0.1:18789 lilfrogdev@187.124.242.250
