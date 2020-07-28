.PHONY: resume watch clean

resume: resume.pdf index.html

watch:
	ls *.md *.css | entr make resume

name := $(shell grep "^\#" resume.md | head -1 | sed -e 's/^\#[[:space:]]*//' | xargs)
freespace_name := $(shell grep "^\#" resume.md | head -1 | sed -e 's/^\#[[:space:]]*//' | tr ' ' '_' | xargs)

index.html: preamble resume.md postamble
	cat preamble | sed -e 's/___NAME___/$(name)/' | sed -e 's/___FREESPACE_NAME___/$(freespace_name)/' > $@
	python -m markdown -x smarty resume.md >> $@
	cat postamble >> $@

resume.pdf: index.html resume.css
	weasyprint index.html "$(freespace_name)_Resume.pdf"

clean:
	rm -f index.html "$(freespace_name)_Resume.pdf"
