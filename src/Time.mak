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
calc.termyear = $(if $(findstring $(call substr,$(1),5,6),20 30),$(call substr,$(1),1,4),$(call dec,$(call substr,$(1),1,4)))

time.style = $(if $(findstring $(call substr,$(1),1,2),FP),fiscal-period,$(if $(findstring $(call substr,$(1),1,2),FY),fiscal-year,$(if $(findstring $(call substr,$(1),1,2),CY),calendar-year,$(if $(findstring $(call substr,$(1),1,2),PP),pay-period,term-code))))
arg.time.style = $(call time.style,$(call arg.time,$(1)))

pick.yr.type = $(call substr,$(1),1,2)  # assumes year field starts with 2-character code  FY CY CP FP
pick.fy = $(call substr,$(1),3,6)
pick.cy = $(call substr,$(1),3,6)
pick.fp = $(call substr,$(1),3,8)
pick.term = $(call substr,$(1),5,6)
pick.pp = $(call substr,$(1),3,8)

# Named pieces of filename arguments
#
arg = $(word $(2),$(subst ., ,$(subst -, ,$(1))))
arg.base = $(word 1,$(subst ., ,$(subst -, ,$(1))))
arg.unit = $(word 2,$(subst ., ,$(subst -, ,$(1))))
arg.time = $(word 3,$(subst ., ,$(subst -, ,$(1))))
arg.term = $(word 3,$(subst ., ,$(subst -, ,$(1))))
arg.fy = $(call pick.fy,$(call arg.time,$(1)))
arg.fp = $(call pick.fp,$(call arg.time,$(1)))
arg.pp = $(call pick.pp,$(call arg.time,$(1)))

basename = $(firstword $(subst ., ,$(1)))

# These are designed to parse pieces of file names.  The file extension (.xls) is dropped.
# arguments are numbered from 1 to n, and are pulled from the base file name separated with "-".
# an extra argument is optional - a default value if an argument is missing/empty.
# For example:  fac0-ENGR-FY2016.xls  arg.1->fac0, arg.2->ENGR arg.3->FY2016  arg.4 returns empty.
#
# ex.  $(call arg.3,$(@),FY2016)  or   $(call arg.4,$(@),3)

arg.1 = $(firstword $(word 1,$(subst -, ,$(firstword $(subst ., ,$(1))))) $(2))
arg.2 = $(firstword $(word 2,$(subst -, ,$(firstword $(subst ., ,$(1))))) $(2))
arg.3 = $(firstword $(word 3,$(subst -, ,$(firstword $(subst ., ,$(1))))) $(2))
arg.4 = $(firstword $(word 4,$(subst -, ,$(firstword $(subst ., ,$(1))))) $(2))
arg.n = $(firstword $(word $(2),$(subst -, ,$(firstword $(subst ., ,$(1))))) $(3))


# pre-pend strings to yearmo stuff
prepend.fp = FP$(1)
prepend.pp = PP$(1)
prepend.fy = FY$(1)
prepend.cp = CP$(1)
prepend.cy = CY$(1)
prepend.ay = AY$(1)
prepend.time = time-$(1)
prepend.unit = unit-$(1)

to.list = $(subst $(space),$(comma),$(1))
#single.quote = \'$(subst $(space),\' \',$(1))\'
single.quote = '$(subst $(space),' ',$(1))'

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
# will also work with payperiods that run to 24 per year.
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
$(call set,set.mo,13,13)
$(call set,set.mo,14,14)
$(call set,set.mo,15,15)
$(call set,set.mo,16,16)
$(call set,set.mo,17,17)
$(call set,set.mo,18,18)
$(call set,set.mo,19,19)
$(call set,set.mo,20,20)
$(call set,set.mo,21,21)
$(call set,set.mo,22,22)
$(call set,set.mo,23,23)
$(call set,set.mo,24,24)

# convert integer term to 2-digit term (add leading zero if necessary)
$(call set,set.term,10,10)
$(call set,set.term,20,20)
$(call set,set.term,30,30)

#convert integer term code to term name
$(call set,set.termname,10,Fall)
$(call set,set.termname,20,Spring)
$(call set,set.termname,30,Summer)
calc.termname = $(call get,set.termname,$(call substr,$(1),5,6))

# Convert a calendar period (201506 to fiscal period 201511)
convert.cp.to.fp = $(call calc.fy,$(1))$(call calc.fm,$(1))

convert.fp.to.words  = $(call calc.fpname,$(call pick.fp,$(1))) $(call calc.cy,$(call pick.fp,$(1)))

convert.term.to.words = $(call calc.termname,$(1)) $(call calc.termyear,$(1))

convert.ay.to.words = $(call substr,$(1),1,4)$(call dec,$(call substr,$(1),5,6))-$(call substr,$(1),5,6)


## curr.yearmo:  ex. 201506

curr.time := $(shell date.exe +%Y%m)
curr.yearmo := $(call memoize,curr.time)
curr.timestamp := $(shell date.exe +%Y%m%d%H%M)
curr.date := $(shell date.exe +%Y%m%d)

## returns pieces of current month
curr.year := $(call calc.year,$(curr.yearmo))
curr.mo := $(call calc.mo,$(curr.yearmo))
curr.fm := $(call calc.fm,$(curr.yearmo))
curr.fp := $(call convert.cp.to.fp,$(curr.yearmo))
curr.cy := $(call calc.year,$(curr.yearmo))

#$(warning here)

## returns current pay period using table VCU_PTRCALN
curr.pp := $(shell cmd.exe /c sqlcmd.exe -S $(EGRPROD_SERVER) -d $(EGRPROD_DB) -Q "set nocount on;select top 1 ptrcaln_year*100+ptrcaln_payno from base_vcu_ptrcaln where ptrcaln_check_date<=getdate() order by 1 desc" -W -k2 -h-1)

#$(warning here)

# previous time returns YYYYMM from x months ago
prev.time = $(shell date.exe +%Y%m --date="$(1)month")
#ex.3.months.ago.yearmo := $(call prev.time,-3)
#ex.0.months.ago.yearmo := $(call prev.time,0)


## previous month: ex. 201505
prev.yearmo := $(call memoize,prev.time,-1)
prev.year := $(call calc.year,$(prev.yearmo))
prev.cy := $(call calc.year,$(prev.yearmo))
prev.mo := $(call calc.mo,$(prev.yearmo))
prev.fm := $(call calc.fm,$(prev.yearmo))
prev.fp := $(call calc.fy,$(prev.yearmo))$(call calc.fm,$(prev.yearmo))

curr.fy := $(call calc.fy,$(curr.yearmo))
prev.fy := $(call dec,$(curr.fy))
next.fy := $(call inc,$(curr.fy))
next.cy := $(call inc,$(curr.cy))

## core calculators

calc.seq = $(call sequence,0,$(call dec,$(1)))
#ex.calc.seq.12 := $(call calc.seq,12)
#ex.calc.seq.3 := $(call calc.seq,3)

yearmo.to.seq = $(call plus,$(call multiply,$(call subtract,$(call calc.year,$(1)),1950),12),$(call dec,$(call calc.mo,$(1))))
seq.to.yearmo = $(call plus,$(call divide,$(1),12),1950)$(call get,set.mo,$(call inc,$(call subtract,$(1),$(call multiply,$(call divide,$(1),12),12))))

yearpp.to.seq = $(call plus,$(call multiply,$(call subtract,$(call calc.year,$(1)),1950),24),$(call dec,$(call calc.mo,$(1))))
seq.to.yearpp = $(call plus,$(call divide,$(1),24),1950)$(call get,set.mo,$(call inc,$(call subtract,$(1),$(call multiply,$(call divide,$(1),24),24))))

yearterm.to.seq = $(call plus,$(call multiply,$(call subtract,$(call calc.year,$(1)),1950),30),$(call dec,$(call calc.mo,$(1))))
seq.to.yearterm = $(call plus,$(call divide,$(1),30),1950)$(call get,set.term,$(call inc,$(call subtract,$(1),$(call multiply,$(call divide,$(1),30),30))))

#ex.yearmo.to.seq := $(call yearmo.to.seq,$(curr.yearmo))
#ex.seq.to.yearmo := $(call seq.to.yearmo,$(ex.yearmo.to.seq))

# returns a list of N previous periods including current period by year.  works for both FY and CY and TERM
calc.n.mo.by.yr = $(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call calc.year,$(1)),$(year))$(call calc.mo,$(1)))

#ex.calc.5.fp.by.fy := $(call calc.n.mo.by.yr,$(curr.fp),5)
#ex.calc.3.cp.by.cy := $(call calc.n.mo.by.yr,$(curr.yearmo),3)

# returns a list of N previous periods including current period by period.  works for by FY and CY, NOT TERM
calc.n.mo.by.mo = $(foreach mo,$(call calc.seq,$(2)),$(call seq.to.yearmo,$(call subtract,$(call yearmo.to.seq,$(1)),$(mo))))

#ex.calc.36.fp.by.fp := $(call calc.n.mo.by.mo,201509,36)
#ex.calc.12.fp.by.fp := $(call calc.n.mo.by.mo,201511,12)
#ex.calc.3.mo.by.mo  := $(call calc.n.mo.by.mo,201506, 3)

# returns a list of N previous pay periods including current pay period by pay period. 
calc.n.pp.by.pp = $(foreach mo,$(call calc.seq,$(2)),$(call seq.to.yearpp,$(call subtract,$(call yearpp.to.seq,$(1)),$(mo))))

# return a list of N previous terms including the current term by term
# ex.calc.9.term.by.term = $(call calc.n.term.by.term,201810,9)
calc.n.term.by.term = $(foreach mo,$(call calc.seq,$(2)),$(call seq.to.yearterm,$(call subtract,$(call yearterm.to.seq,$(1)),$(call multiply,$(mo),10))))

# given fiscal period, return list of new fiscal periods.  Some cheating is available
# because of the symetrical nature of the arguments.

fp.by.n.fy = $(sort $(call map,prepend.fp,$(call calc.n.mo.by.yr,$(call pick.fp,$(1)),$(2))))
fp.by.n.fp = $(sort $(call map,prepend.fp,$(call calc.n.mo.by.mo,$(call pick.fp,$(1)),$(2))))
fy.by.n.fy = $(sort $(call map,prepend.fy,$(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call pick.fy,$(1)),$(year)))))
cy.by.n.cy = $(sort $(call map,prepend.cy,$(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call pick.cy,$(1)),$(year)))))
ay.by.n.ay = $(sort $(call map,prepend.ay,$(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call pick.cy,$(1)),$(year)))))
pp.by.n.yr = $(sort $(call map,prepend.pp,$(call calc.n.mo.by.yr,$(call pick.pp,$(1)),$(2))))

pp.by.n.pp = $(sort $(call map,prepend.pp,$(call calc.n.pp.by.pp,$(call pick.pp,$(1)),$(2))))

yr.by.n.yr = $(sort $(foreach year,$(call calc.seq,$(2)),$(subst $(space),,$(call pick.yr.type,$(1))$(call subtract,$(call pick.cy,$(1)),$(year)))))

term.by.n.yr = $(sort $(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call calc.year,$(1)),$(year))$(call calc.mo,$(1))))
term.by.n.term = $(sort $(foreach mo,$(call calc.seq,$(2)),$(call seq.to.yearterm,$(call subtract,$(call yearterm.to.seq,$(1)),$(call multiply,$(mo),10)))))

yr.by.n.yr.list = $(call to.list,$(sort $(foreach year,$(call calc.seq,$(2)),$(subst $(space),,$(call pick.yr.type,$(1))$(call subtract,$(call pick.cy,$(1)),$(year))))))
fy.by.n.fy.list = $(call to.list,$(sort $(foreach year,$(call calc.seq,$(2)),$(subst $(space),,$(call pick.yr.type,$(1))$(call subtract,$(call pick.cy,$(1)),$(year))))))
fp.by.n.fp.list = $(call to.list,$(call fp.by.n.fp,$(1),$(2)))
pp.by.n.yr.list = $(call to.list,$(call pp.by.n.yr,$(1),$(2)))
term.by.n.yr.list = $(call to.list,$(sort $(foreach year,$(call calc.seq,$(2)),$(call subtract,$(call calc.year,$(1)),$(year))$(call calc.mo,$(1)))))


#ex.fp.by.n.fy := $(call fp.by.n.fy,FP201511,5)
#ex.fp.by.n.fp := $(call fp.by.n.fp,FP201511,60)

# macros for use within recipes.  Assumes 2 param file naming format:  emp0-ENGR-FP201511.xls

arg.pp.by.n.pp = $(call pp.by.n.pp,$(call arg.time,$(1)),$(2))
arg.pp.by.n.pp.list = $(call to.list,$(call arg.pp.by.n.pp,$(1),$(2)))
arg.pp.by.n.pp.sql = $(call to.list,$(call single.quote,$(call arg.pp.by.n.pp,$(1),$(2))))
arg.pp.by.n.yr = $(call pp.by.n.yr,$(call arg.time,$(1)),$(2))
arg.pp.by.n.yr.list = $(call to.list,$(call arg.pp.by.n.yr,$(@),$(2)))

arg.fp.by.n.fy = $(call fp.by.n.fy,$(call arg.time,$(1)),$(2))
arg.fp.by.n.fp = $(call fp.by.n.fp,$(call arg.time,$(1)),$(2))
arg.fy.by.n.fy = $(call fy.by.n.fy,$(call arg.time,$(1)),$(2))
arg.cy.by.n.cy = $(call cy.by.n.cy,$(call arg.time,$(1)),$(2))
arg.ay.by.n.ay = $(call ay.by.n.ay,$(call arg.time,$(1)),$(2))
arg.yr.by.n.yr = $(call yr.by.n.yr,$(call arg.time,$(1)),$(2))
arg.term.by.n.yr = $(call term.by.n.yr,$(call arg.time,$(1)),$(2))
arg.term.by.n.term = $(call term.by.n.term,$(call arg.time,$(1)),$(2))

arg.fp.by.n.fy.list = $(call to.list,$(call arg.fp.by.n.fy,$(1),$(2)))
arg.fp.by.n.fp.list = $(call to.list,$(call arg.fp.by.n.fp,$(1),$(2)))
arg.fy.by.n.fy.list = $(call to.list,$(call arg.fy.by.n.fy,$(1),$(2)))
arg.cy.by.n.cy.list = $(call to.list,$(call arg.cy.by.n.cy,$(1),$(2)))
arg.ay.by.n.ay.list = $(call to.list,$(call arg.ay.by.n.ay,$(1),$(2)))
arg.yr.by.n.yr.list = $(call to.list,$(call arg.yr.by.n.yr,$(1),$(2)))
arg.term.by.n.yr.list = $(call to.list,$(call arg.term.by.n.yr,$(1),$(2)))
arg.term.by.n.term.list = $(call to.list,$(call arg.term.by.n.term,$(1),$(2)))

arg.fp.by.n.fp.sql = $(call to.list,$(call single.quote,$(call arg.fp.by.n.fp,$(1),$(2))))
arg.fy.by.n.fy.sql = $(call to.list,$(call single.quote,$(call arg.fy.by.n.fy,$(1),$(2))))
arg.cy.by.n.cy.sql = $(call to.list,$(call single.quote,$(call arg.cy.by.n.cy,$(1),$(2))))
arg.ay.by.n.ay.sql = $(call to.list,$(call single.quote,$(call arg.ay.by.n.ay,$(1),$(2))))
arg.term.by.n.yr.sql = $(call to.list,$(call single.quote,$(call arg.term.by.n.yr,$(1),$(2))))
arg.term.by.n.term.sql = $(call to.list,$(call single.quote,$(call arg.term.by.n.term,$(1),$(2))))

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

curr.fp.in.words := $(call convert.fp.to.words,FP$(curr.fp))

time.vars := curr.pp curr.timestamp curr.yearmo curr.year curr.mo curr.fy curr.fp curr.fp.in.words prev.yearmo prev.year prev.mo prev.fy prev.fp next.fy window.curr.4.fy.by.fy

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
	@echo --save-sql-32100=$$\(call basename,$$\(@\)\)-32100.sql 
	@echo --fiscal-period-32415=$$\(call arg.time,$$\(@\)\)
	@echo --fiscal-period-30302=$$\(call arg.fp.by.n.fp.list,$$\(@\),12\)
	@echo --fiscal-year-32488=$$\(call arg.fy.by.n.fy.list,$$\(@\),5\)
	@echo --calendar-year-32488=$$\(call arg.cy.by.n.cy.list,$$\(@\),5\)
	@echo --$$\(call time.style,$$\(call arg.time,$$\(@\)\)\)-32100=$$\(call arg.time,$$\(@\)\)
	@echo --$$\(call arg.time.style,$$\(@\)\)-32100=$$\(call arg.yr.by.n.yr.list,$$\(@\),5\)
	@echo --term-code=$$\(call arg.1\,$$\(@\)\)