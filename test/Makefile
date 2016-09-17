.SILENT:
-include Menus.mak         # include local menus if they exist
# --
include ../src/Menus.mak     # common menus
include ../src/Makefile.mak  # common makefile settings for the IRPFACTS environment
include ../src/Macros.mak    # common additional macros for the IRPFACTS environment
include ../src/Machines.mak  # machine specific overrides
include ../src/Recipes.mak   # machine specific overrides
#include useful-gatech-macros/gatech.mak      # georgia tech macros
include ../gmsl/gmsl         # GNU makefile standard library
include ../src/Time.mak      # time management macros
# --
-include Recipes.mak      # local recipes

clean:
	@echo + Cleaning 
	@-$(DEL) *.aux *.snm *.lot *.log *.toc *.eps *.out *.nav Rplots.pdf 2>$(NULL)
	
realclean: clean
	@echo + Really cleaning
	@-$(DEL) *.tex *.pdf *.R 2>$(NULL)
	@-rm -fR figure
	
baremetal: realclean
	@echo + Cleaning to bare metal

	
all: start # add additional targets here!
	@echo -------------------------------------------
	@echo Done with target ALL!

start:
	@echo Building target ALL ...
	@echo -------------------------------------------

molten-utils.R : ../R/molten-utils.rnw ; $(recipe-rnw-to-r)
report-utils.R : ../R/report-utils.rnw ; $(recipe-rnw-to-r)
tile-utils.R   : ../R/tile-utils.rnw   ; $(recipe-rnw-to-r)

test01.tex : test01.rnw molten-utils.R report-utils.R tile-utils.R ; $(recipe-rnw-to-tex)
test01.pdf : test01.tex ; $(recipe-tex-to-pdf)