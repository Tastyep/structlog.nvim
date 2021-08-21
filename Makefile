test:
	@if [ "$(FILE)" == "" ]; then \
		nvim --headless --noplugin -u test/minimal-init.lua -c "PlenaryBustedDirectory test/unit { minimal_init = 'test/minimal-init.lua' }"; \
	else \
		nvim --headless --noplugin -u test/minimal-init.lua -c "lua require('plenary.busted').run('$(FILE)')"; \
	fi

lint:
	luacheck .

format:
	stylua . $(args)

.PHONY: test lint format
