#  Makefile.cfg - put customization stuff here to help keep the main Makefile clean
#
#

# Check and save the Operating System

ifeq ($(OSTYPE),)
  OSTYPE=$(OS)
endif

REPORTER = reporter.bat
##PDFTEX = pdflatex.exe --quiet --include-directory="$(R_SWEAVE)"
PDFTEX = pdflatex.exe --quiet
R = R

# Provide custom macros depending on OS type

ifeq ($(findstring Windows,$(OSTYPE)),Windows)

#  SHELLFLAGS = /c
#  SHELL=cmd
  
  SEP := \ 
  t := $(shell cd)
  CURDIR :=$(subst \,/,$(t))
  TMPDIR :=$(t)$(SEP)
  NULL = nul:
  DEL = del /A
  COPY = copy 
  RD = rd /S /Q
  REM = REM
  WHERE=where

  configfile    = ./Makefile.cfg
  build_time    = $(shell perl -e "use DateTime; print DateTime->now();")
  build_version = $(shell svnversion)
  build_folder  = $(CURDIR)
 
# if not windows, then probably linux variant.
  
else

  t := $(shell cd)
  CURDIR=  $(substr \,/,$(t))
  TMPDIR=./
  NULL = /dev/null
  DEL  = rm -f
  RD = rm -fR
  COPY = cp 
  REM = #

endif


# Customizations if RTOOLS is installed.

ifeq ($(findstring Rtools,$(PATH)),Rtools)

  SEP := /
  t := $(shell cmd.exe /c cd)
  CURDIR = $(subst \,/,$(t))
  TMPDIR = $(CURDIR)$(SEP)

  NULL = /dev/null
  DEL = rm
  RD = rd /S /Q
  COPY = cp
  REM = REM

  configfile    = ./Makefile.cfg
  build_time    = $(shell perl -e "use DateTime; print DateTime->now();")
  build_version = $(shell svnversion)
  build_folder  = $(CURDIR)

endif

environment env:
	@echo + -------------------------------------------------------------------------
	@echo +        OSTYPE: $(OSTYPE)
	@echo +         SHELL: $(SHELL)
	@echo +        Rtools: $(findstring Rtools,$(PATH))
	@echo +  COMPUTERNAME: $(COMPUTERNAME)
	@echo +        CURDIR: $(CURDIR)
	@echo +        TMPDIR: $(TMPDIR)
	@echo +          NULL: $(NULL)
	@echo +           DEL: $(DEL)
	@echo +          COPY: $(COPY)
	@echo +
	@echo + R_VERSION: $(R_VERSION)
	@echo +    R_HOME: $(R_HOME)
	@echo +        R : $(R)
	@echo +  R_SWEAVE: $(R_SWEAVE)
	@echo +
	@echo +    PDFTEX_HOME: $(PDFTEX_HOME)
	@echo +         PDFTEX: $(PDFTEX)
	@echo + PDFTEX_VERSION: $(PDFTEX_VERSION)
	@echo +  PDFTEX_READER: $(PDFTEX_READER)
	@echo +
	@echo +      REPORTER: $(REPORTER)
	@echo +
	@echo +    build_time: $(build_time)
	@echo + build_version: $(build_version)
	@echo +  build_folder: $(CURDIR)
	@echo +
	@echo + perl version: $(shell perl -V:version)
	@echo +
	@echo +        R: "$(shell $(WHERE) R)"
	@echo + pdflatex: "$(shell $(WHERE) pdflatex)"
	@echo +     make: "$(shell $(WHERE) make)"
	@echo +     grep: "$(shell $(WHERE) grep)"
