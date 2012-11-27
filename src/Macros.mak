

## -------------------------------------------------------------------------------------
## ORACLE SQL block
## -------------------------------------------------------------------------------------
## Macros to start SQLPLUS.  Looks in the ENV for IRPDEV_USER, IRPDEV_PASS and IRPDEV_DSN, etc.
## Assumes that SERVERS are oracle-based 
##

DW.NAME = IRPDEV

DW.USER.ID = $($(DW.NAME)_USER)/$($(DW.NAME)_PASS)@$(DW.NAME).WORLD
DW.CMD = sqlplus -S $(DW.USER.ID)

servers := IRPROD IRPDEV DWPROD DWTEST BGTEST IRPBAG DSGDEVW DSGDEVG
$(foreach server,$(servers),$(eval $(server).CMD = sqlplus $($(server)_USER)/$($(server)_PASS)@$(server).WORLD ) )

$(servers):
	@echo + =============================================================================
	@echo + Running SQLPLUS on $($(@)_DSN) for user $($(@)_USER)
	@echo + -----------------------------------------------------------------------------
	@$($(@).CMD)

