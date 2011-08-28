CC=gcc
EMACS=emacs
BATCH_EMACS=$(EMACS) --batch -Q -l init.el tempo.org

all: tempo.pdf

tempo.tex: tempo.org
	$(BATCH_EMACS) -f org-export-as-latex

tempo.pdf: tempo.tex
	rm -f tempo.aux 
	if pdflatex tempo.tex </dev/null; then \
		true; \
	else \
		stat=$$?; touch tempo.pdf; exit $$stat; \
	fi
	bibtex tempo
	while grep "Rerun to get" tempo.log; do \
		if pdflatex tempo.tex </dev/null; then \
			true; \
		else \
			stat=$$?; touch tempo.pdf; exit $$stat; \
		fi; \
	done

tempo.ps: tempo.pdf
	pdf2ps tempo.pdf

clean:
	rm -f *.aux *.log tempo.ps *.dvi *.blg *.bbl *.toc *.tex *~ *.out tempo.pdf *.xml *.lot tempo-blx.bib *.lof

real-clean: clean
	rm -f lkfs-features.pdf lkfs-tempo.pdf lkfs-periods.pdf