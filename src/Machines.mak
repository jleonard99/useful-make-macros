# Provide machine specific customizations

ifeq ($(COMPUTERNAME),JL66-VMDSK3)


endif 

ifeq ($(COMPUTERNAME),RIPSAW)
#  R_VERSION = 2.11.1
#  R_HOME = C:/Program Files/R/R-$(R_VERSION)-x64
#  R = $(R_HOME)/bin/R.exe
#  R_SWEAVE = $(R_HOME)/share/texmf

#  PDFTEX_HOME = C:/Program Files (x86)/MiKTeX 2.8
#  PDFTEX = $(PDFTEX_HOME)/miktex/bin/pdflatex.exe
#  PDFTEX_VERSION = 2.8.0
  
#  PDF_READER = cmd /c start "C:\Program Files (x86)\Adobe/Reader 9.0/Reader/AcroRd32.exe"
  
#  NULL = /dev/null
#  DEL = rm
#  RD = rd /S /Q
#  REM = REM
endif 

ifeq ($(COMPUTERNAME),MA128-JL66-02)
  NULL = /dev/null
  DEL = rm
  RD = rd /S /Q
  REM = REM

  configfile    = ./Makefile.cfg
  build_time    = $(shell perl -e "use DateTime; print DateTime->now();")
  build_version = $(shell svnversion)
  build_folder  = $(CURDIR)

  R_VERSION = 2.11.1
  R_HOME = C:/Program Files/R/R-$(R_VERSION)
  R = $(R_HOME)/bin/R.exe
  R_SWEAVE = $(R_HOME)/share/texmf
 
## NOTE - sh.exe doesn't like "(" or ")" in executable file names!!!
## Put the folder on the path and call directly.  See PDFTEX below.

  PDFTEX_HOME = "C:/Program Files (x86)/MiKTeX 2.8"
  PDFTEX = pdflatex.exe
  PDFTEX_VERSION = 2.8.0
  PDFTEX_READER = cmd /c start

endif 

ifeq ($(COMPUTERNAME), seb319-lg101-a1)
  R_VERSION = 2.12.1
  R_HOME = R64
  R = R64

  PDFTEX_HOME = /usr/texbin
  PDFTEX = $(PDFTEX_HOME)/pdflatex
  PDFTEX_VERSION = 3.1415926-1.40.11-2.2
endif

ifeq ($(COMPUTERNAME), seb319-lg101-a1)
  R_VERSION = 2.12.1
  R_HOME = R
  R = R

  PDFTEX_HOME = /usr/texbin
  PDFTEX = $(PDFTEX_HOME)/pdflatex
  PDFTEX_VERSION = 3.1415926-1.40.11-2.2
endif


ifeq ($(COMPUTERNAME),JL66-LP510)

## R_VERSION is set in SETRTOOLS.BAT
## R_VERSION = 2.13.1

  R_HOME = C:/Program Files/R/R-$(R_VERSION)
  R = R
  R_SWEAVE = $(R_HOME)/share/texmf/tex/latex
 
## NOTE - sh.exe doesn't like "(" or ")" in executable file names!!!
## Put the folder on the path and call directly.  See PDFTEX below.

  PDFTEX_HOME = "C:/Program Files/MiKTeX 2.9"
  PDFTEX = pdflatex.exe
  PDFTEX_VERSION = 2.9.0
  PDFTEX_READER = cmd.exe /c start 

endif 
