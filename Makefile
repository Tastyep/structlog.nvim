.PHONY: test
test:
	nvim --headless --noplugin -u test/minimal-init.lua -c "PlenaryBustedDirectory test/unit { minimal_init = 'test/minimal-init.lua' }"

.PHONY: lint
lint:
	luacheck .

.PHONY: format
format:
	stylua . $(args)
