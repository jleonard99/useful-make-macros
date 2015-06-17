

# Determine current and previous YYYYMM periods from OS.  Use calculator functions to get current and current fiscal years.

# handy calculator functions.  
# calc.year : given an input YYYYMM period, return a numeric calendar year
# calc.fiscal.year : given an input YYYYMM period, return a numeric fiscal year (FY started on July 1)

calc.year = $(call substr,$(1),1,4)
calc.mo = $(call substr,$(1),5,6)
calc.fy = $(if $(findstring $(call substr,$(1),5,6),07 08 09 10 11 12),$(call inc,$(call substr,$(1),1,4)),$(call substr,$(1),1,4))
calc.cy = $(if $(findstring $(call substr,$(1),5,6),07 08 09 10 11 12),$(call substr,$(1),1,4),$(call dec,$(call substr,$(1),1,4)))

pick.fy = $(call substr,$(1),3,6)
pick.fp = $(call substr,$(1),3,8)

arg.base = $(word 1,$(subst ., ,$(subst -, ,$(@))))
arg.unit = $(word 2,$(subst ., ,$(subst -, ,$(@))))
arg.time = $(word 3,$(subst ., ,$(subst -, ,$(@))))
arg.term = $(word 3,$(subst ., ,$(subst -, ,$(@))))
arg.fy = $(call pick.fy,$(call arg.time,$(1)))
arg.fp = $(call pick.fp,$(call arg.time,$(1)))

insert.fp = FP$(1)
insert.fy = FY$(1)
insert.cp = CP$(1)
insert.time = time-$(1)
insert.unit = unit-$(1)

to.list = $(subst $(space),$(comma),$(1))

fp.to.5.fp  = $(call map,insert.fp,$(call calc.5.fp,$(1)))
fp.to.6.fp  = $(call map,insert.fp,$(call calc.6.mo,$(1)))
fp.to.12.fp = $(call map,insert.fp,$(call calc.12.mo,$(1)))

arg.fp.to.5.fp  = $(call fp.to.5.fp,$(call arg.fp,$(@)))
arg.fp.to.12.fp = $(call fp.to.12.fp,$(call arg.fp,$(@)))

arg.fp.to.5.fp.list  = $(call to.list,$(call arg.fp.to.5.fp,$(1)))
arg.fp.to.12.fp.list = $(call to.list,$(call arg.fp.to.12.fp,$(1)))


# convert calendar month to fiscal period month
$(call set,set.fm,01,07)
$(call set,set.fm,02,08)
$(call set,set.fm,03,09)
$(call set,set.fm,04,10)
$(call set,set.fm,05,11)
$(call set,set.fm,06,12)
$(call set,set.fm,07,01)
$(call set,set.fm,08,02)
$(call set,set.fm,09,03)
$(call set,set.fm,10,04)
$(call set,set.fm,11,05)
$(call set,set.fm,12,06)
calc.fm = $(call get,set.fm,$(call substr,$(1),5,6))

$(call set,set.fpname,01,Jul)
$(call set,set.fpname,02,Aug)
$(call set,set.fpname,03,Sep)
$(call set,set.fpname,04,Oct)
$(call set,set.fpname,05,Nov)
$(call set,set.fpname,06,Dec)
$(call set,set.fpname,07,Jan)
$(call set,set.fpname,08,Feb)
$(call set,set.fpname,09,Mar)
$(call set,set.fpname,10,Apr)
$(call set,set.fpname,11,May)
$(call set,set.fpname,12,Jun)
calc.fpname = $(call get,set.fpname,$(call substr,$(1),7,8))


$(call set,set.mo,1,01)
$(call set,set.mo,2,02)
$(call set,set.mo,3,03)
$(call set,set.mo,4,04)
$(call set,set.mo,5,05)
$(call set,set.mo,6,06)
$(call set,set.mo,7,07)
$(call set,set.mo,8,08)
$(call set,set.mo,9,09)
$(call set,set.mo,10,10)
$(call set,set.mo,11,11)
$(call set,set.mo,12,12)


curr.yearmo := $(shell date.exe +%Y%m)
curr.year := $(call calc.year,$(curr.yearmo))
curr.mo := $(call calc.mo,$(curr.yearmo))
curr.fy := $(call calc.fy,$(curr.yearmo))
curr.fm := $(call calc.fm,$(curr.yearmo))
curr.fp := $(call calc.fy,$(curr.yearmo))$(call calc.fm,$(curr.yearmo))

prev.time = $(shell date.exe +%Y%m --date="$(1)month")
prev.yearmo := $(call memoize,prev.time,-1)

prev.year := $(call calc.year,$(prev.yearmo))
prev.mo := $(call calc.mo,$(prev.yearmo))
prev.fy := $(call dec,$(call calc.fy,$(prev.yearmo)))
prev.fm := $(call calc.fm,$(prev.yearmo))
prev.fp := $(call calc.fy,$(prev.yearmo))$(call calc.fm,$(prev.yearmo))

calc.5.yr = $(foreach year,0 1 2 3 4,$(call subtract,$(call calc.year,$(1)),$(year)))
calc.5.fp = $(foreach year,0 1 2 3 4,$(call subtract,$(call calc.year,$(1)),$(year))$(call calc.mo,$(1)))

calc.12.mo = $(foreach mo,0 1 2 3 4 5 6 7 8 9 10 11,$(if $(call gt,$(call calc.mo,$(1)),$(mo)),$(call calc.year,$(1)),$(call subtract,$(call calc.year,$(1)),1))$(call get,set.mo,$(if $(call gt,$(call calc.mo,$(1)),$(mo)),$(call subtract,$(call calc.mo,$(1)),$(mo)),$(call subtract,$(call plus,$(call calc.mo,$(1)),12),$(mo)))))

calc.6.mo = $(foreach mo,0 1 2 3 4 5,$(if $(call gt,$(call calc.mo,$(1)),$(mo)),$(call calc.year,$(1)),$(call subtract,$(call calc.year,$(1)),1))$(call get,set.mo,$(if $(call gt,$(call calc.mo,$(1)),$(mo)),$(call subtract,$(call calc.mo,$(1)),$(mo)),$(call subtract,$(call plus,$(call calc.mo,$(1)),12),$(mo)))))


window.prev.fp.5.fy  := $(call calc.5.yr,$(prev.yearmo))

window.prev.fp.5.fp  := $(call fp.to.5.fp,$(prev.fp))
window.prev.fp.6.fp  := $(call fp.to.6.fp,$(prev.fp))
window.prev.fp.12.fp := $(call fp.to.12.fp,$(prev.fp))

time.vars := curr.yearmo curr.year curr.mo curr.fy curr.fp prev.yearmo prev.year prev.mo prev.fy prev.fp window.prev.fp.5.fy window.prev.fp.5.fp window.prev.fp.12.fp

show-time.title := Show time variables available in makefile
show-time:
	@echo time variables available for use in makefile
	$(foreach var,$(time.vars),@echo $(var): $($(var))$(\n))
