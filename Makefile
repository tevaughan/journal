
DEPLOY := /var/www/catholicscience.org/html

# Copy into html tree each non-'.md' file from wiki-src tree.
html/%: wiki-src/%
	@mkdir -p `dirname $@`
	@if echo $< | grep '\.swp$$'; then\
	  echo "skipping $<";\
	else\
	  cp -av $< $@;\
	fi

# Generate under html tree each '.html' from corresponding '.md'.
html/%.html: wiki-src/%.md
	@mkdir -p `dirname $@`
	@# First, change link to md-file so that link is to corresponding
	@# html-file.  Second, change link with no extension to link with
	@# '.html' as extension.  Third, change diary-link with date-format but
	@# no extension so that link is to corresponding html-file.
	@sed 's/\.md)/.html/g' $<\
	  | sed -E 's/\[([^[]+)\]\(([^.]+)\)/[\1](\2.html)/g'\
	  | sed -E 's/([0-9]{4}-[0-9]{2}-[0-9]{2})\)/\1.html)/'\
	  > tmp.md
	@# '--ascii' makes apostrophe in markdown source render as apostrophe
	@# in html.
	@pandoc --ascii --mathml -f markdown+smart -o $@ tmp.md
	@rm tmp.md

# List of '.md' files under wiki-src tree.
WKI := $(shell find wiki-src -name '*.md')

# List of non-'.md' files under wiki-src tree.
RSI := $(shell find wiki-src \( ! -type d \) -a \( ! -name '*.md' \))

# List of '.html' files under html tree.
HTO := $(shell echo $(WKI) | sed 's,wiki-src,html,g' | sed 's,\.md,.html,g')

# List of non-'.md' files under html tree.
RSO := $(shell echo $(RSI) | sed 's,wiki-src,html,g')

.PHONY: all clean deploy
all: deploy

deploy: html
	@rm -frv $(DEPLOY)/*
	@cp -av html/* $(DEPLOY)

html: $(HTO) $(RSO)
clean: ; @rm -frv html

