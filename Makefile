.PHONY: test
test:
	nvim --headless --noplugin -u script/minimal_init.vim -c "PlenaryBustedDirectory test/unit { minimal_init = './script/minimal_init.vim' }"

.PHONY: lint
lint:
	luacheck lua/
