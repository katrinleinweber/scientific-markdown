clean:
	latexmk -C

all:
	report
	presentation
	thesis

presentation:
	scholdoc \
		--slide-level 2 \
		--from markdown+yaml_metadata_block+table_captions \
		--to beamer \
		--include-in-header presentation-header.tex \
		--listings \
    --highlight-style espresso \
		--include-before-body presentation-toc.tex \
		--bibliography bibliography.bibtex \
		--csl citation.csl \
		--output presentation.tex \
		presentation*.md
	latexmk -pdflatex="pdflatex --shell-escape %O %S" -pdf presentation.tex

report:
	scholdoc \
		--from markdown+yaml_metadata_block+table_captions \
		--to latex \
		--variable documentclass=article \
    --variable classoption=twocolumn \
    --variable classoption=12pt \
		--number-sections \
		--include-in-header report-header.tex \
		--include-after-body report-footer.tex \
		--listings \
		--bibliography bibliography.bibtex \
		--csl citation.csl \
		--output report.tex \
		--standalone \
		report*.md
	latexmk -pdflatex="pdflatex --shell-escape %O %S" -pdf report.tex


		#--variable theme=Minimal \

thesis:

        # [x] Mac & Win-compatible .bib copy of Zotero's auto-export
    
        if [ -a 'B:\Zotero\thesis.bib' ] ; \
		then \
			cp 'B:\Zotero\thesis.bib' 'C:\Users\path\to\thesis\references.bib' ; \
		elseif [ -a thesis.bib ] ; \
			cp thesis.bib references.bib ; \
	fi; # learned from http://stackoverflow.com/a/5553659

	# [ ] split into PDF & print with --variable ...color=black \ see http://pandoc.org/README.html#templates
	# [ ] try natbib again, if custom styling possible as with CSL (fewer authors, last names only, short doi + URL), maybe via --variable biblio-style= \
	# [ ] ask supervisor about list of figures & tables: --variable lof=true \ --variable lot=true \
	# [ ] split pandoc captions into short & long

	pandoc \
		--from markdown+table_captions \
		--to latex \
		--variable documentclass=book \
		--include-in-header header.tex \
		--include-after-body footer.tex \
		--bibliography references.bib \
		--csl references.csl \
		--variable citecolor=blue \
		--variable linkcolor=blue \
		--output thesis.tex \
		--standalone \
		--toc \
		--toc-depth=3 \
		core-*.md
	latexmk -pdflatex="pdflatex --shell-escape %O %S" -pdf thesis.tex
	
	# because similar commands for test-*.md are also present, resulting in thesis-test.pdf
	cp thesis.pdf thesis-core.pdf
