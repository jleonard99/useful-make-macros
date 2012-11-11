.SILENT:
# --
# Checkout useful-make-macros using GIT
# copy this file from useful-make-macros/samples/Makefile to whereever
# --
include ../src/Menus.mak     # common menus and configuration checks
include ../src/Makefile.mak  # environment related makefile settings and macros
include ../src/Machines.mak  # contains machine specific overrides with examples
include ../src/Macros.mak    # additional macros not related to environment
include ../src/Recipes.mak   # common recipes

# the .title macros are scanned by code in Menus.mak to produce menus

clean.title = Clean temporary files
clean:
	@echo + Cleaning 
	@-$(RM) *.tex *.aux *.log *.toc *.eps *.out Rplots.pdf 2>$(NULL)
	@-$(RM) *-002.pdf 2>$(NULL)
	
realclean.title = Clean all local files except expensive data files
realclean: clean
	@echo + Really cleaning
	@-$(RM) *.pdf *.R *.RParams 2>$(NULL)
	
baremetal.title = Clean everything but the sources files
baremetal: realclean
	@echo + Cleaning to baremetal
	
example1.tex : example1.rnw example1.RParams common-utils.R ; $(recipe-rnw-to-tex)
example1.pdf : example1.tex ; $(recipe-tex-to-pdf)

x : example1.pdf
