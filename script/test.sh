#!/usr/bin/env sh

if [ -z "$1" ]; then
  nvim --headless --noplugin -u test/minimal-init.lua -c "PlenaryBustedDirectory test/unit { minimal_init = 'test/minimal-init.lua' }"
  nvim --headless --noplugin -u test/minimal-init.lua -c "PlenaryBustedDirectory test/integration { minimal_init = 'test/minimal-init.lua' }"
else
  nvim --headless --noplugin -u test/minimal-init.lua -c "lua require('plenary.busted').run('$1')"
fi
