test:
	nvim --headless --noplugin -u script/minimal_init.vim -c "PlenaryBustedDirectory lua/test/unit { minimal_init = './script/minimal_init.vim' }"

lint:
	luacheck lua/
