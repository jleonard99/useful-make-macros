%.pdf : %.tex ; $(recipe-tex-to-pdf)
%.tex : %.rnw ; $(recipe-rnw-to-tex)
%.Rparams :  ; $(recipe-template-to-rparams)
%.R : %.rnw ; $(recipe-rnw-to-r)

# Handy macros for converting comma-separated lists to space-separated lists and back
# for example:
#	--xls-toc-note="Students sampled from the following terms: $(subst $(comma),$(space),$($(word 1,$(subst ., ,$(@))).terms))" \

comma := ,
empty :=
space := $(empty) $(empty)
quote := ''

# new line macro.  Used like $(\n) and drops a new line into the recipe
# cool for using $(foreach) to generate arguments like:
#
# $(foreach period,$(payroll.periods),--fiscal-period-14360=$(period) \$(\n) ) \

define \n


endef


define recipe-template-shared
	--wrap-before="# [useful] AUTOGENERATED FILE.  See recipe-template-shared" \
	--wrap-before="params = list()" \
	--wrap-before="params[['build_file']] = '$(@)'" \
	--wrap-before="params[['build_time']]     = '$(build_time)'" \
	--wrap-before="params[['build_version']]  = '$(build_version)'" \
	--wrap-before="params[['build_folder']]   = '$(build_folder)'" \
	--wrap-before="params[['R_VERSION']]   = '$(R_VERSION)'" \
	--wrap-before="params[['PDFTEX_VERSION']]   = '$(PDFTEX_VERSION)'" \
	--wrap-before="setwd(params[['build_folder']])"
endef

define recipe-template-to-rparams
	@echo [usefl] Building Rparams file: $(@)
	@$(REPORTER) wrap \
	--no-wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.r \
	--no-wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	$(recipe-template-shared) \
	--wrap-before="# AUTOGENERATED FILE.  See recipe-template-to-rparams" \
	--wrap-before="params[['base.name']] = '$(word 1,$(subst ., ,$(@)))'" \
	--wrap-before="params[['molten.dictionary.csv']] = 'molten-dictionary.csv'" \
	--wrap-before="params[['molten.dictionary.rdata']] = 'molten-dictionary.Rdata'" \
	--wrap-before="params[['molten.dictionary.sql']] = 'molten-dictionary.sql'" \
	--wrap-before=" "
endef

define recipe-template-two-to-rparams
	@echo [usefl] Building two-params Rparams file: $(@)
	@$(REPORTER) wrap \
	--no-wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.r \
	--no-wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	$(recipe-template-shared) \
	--wrap-before="# AUTOGENERATED FILE.  See recipe-template-to-rparams" \
	--wrap-before="params[['unit']] = '$(word 2,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['unit.shortname']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_shortname)'" \
	--wrap-before="params[['unit.longname']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_longname)'" \
	--wrap-before="params[['unit.unittype']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_unittype)'" \
	--wrap-before=" "
endef


define recipe-template-to-rnw
	@echo [usefl] Stamping RNW file: $(@) from $(firstword $(^))
	@$(REPORTER) wrap \
	--wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	--wrap-before="%% AUTOGENERATED FILE from $(firstword $(^))" \
	--wrap-sweave-before="source( '$(word 1,$(subst ., ,$(@))).Rparams' ) " \
	--wrap-before=" "
endef

define recipe-template-to-rmd
	@echo [usefl] Stamping Rhtml file: $(@) from $(firstword $(^))
	@$(REPORTER) wrap \
	--wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	--wrap-rmd-before="# AUTOGENERATED FILE from $(firstword $(^))" \
	--wrap-rmd-before="source( '$(word 1,$(subst ., ,$(@))).Rparams' ) " 
endef


define recipe-template-to-rhtml
	@echo [usefl] Stamping Rhtml file: $(@) from $(firstword $(^))
	@$(REPORTER) wrap \
	--wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	--wrap-rhtml-before="# AUTOGENERATED FILE from $(firstword $(^))" \
	--wrap-rhtml-before="source( '$(word 1,$(subst ., ,$(@))).Rparams' ) " \
	--wrap-before=" "
endef


define recipe-rnw-to-tex-sweave
	@echo [usefl] Building TEX file: $(@)
	@"$(R)" --slave --quiet -e \
	"Sweave('$(word 1,$(subst ., ,$(@))).rnw',output='$(word 1,$(subst ., ,$(@))).tex',quiet=T)"
endef

define recipe-rnw-to-tex
	@echo [usefl] Knitting rnw to tex: $(@)
	"$(R)" --slave --quiet -e "library(knitr); build.file='$(@)'; opts_knit\$$set(progress = FALSE, verbose = FALSE); suppressMessages(knit('$(firstword $(^))'))" 2>&1 | sed -e "s/^/\[usefl\] /"
endef

define recipe-rhtml-to-html
	@echo [usefl] Knitting rhtml to html: $(@)
	"$(R)" --slave --quiet -e "library(knitr); build.file='$(@)'; opts_knit\$$set(progress = FALSE, verbose = FALSE); suppressMessages(knit2html('$(firstword $(^))'))" 2>&1 | sed -e "s/^/\[usefl\] /"
endef

define recipe-rmd-to-html
	@echo [usefl] Knitting rmd to html: $(@)
	"$(R)" --slave --quiet -e "library(knitr); library(markdown); build.file='$(@)'; opts_knit\$$set(progress = FALSE, verbose = FALSE); source('$(firstword $(subst ., ,$(@))).Rparams'); knit2html('$(firstword $(^))')" 2>&1 | sed -e "s/^/\[usefl\] /"
endef

define recipe-rnw-to-r
	@echo [usefl] Purling rnw to R: $(@)
	"$(R)" --slave --quiet -e "library(knitr); build.file='$(@)'; opts_knit\$$set(progress = FALSE, verbose = FALSE); purl('$(firstword $(^))')" 2>&1 | sed -e "s/^/\[usefl\] /"
endef

define recipe-r-to-rdata
	@echo [usefl] Storing Rdata file: $(@)
	$(R) --slave --quiet -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef

define recipe-r-to-something
	@echo [usefl] Writing $(word 2,$(subst ., ,$(@))) file: $(@) using $(word 1,$(^))
	$(R) --slave --quiet -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef


define recipe-r-to-png
	@echo [usefl] Painting PNG file: $(@) using $($(word 1,$(subst ., ,$(subst -, ,$(@)))).$(word 3,$(subst ., ,$(subst -, ,$(@))))-source)
	$(R) --slave --quiet -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef

define recipe-r-to-pdf
	@echo [usefl] Painting PDF file: $(@) using $($(word 1,$(subst ., ,$(subst -, ,$(@)))).$(word 3,$(subst ., ,$(subst -, ,$(@))))-source)
	$(R) --slave --quiet -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef

define recipe-r-to-txt
	@echo [usefl] Writing TXT file: $(@) using $($(word 1,$(subst ., ,$(subst -, ,$(@)))).$(word 3,$(subst ., ,$(subst -, ,$(@))))-source)
	$(R) --slave --quiet -e "build.file='$(@)'; save.as.txt.file=T; source('$(word 1,$(subst ., ,$(@))).R')"  1>$(NULL)
endef

define recipe-copy-file
	@echo [usefl] Copying $(^)
	$(COPY) $(^) $(@)
endef

define recipe-sql-to-csv-dsgroot
	@echo [usefl] Query to csv file: $(@)
	$(REPORTER) csv --query-file=$(^) --csv-file=$(@) --DSN=$(DSGROOT_DSN) --USER=$(DSGROOT_USER) --PASS=$(DSGROOT_PASS)
endef

define recipe-tex-to-pdf
	@echo [usefl] Building PDF file: $(@) - XELATEX
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
endef

define recipe-tex-to-xelatex
	@echo [usefl] Building PDF file: $(@) - XELATEX
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --quiet --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
endef

define recipe-tex-to-pdflatex
	@echo [usefl] Building PDF file: $(@) - $(PDFTEX)
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
endef

define recipe-tex-to-pdfbib
	@echo [usful] Building PDF with BIB file: $(@)
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	bibtex $(firstword $(subst ., ,$(@)))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
endef

define recipe-tex-to-xelatex-bib
	@echo [usful] Building PDF with BIB file: $(@)
	xelatex --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	bibtex $(word 1,$(subst ., ,$(@)))
	xelatex --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	xelatex --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
endef

