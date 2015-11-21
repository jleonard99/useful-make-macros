##
## Determine current and previous YYYYMM periods from OS.  Use calculator functions to get current and current fiscal years.
##

# handy calculator functions.  
# calc.year : given an input YYYYMM period, return a numeric calendar year
# calc.fiscal.year : given an input YYYYMM period, return a numeric fiscal year (FY started on July 1)

calc.year = $(call substr,$(1),1,4)
calc.mo = $(call substr,$(1),5,6)

# pulls
calc.fy = $(if $(findstring $(call substr,$(1),5,6),07 08 09 10 11 12),$(call inc,$(call substr,$(1),1,4)),$(call substr,$(1),1,4))
calc.cy = $(if $(findstring $(call substr,$(1),5,6),07 08 09 10 11 12),$(call substr,$(1),1,4),$(call dec,$(call substr,$(1),1,4)))

pick.fy = $(call substr,$(1),3,6)
pick.fp = $(call substr,$(1),3,8)

arg.base = $(word 1,$(subst ., ,$(subst -, ,$(1))))
arg.unit = $(word 2,$(subst ., ,$(subst -, ,$(1))))
arg.time = $(word 3,$(subst ., ,$(subst -, ,$(1))))
arg.term = $(word 3,$(subst ., ,$(subst -, ,$(1))))
arg.fy = $(call pick.fy,$(call arg.time,$(1)))
arg.fp = $(call pick.fp,$(call arg.time,$(1)))

arg.1 = $(word 1,$(subst ., ,$(subst -, ,$(1))))
arg.2 = $(word 2,$(subst ., ,$(subst -, ,$(1))))
arg.3 = $(word 3,$(subst ., ,$(subst -, ,$(1))))
arg.4 = $(word 4,$(subst ., ,$(subst -, ,$(1))))


# pre-pend strings to yearmo stuff
prepend.fp = FP$(1)
prepend.fy = FY$(1)
prepend.cp = CP$(1)
prepend.time = time-$(1)
prepend.unit = unit-$(1)

to.list = $(subst $(space),$(comma),$(1))
single.quote = \'$(subst $(space),\' \',$(1))\'

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

# convert fiscal period month to words
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
calc.fpname = $(call get,set.fpname,$(call substr,$(1),5,6))

# convert integer month to 2-digit month (addsleading zero if needed)
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

# Convert a calendar period (201506 to fiscal period 201511)
convert.cp.to.fp = $(call calc.fy,$(1))$(call calc.fm,$(1))

## curr.yearmo:  ex. 201506
curr.time := $(shell date.exe +%Y%m)
curr.yearmo := $(call memoize,curr.time)

## returns pieces of current month
curr.year := $(call calc.year,$(curr.yearmo))
curr.mo := $(call calc.mo,$(curr.yearmo))
curr.fm := $(call calc.fm,$(curr.yearmo))
curr.fp := $(call convert.cp.to.fp,$(curr.yearmo))

# previous time returns YYYYMM from x months ago
prev.time = $(shell date.exe +%Y%m --date="$(1)month")
#ex.3.months.ago.yearmo := $(call prev.time,-3)
#ex.0.months.ago.yearmo := $(call prev.time,0)

## previous month: ex. 201505
prev.yearmo := $(call memoize,prev.time,-1)
prev.year := $(call calc.year,$(prev.yearmo))
prev.mo := $(call calc.mo,$(prev.yearmo))
prev.fm := $(call calc.fm,$(prev.yearmo))
prev.fp := $(call calc.fy,$(prev.yearmo))$(call calc.fm,$(prev.yearmo))

curr.fy := $(call calc.fy,$(curr.yearmo))
prev.fy := $(call dec,$(curr.fy))
next.fy := $(call inc,$(curr.fy))

## core calculators

calc.seq = $(call sequence,0,$(call dec,$(1)))
#ex.calc.seq.12 := $(call calc.seq,12)
#ex.calc.seq.3 := $(call calc.seq,3)

yearmo.to.seq = $(call plus,$(call multiply,$(call subtract,$(call calc.year,$(1)),1950),12),$(call dec,$(call calc.mo,$(1))))
seq.to.yearmo = $(call plus,$(call divide,$(1),12),1950)$(call get,set.mo,$(call inc,$(call subtract,$(1),$(call multiply,$(call divide,$(1),12),12))))

#ex.yearmo.to.seq := $(call yearmo.to.seq,$(curr.yearmo))
#ex.seq.to.yearmo := $(call seq.to.yearmo,$(ex.yearmo.to.seq))

# returns a list of N previous periods including current period by year.  works for both FY and CY
calc.n.mo.by.yr = $(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call calc.year,$(1)),$(year))$(call calc.mo,$(1)))

#ex.calc.5.fp.by.fy := $(call calc.n.mo.by.yr,$(curr.fp),5)
#ex.calc.3.cp.by.cy := $(call calc.n.mo.by.yr,$(curr.yearmo),3)

# returns a list of N previous periods including current period by period.  works for by FY and CY
calc.n.mo.by.mo = $(foreach mo,$(call calc.seq,$(2)),$(call seq.to.yearmo,$(call subtract,$(call yearmo.to.seq,$(1)),$(mo))))

#ex.calc.36.fp.by.fp := $(call calc.n.mo.by.mo,201509,36)
#ex.calc.12.fp.by.fp := $(call calc.n.mo.by.mo,201511,12)
#ex.calc.3.mo.by.mo  := $(call calc.n.mo.by.mo,201506, 3)

# given fiscal period, return list of new fiscal periods

fp.by.n.fy = $(sort $(call map,prepend.fp,$(call calc.n.mo.by.yr,$(call pick.fp,$(1)),$(2))))
fp.by.n.fp = $(sort $(call map,prepend.fp,$(call calc.n.mo.by.mo,$(call pick.fp,$(1)),$(2))))
fy.by.n.fy = $(sort $(call map,prepend.fy,$(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call pick.fy,$(1)),$(year)))))

#ex.fp.by.n.fy := $(call fp.by.n.fy,FP201511,5)
#ex.fp.by.n.fp := $(call fp.by.n.fp,FP201511,60)

# macros for use within recipes.  Assumes 2 param file naming format:  emp0-ENGR-FP201511.xls

arg.fp.by.n.fy = $(call fp.by.n.fy,$(call arg.time,$(1)),$(2))
arg.fp.by.n.fp = $(call fp.by.n.fp,$(call arg.time,$(1)),$(2))
arg.fy.by.n.fy = $(call fy.by.n.fy,$(call arg.time,$(1)),$(2))

arg.fp.by.n.fy.list = $(call to.list,$(call arg.fp.by.n.fy,$(1),$(2)))
arg.fp.by.n.fp.list = $(call to.list,$(call arg.fp.by.n.fp,$(1),$(2)))
arg.fy.by.n.fy.list = $(call to.list,$(call arg.fy.by.n.fy,$(1),$(2)))

arg.fp.by.n.fp.sql = $(call to.list,$(call single.quote,$(call arg.fp.by.n.fp,$(1),$(2))))
arg.fy.by.n.fy.sql = $(call to.list,$(call single.quote,$(call arg.fy.by.n.fy,$(1),$(2))))

arg.fp.by.5.fy  = $(call fp.by.n.fy,$(call arg.time,$(1)),5)
arg.fp.by.12.fp = $(call fp.by.n.fp,$(call arg.time,$(1)),12)

arg.fp.by.5.fy.list  = $(call to.list,$(call arg.fp.by.5.fy,$(1)))
arg.fp.by.12.fp.list = $(call to.list,$(call arg.fp.by.12.fp,$(1)))

#ex.temp.file := emp0-ENGR-FP201511.xls
#ex.arg.fp.by.5.fy  := $(call arg.fp.by.5.fy,$(ex.temp.file))
#ex.arg.fp.by.12.fp := $(call arg.fp.by.12.fp,$(ex.temp.file))
#ex.arg.fp.by.5.fy.list := $(call arg.fp.by.5.fy.list,$(ex.temp.file))
#ex.arg.fp.by.12.fp.list := $(call arg.fp.by.n.fp.list,$(ex.temp.file),12)

# macros for use in Makefile to establish file names

window.prev.5.fp.by.fy  := $(call fp.by.n.fy,FP$(prev.fp),5)
window.prev.3.fp.by.fp  := $(call fp.by.n.fp,FP$(prev.fp),3)
window.prev.12.fp.by.fp := $(call fp.by.n.fp,FP$(prev.fp),12)
window.curr.4.fy.by.fy :=  $(call fy.by.n.fy,FY$(curr.fy),4)

convert.fp.to.words  = $(call calc.fpname,$(call pick.fp,$(1))) $(call calc.cy,$(call pick.fp,$(1)))

curr.fp.in.words := $(call convert.fp.to.words,FP$(curr.fp))

time.vars := curr.yearmo curr.year curr.mo curr.fy curr.fp curr.fp.in.words prev.yearmo prev.year prev.mo prev.fy prev.fp next.fy window.curr.4.fy.by.fy

show-time.title := Usage info and time.vars available in makefile
show-time:
	@echo time variables available for use in makefile
	$(foreach var,$(time.vars),@echo $(var): $($(var))$(\n))
	@echo 
	@echo SAMPLE CALLS for use Makefile header
	@echo window.prev.5.fp.by.fy  := $$\(call fp.by.n.fy,FP$$\(prev.fp\),5\)
	@echo window.prev.3.fp.by.fp  := $$\(call fp.by.n.fp,FP$$\(prev.fp\),3\)
	@echo window.4.fy.by.fy  := $$\(call fy.by.n.fy,FY$$\(curr.fy\),4\)
	@echo $$\(foreach period,$$\(call fp.by.n.fp,FP$$\(prev.fp\),6\),emp0-ENGR-$$\(period\).xls\)
	@echo As SQL in makefile: AND FY_CODE IN \($$\(call arg.fy.by.n.fy.sql,$$\(@\),5\)\)
	@echo 
	@echo SAMPLE CALLS for use in recipes.
	@echo --dept-abbr-30010=$$\(call arg.unit,$$\(@\)\)
	@echo --title-34225=\"Payroll - $$\(call convert.fp.to.words,$$\(call arg.time,$$\(@\)\)\)\"
	@echo --fiscal-period-32415=$$\(call arg.time,$$\(@\)\)
	@echo --fiscal-period-30302=$$\(call arg.fp.by.n.fp.list,$$\(@\),12\)
	@echo --fiscal-year-32488=$$\(call arg.fy.by.n.fy.list,$$\(@\),5\)
	@echo 
