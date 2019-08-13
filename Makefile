OUTPUT ?= pdf
TARGET=comic-relief-proposal.md
BIBS=biblio.bib my-publications.bib

SVG=$(wildcard figs/*.svg)
SVG+=$(wildcard media/*.svg)

all: $(SVG:.svg=.pdf) $(TARGET:.md=.pdf)

%.png: %.svg
	inkscape -d 200 --export-png $(@) $(<)

$(SVG:.svg=.pdf): %.pdf: %.svg
	inkscape --export-pdf $(@) $(<)

%.pdf: %.md
	pandoc --pdf-engine=xelatex $(<) -o $(@)

bib: $(TARGET:.tex=.aux)

	biber $(TARGET:.tex=)



pandoc: $(SVG:.svg=.png) gantt.pdf
	pandoc $(TARGET) -McodeBlockCaptions=true -MfigureTitle=Figure -MtableTitle=Table -MlistingTitle=Listing -F pandoc-crossref -F pandoc-citeproc -o $(TARGET:.md=.$(OUTPUT))  $(foreach b,$(BIBS),--bibliography=$(b)) --reference-doc=eu-template-reference.docx --pdf-engine=lualatex --dpi=300 --standalone 
