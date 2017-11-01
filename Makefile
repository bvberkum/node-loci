default: build

build: services.json dep-g

test::
	grunt --force lint test

services.json: services.yaml
	jsotk dump -Ojson $< > $@

clean::
	git clean -df
clean-all::
	git clean -dfx


build/js/loci: ./src
	grunt coffee:lib
build/js/loci-dev:
	grunt coffee:dev
build/js/loci-test:
	grunt coffee:test


PRETTYG := ./tools/sh/prettify-madge-graph.sh

assets/%-deps.dot: build/js/% .madgerc Makefile $(PRETTYG)
	madge --include-npm --dot build/js/$* | $(PRETTYG) build/js/loci "loci" > $@

assets/%.dot: build/js/% .madgerc $(PRETTYG) Makefile
	madge --dot build/js/$* | $(PRETTYG) build/js/$* > $@

assets/%-deps.svg: assets/%-deps.dot build/js/% Makefile
	dot -Grankdir=LR -Tsvg assets/$*-deps.dot -Nshape=record > $@

assets/%.svg: assets/%.dot build/js/% Makefile
	dot -Grankdir=LR -Tsvg assets/$*.dot -Nshape=record > $@

LIB_DEP_G_DOT := \
	assets/loci.dot \
	assets/loci-deps.dot \
	assets/loci-test-deps.dot \
	assets/loci-dev-deps.dot
LIB_DEP_G_SVG := \
	assets/loci.svg \
	assets/loci-deps.svg \
	assets/loci-test-deps.svg \
	assets/loci-dev-deps.svg

dep-g-dot:: $(LIB_DEP_G_DOT)
dep-g-svg:: $(LIB_DEP_G_SVG)

dep-g:: $(LIB_DEP_G_SVG) $(LIB_DEP_G_DOT)
