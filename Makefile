test:
	script/test.sh "$(FILE)"

lint:
	luacheck .

format:
	stylua . $(args)

.PHONY: test lint format
