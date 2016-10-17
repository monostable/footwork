all: dataflow.svg

%.svg: %.dot
	dot -Tsvg $< > $@

.PHONY: all clean
