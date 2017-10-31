default: build

build: services.json

test::
	grunt --force lint test

services.json: services.yaml
	jsotk dump -Ojson $< > $@

clean::
	git clean -df
clean-all::
	git clean -dfx
