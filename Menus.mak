ifeq ($(R_TOOLS),)
$(info + $(R_TOOLS))
$(info + R_TOOLS not set.  Run SETRTOOLS.BAT )
$(info + )
$(error ***)
endif

title.search.files = Makefile

titles.title = Show titles in targets
titles: ; $(titles)

sorted.title = Show sorted titles 
sorted: ; $(sortedtitles)


define titles
	@echo + =============================================================================
	@echo + UNSORTED list of top level targets with titles  -try make sorted-
	@echo +
	@grep -P -i "\.title(.*)=" $(title.search.files)  | grep -v "\@grep" | sed -n -e "s/\.title//p" | sed -e "s/^/+ /"
	@echo +
endef

define sortedtitles
	@echo + =============================================================================
	@echo + SORTED list of top level targets with titles -try make titles-
	@echo +
	@grep -P -i "\.title(.*)=" $(title.search.files)  | grep -v "\@grep" | sed -n -e "s/\.title//p" | sed -e "s/^/+ /" | sort
	@echo +
endef

help:
	@echo + -----------------------------------------------------------------------------
	@echo + Additional commands -from src/Menus.mak-
	@echo +
	@grep -P -i "\.title(.*)=" src/Menus.mak | grep -v "\@grep" | sed -n -e "s/\.title//p" | sed -e "s/^/+ /"
	@echo +
