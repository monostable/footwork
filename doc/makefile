all: dataflow.svg phases.svg

%.svg: %.dot
	dot -Tsvg $< > $@

.PHONY: all clean
