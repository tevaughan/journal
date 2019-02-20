
DEPLOY := /var/www/catholicscience.org/html

html/%.html: wiki-src/%.md
	mkdir -p `dirname $@`
	pandoc --ascii --mathml -f markdown -t html5 -o tmp.html $<
	cat tmp.html | sed -r 's/([a-zA-Z_-]*)\.md/\1.html/' > $@
	rm tmp.html

MDI := $(shell find wiki-src -name '*.md')
HTO := $(shell echo $(MDI) | sed 's,wiki-src,html,g' | sed 's,\.md,.html,g')

.PHONY: all clean deploy

all: $(HTO)

clean:
	@rm -frv html

deploy: all
	@rm -frv $(DEPLOY)/*
	@cp -av html/* $(DEPLOY)
