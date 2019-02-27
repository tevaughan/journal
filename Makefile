
DEPLOY := /var/www/catholicscience.org/html

# Copy into html tree each non-'.md' file from wiki-src tree.
html/%: wiki-src/%
	@mkdir -p `dirname $@`
	@skip=false;\
	 for i in '\.swp$$' '\.o$$'; do\
	   if echo $< | grep "$$i" > /dev/null; then\
	     echo "skipping '$<'";\
	     skip=true;\
	     break;\
	   fi;\
	 done;\
	 if test "x$$skip" = "xfalse"; then\
	   cp -av $< $@;\
	 fi

# Generate under html tree each '.html' from corresponding '.md'.
html/%.html: wiki-src/%.md
	@mkdir -p `dirname $@`
	@#
	@# First, change each link to a file with '.md' as the extension so
	@# that the link is to the corresponding file but with '.html' as the
	@# extension.
	@#
	@# Second, change each link to a file with no extension so that the
	@# link is to the corresponding file but with '.html' as the extension.
	@sed -E 's/\[([^[]+)\]\((.+)\.md\)/[\1](\2.html)/g' $< | \
	 sed -E 's/\[([^[]+)\]\(([^.]+)\)/[\1](\2.html)/g'       \
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

