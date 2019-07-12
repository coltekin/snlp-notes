MAIN=snlp-notes
TARGETS=$(MAIN).pdf #and more..
#LATEX=pdflatex -shell-escape -interaction=batchmode
#LATEX=xelatex -shell-escape #-interaction=batchmode
#LATEX=pdflatex --extra-mem-bot=10000000 -shell-escape #-interaction=batchmode
LATEX=pdflatex -shell-escape #-interaction=batchmode
SOURCES=$(MAIN).tex \
		alignment.tex\
		cf-parsing.tex\
		dependency-parsing.tex\
		finite-state.tex\
		formal-languages.tex\
		classification.tex\
		ml-eval.tex\
		sequence-learning.tex\
		information-theory.tex\
		intro.tex\
		math-overview.tex\
		ml-basics.tex\
		morphology.tex\
		neural-nets.tex\
		ngrams.tex\
		parsing.tex\
		probability-overview.tex\
		semantics.tex\
		smt.tex\
		statistical-models.tex\
		statistics.tex\
		text-classification.tex\
		text-processing.tex\
		unsupervised-nlp.tex\
		unsupervised.tex\
		deep-networks.tex\

BIBFILES=snlp.bib
FIGURES=
SUBDIRS=
BIBTEX=biber
VERSIONINFO=version.tex
STY=snlp-notes.sty

.PHONY: subdirs all


all: $(MAIN).pdf

#
# This is the partial solution for compiling individual chapters.
# It doesn't work (yet).
#
CHAPTERS= math-overview\
			probability-overview\

CHAPPDF=$(CHAPTERS:%=chapters/%.pdf)
chapters/%.pdf: %.tex
	$(LATEX) -shell-escape -jobname='$(@:%.pdf=%)' '\includeonly{$(@:chapters/%.pdf=%.tex)}\input{$(MAIN).tex}'

chapters: $(CHAPPDF)

subdirs: 
	for dir in $(SUBDIRS); do  $(MAKE) -j 2 -C $$dir;  done

$(MAIN).pdf: $(VERSIONINFO) $(STY) $(SOURCES) $(FIGURES) $(BIBFILES)
	$(LATEX) $(MAIN)
	$(BIBTEX) $(MAIN)
	test -f $(MAIN).makefile && make -j 2 -f $(MAIN).makefile || echo no $(MAIN).makefile
	$(LATEX) $(MAIN)
	$(LATEX) $(MAIN)

$(MAIN).aux:
	$(LATEX) $(MAIN)

$(VERSIONINFO): $(SOURCES) .git/COMMIT_EDITMSG
	./version-info.sh $@

view:
	okular $(MAIN).pdf >/dev/null 2>&1 &

clean:
	rm -f *~ *.aux $(MAIN).bbl $(MAIN).blg $(MAIN).log\
		$(MAIN).pdf $(MAIN).snm $(MAIN).toc $(MAIN).nav $(MAIN).out \
	 	$(MAIN).bcf   missfont.log $(MAIN).run.xml  

dist-clean:
	make clean
