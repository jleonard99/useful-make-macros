
%.pdf : %.tex ; $(recipe-tex-to-pdf)
%.tex : %.rnw %.RParams ; $(recipe-rnw-to-tex)
%.RParams :  ; $(recipe-template-to-rparams)
%.RData : %.R %.RParams molten-utils.R ; $(recipe-r-to-rdata)
%.R : %.rnw ; $(recipe-rnw-to-r)

comma := ,
empty :=
space := $(empty) $(empty)


define recipe-template-to-rparams
	@echo + Building RParams file: $(@)
	@$(REPORTER) wrap \
	--no-wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.r \
	--no-wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	--wrap-before="# AUTOGENERATED FILE.  See recipe-template-to-rparams" \
	--wrap-before="params = list()" \
	--wrap-before="params[['build_file']] = '$(@)'" \
	--wrap-before="params[['build_time']]     = '$(build_time)'" \
	--wrap-before="params[['build_version']]  = '$(build_version)'" \
	--wrap-before="params[['build_folder']]   = '$(build_folder)'" \
	--wrap-before="params[['base.name']] = '$(word 1,$(subst ., ,$(@)))'" \
	--wrap-before="params[['R_VERSION']]   = '$(R_VERSION)'" \
	--wrap-before="params[['PDFTEX_VERSION']]   = '$(PDFTEX_VERSION)'" \
	--wrap-before="setwd(params[['build_folder']])" \
	--wrap-before="params[['molten.changes.csv']] = 'molten-changes.csv'" \
	--wrap-before="params[['molten.changes.rdata']] = 'molten-changes.RData'" \
	--wrap-before="params[['molten.changes.terms']] = '$(molten-changes.terms)'" \
	--wrap-before="params[['analysis.terms']] = '$($(word 1,$(subst -, ,$(subst ., ,$(@)))).terms)'" \
	--wrap-before=" "
endef

define recipe-template-two-to-rparams
	@echo + Building two-params RParams file: $(@)
	@$(REPORTER) wrap \
	--no-wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.r \
	--no-wrap-in=$(firstword $(^)) \
	--wrap-out=$(@) \
	--wrap-before="# AUTOGENERATED FILE.  See recipe-template-to-rparams" \
	--wrap-before="params = list()" \
	--wrap-before="params[['build_file']] = '$(@)'" \
	--wrap-before="params[['build_time']]     = '$(build_time)'" \
	--wrap-before="params[['build_version']]  = '$(build_version)'" \
	--wrap-before="params[['build_folder']]   = '$(build_folder)'" \
	--wrap-before="params[['base.name']] = '$(word 1,$(subst ., ,$(@)))'" \
	--wrap-before="params[['R_VERSION']]   = '$(R_VERSION)'" \
	--wrap-before="params[['PDFTEX_VERSION']]   = '$(PDFTEX_VERSION)'" \
	--wrap-before="setwd(params[['build_folder']])" \
	--wrap-before="params[['molten.changes.csv']] = '$(word 1,$(subst ., ,$(@))).csv'" \
	--wrap-before="params[['molten.changes.rdata']] = 'molten-changes.RData'" \
	--wrap-before="params[['molten.changes.terms']] = '$(molten-changes.terms)'" \
	--wrap-before="params[['analysis.terms']] = '$($(word 1,$(subst -, ,$(subst ., ,$(@)))).terms)'" \
	--wrap-before="params[['unit']] = '$(word 2,$(subst -, ,$(subst ., ,$(@))))'" \
	--wrap-before="params[['unit.shortname']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_shortname)'" \
	--wrap-before="params[['unit.longname']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_longname)'" \
	--wrap-before="params[['unit.unittype']] = '$($(word 2,$(subst -, ,$(subst ., ,$(@))))_unittype)'" \
	--wrap-before=" "
endef

define recipe-template-to-rnw
	@echo + Stamping RNW file: $(@)
	@$(REPORTER) wrap \
	--wrap-in=$(word 1,$(subst -, ,$(subst ., ,$(@))))-template.rnw \
	--wrap-out=$(@) \
	--wrap-before="%% AUTOGENERATED FILE from $(word 1,$(subst -, ,$(subst ., ,$(@))))-template.rnw" \
	--wrap-sweave-before="source( '$(word 1,$(subst ., ,$(@))).RParams' ) " \
	--wrap-before=" "
endef

define recipe-rnw-to-tex
	@echo + Building TEX file: $(@)
	@"$(R)" --slave --quiet --max-mem-size=2047M -e \
	"Sweave('$(word 1,$(subst ., ,$(@))).rnw',output='$(word 1,$(subst ., ,$(@))).tex',quiet=T)"
endef

define recipe-rnw-to-r
	@echo + Untangling R file: $(@)
	@"$(R)" --slave --quiet --max-mem-size=2047M -e \
	"Stangle('$(word 1,$(subst ., ,$(@))).rnw',output='$(word 1,$(subst ., ,$(@))).R',quiet=T,annotate=T,keep.source=T)"
endef

define recipe-tex-to-pdf
	@echo + Building PDF file: $(@)
	@$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@)))	$(word 1,$(subst ., ,$(@))).tex
	@$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@)))	$(word 1,$(subst ., ,$(@))).tex
	@$(PDFTEX) --job-name=$(word 1,$(subst ., ,$(@)))	$(word 1,$(subst ., ,$(@))).tex
endef

define recipe-r-to-rdata
	@echo + Storing RData file: $(@) using $(word 1,$(^))
	$(R) --slave --quiet --max-mem-size=2047M -e "build.file='$(@)'; source('$(word 1,$(^))')" 1>$(NULL)
endef

define recipe-sql-to-csv
	@echo + Querying data store: $(@)
	$(REPORTER) csv --query-file=$(^) --csv-file=$(@)
endef

define recipe-mchange1-xls
	@echo + Building $(@) - $($(@).title) 
	@echo + Using terms: $($(@).terms)
	@$(REPORTER) run \
	\
	--report-id=13170 \
	--title-13170="Students who changed majors within ENGR (including UEC)" \
	--save-sql-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170.sql \
	--save-latex-fields-and-desc-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-a.tex \
	--save-latex-fields-and-titles-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-b.tex \
	--save-latex-titles-and-desc-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-c.tex \
	--term-code-13170=$($(@).terms) \
	--deg-level-13170=UG \
	--new-college-13170=N \
	--curr-college-13170=E \
	\
	--report-id=13171 \
	--title-13171="Students who changed majors into ENGR from another college (including SPEC)" \
	--save-sql-13171=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13171.sql \
	--term-code-13171=$($(@).terms) \
	--deg-level-13171=UG \
	--new-college-13171=Y \
	--curr-college-13171=E \
	\
	--report-id=13172 \
	--title-13172="Students who changed majors to another college from ENGR" \
	--save-sql-13172=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13172.sql \
	--term-code-13172=$($(@).terms) \
	--deg-level-13172=UG \
	--new-college-13172=Y \
	--prev-college-13172=E \
	\
	--report-id=13173 \
	--title-13173="Students in ENGR who did not change majors (see note on cover)" \
	--save-sql-13173=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13173.sql \
	--term-code-13173=$($(@).terms) \
	--deg-level-13173=UG \
	--changed-major-13173=N \
	--curr-college-13173=E \
	\
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--no-xls-dry-run=0 \
	--xls-toc-tab \
	--xls-toc-title="College of Engineering" \
	--xls-title="$($(word 1,$(subst ., ,$(@))).title)" \
	--xls-toc-note="Students sampled from the following terms: $(subst $(comma),$(space),$($(word 1,$(subst ., ,$(@))).terms))" \
	--xls-toc-note="Students may appear on more than one tab." \
	--xls-toc-note="Students need not be enrolled all terms sampled." \
	--no-xls-performance-tab
	@$(REPORTER) highlight \
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--freeze-at="tab=13170;cell=E6;position=B1;cursor=E6" \
	--freeze-at="tab=13171;cell=E6;position=B1;cursor=E6" \
	--freeze-at="tab=13172;cell=E6;position=B1;cursor=E6" \
	--freeze-at="tab=13173;cell=E6;position=B1;cursor=E6" \
	--header=yes
endef

define recipe-molten-changes-sql
	@echo + Building $(@) 
	@echo + Using terms: $($(word 1,$(subst ., ,$(@))).terms)
	@$(REPORTER) run \
	\
	--report-id=13170 \
	--title-13170="One record per student per term enrolled during the study period - $(subst $(comma),$(space),$($(word 1,$(subst ., ,$(@))).terms))" \
	--save-sql-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@))).sql \
	--save-latex-fields-and-desc-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-a.tex \
	--save-latex-fields-and-titles-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-b.tex \
	--save-latex-titles-and-desc-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-c.tex \
	--term-code-13170=$(subst $(space),$(comma),$($(word 1,$(subst ., ,$(@))).terms)) \
	--deg-level-13170=UG \
	--xnew-college-13170=N \
	--xcurr-college-13170=E \
	\
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--xls-dry-run=1 \
	--no-xls-toc-tab \
	--no-xls-performance-tab
	@$(REPORTER) highlight \
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--no-col="tab=lu_gtf.new.values;col=C;color=vbYellow;allcells=1" \
	--no-col="tab=lu_gtf.new.values;col=D;color=vbYellow;allcells=1" \
	--freeze-at="tab=13170;cell=E6;position=B1;cursor=E6" \
	--no-freeze-at="tab=15334;cursor=V4;position=K1" \
	--header=1
endef

define recipe-audit1-unit-xls
	@echo + recipe-audit1-unit-xls Building $(@) 
	@echo + Using terms: $($(word 1,$(subst -, ,$(subst ., ,$(@)))).terms)
	@echo + unittype: $($(word 2,$(subst -, ,$(subst ., ,$(@))))_unittype)
	@echo + unit: $(word 2,$(subst -, ,$(subst ., ,$(@))))
	@$(REPORTER) run \
	\
	--report-id=13170 \
	--title-13170="One record per student per term enrolled during the study period - $(subst $(comma),$(space),$($(word 1,$(subst ., ,$(@))).terms))" \
	--save-sql-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@))).sql \
	--save-latex-fields-and-desc-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-a.tex \
	--save-latex-fields-and-titles-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-b.tex \
	--save-latex-titles-and-desc-13170=$(TMPDIR)$(word 1,$(subst ., ,$(@)))-13170-c.tex \
	--term-code-13170=$(subst $(comma),$(space),$($(word 1,$(subst -, ,$(subst ., ,$(@)))).terms)) \
	--deg-level-13170=UG \
	--xnew-college-13170=N \
	--curr-$($(word 2,$(subst -, ,$(subst ., ,$(@))))_unittype)-13170=$(word 2,$(subst -, ,$(subst ., ,$(@)))) \
	\
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--xls-dry-run=1 \
	--no-xls-toc-tab \
	--no-xls-performance-tab
	@$(REPORTER) highlight \
	--xls-file=$(TMPDIR)$(word 1,$(subst ., ,$(@))).xls \
	--no-col="tab=lu_gtf.new.values;col=C;color=vbYellow;allcells=1" \
	--no-col="tab=lu_gtf.new.values;col=D;color=vbYellow;allcells=1" \
	--freeze-at="tab=13170;cell=E6;position=B1;cursor=E6" \
	--no-freeze-at="tab=15334;cursor=V4;position=K1" \
	--header=1
endef

