test:
	script/test.sh "$(FILE)"

lint:
	luacheck .

format:
	stylua . $(args)

doc:
	ldoc .

.PHONY: test lint format doc
