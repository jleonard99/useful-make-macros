#ifeq ($(R_TOOLS),)
#$(info + $(R_TOOLS))
#$(info + R_TOOLS not set.  Run SETRTOOLS.BAT )
#$(info + )
#$(error ***)
#endif

title.search.files = Makefile

sorted : ; $(sortedtitles)  # default target if nothing is selected 
titles unsorted : ; $(titles)

no_target__xxx : ;


define titles
	@echo + -----------------------------------------------------------------------------
	@echo + UNSORTED List of targets:
	@echo +
	$(foreach item,$(shell make -p no_target__xxx | grep -P -o -s "^[-|\_|a-zA-Z0-9\.]+\.title" | sed -e "s/\.title//g" ),echo + $(item) - $($(item).title)$(\n))
	@echo +
endef

define sortedtitles
	@echo + -----------------------------------------------------------------------------
	@echo + SORTED List of targets:
	@echo +
	$(foreach item,$(sort $(shell make -p no_target__xxx | grep -P -o -s "^[-|\_|a-zA-Z0-9\.]+\.title" | sed -e "s/\.title//g" )),echo + $(item) - $($(item).title)$(\n))
	@echo +
endef

help:
	@echo + -----------------------------------------------------------------------------
	@echo + Additional commands -from src/Menus.mak-
	@echo +
	@grep -P -i "\.title(.*)=" src/Menus.mak | grep -v "\@grep" | sed -n -e "s/\.title//p" | sed -e "s/^/+ /" | sed -e "s/==//"
	@echo +
