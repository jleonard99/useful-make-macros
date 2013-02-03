%.pdf : %.tex ; $(recipe-tex-to-pdf)
%.tex : %.rnw ; $(recipe-rnw-to-tex)
%.RParams :  ; $(recipe-template-to-rparams)
%.RData : %.R %.RParams molten-utils.R ; $(recipe-r-to-rdata)
%.R : %.rnw ; $(recipe-rnw-to-r)

# Handy macros for converting comma-separated lists to space-separated lists and back
# for example:
#	--xls-toc-note="Students sampled from the following terms: $(subst $(comma),$(space),$($(word 1,$(subst ., ,$(@))).terms))" \

comma := ,
empty :=
space := $(empty) $(empty)

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
	@echo + [useful] Building RParams file: $(@)
	@$(REPORTER) wrap \
	--no-wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.r \
	--no-wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	$(recipe-template-shared) \
	--wrap-before="# AUTOGENERATED FILE.  See recipe-template-to-rparams" \
	--wrap-before="params[['base.name']] = '$(word 1,$(subst ., ,$(@)))'" \
	--wrap-before="params[['molten.dictionary.csv']] = 'molten-dictionary.csv'" \
	--wrap-before="params[['molten.dictionary.rdata']] = 'molten-dictionary.RData'" \
	--wrap-before="params[['molten.dictionary.sql']] = 'molten-dictionary.sql'" \
	--wrap-before=" "
endef

define recipe-template-two-to-rparams
	@echo + [useful] Building two-params RParams file: $(@)
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
	@echo + [useful] Stamping RNW file: $(@)
	@$(REPORTER) wrap \
	--wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.rnw \
	--wrap-out=$(@) \
	--wrap-before="%% AUTOGENERATED FILE from $(word 1,$(subst -, ,$(subst ., ,$(@))))-template.rnw" \
	--wrap-sweave-before="source( '$(word 1,$(subst ., ,$(@))).RParams' ) " \
	--wrap-before=" "
endef

define recipe-rnw-to-tex-sweave
	@echo + [useful] Building TEX file: $(@)
	@"$(R)" --slave --quiet -e \
	"Sweave('$(word 1,$(subst ., ,$(@))).rnw',output='$(word 1,$(subst ., ,$(@))).tex',quiet=T)"
endef

define recipe-rnw-to-tex
	@echo + [useful] Knitting rnw to tex: $(@)
	"$(R)" --slave --quiet -e "library(knitr); opts_knit\$$set(progress = FALSE, verbose = FALSE); knit('$(firstword $(^))')" 2>&1 | sed -e "s/^/+ - /"
endef

define recipe-rnw-to-r
	@echo + [useful] Purling rnw to R: $(@)
	"$(R)" --slave --quiet -e "library(knitr); opts_knit\$$set(progress = FALSE, verbose = FALSE); purl('$(firstword $(^))')" 2>&1 | sed -e "s/^/+ - /"
endef

define recipe-r-to-rdata
	@echo + [useful] Storing RData file: $(@) using $(word 1,$(^))
	$(R) --slave --quiet -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef

define recipe-r-to-png
	@echo + [useful] Painting PNG file: $(@) using $($(word 1,$(subst ., ,$(subst -, ,$(@)))).$(word 3,$(subst ., ,$(subst -, ,$(@))))-source)
	$(R) --slave --quiet -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef

define recipe-r-to-pdf
	@echo + [useful] Painting PDF file: $(@) using $($(word 1,$(subst ., ,$(subst -, ,$(@)))).$(word 3,$(subst ., ,$(subst -, ,$(@))))-source)
	$(R) --slave --quiet -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef

define recipe-r-to-txt
	@echo + [useful] Writing TXT file: $(@) using $($(word 1,$(subst ., ,$(subst -, ,$(@)))).$(word 3,$(subst ., ,$(subst -, ,$(@))))-source)
	$(R) --slave --quiet -e "build.file='$(@)'; save.as.txt.file=T; source('$(word 1,$(subst ., ,$(@))).R')"  1>$(NULL)
endef

define recipe-copy-file
	@echo + [useful] Copying $(^)
	$(COPY) $(^) $(@)
endef

define recipe-sql-to-csv
	@echo + [useful] Query to csv file: $(@)
	$(REPORTER) csv --query-file=$(^) --csv-file=$(@)
endef

define recipe-tex-to-pdf
	@echo + [useful] Building PDF file: $(@)
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
	$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@))) $(firstword $(^))
endef

