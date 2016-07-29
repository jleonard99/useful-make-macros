

## -------------------------------------------------------------------------------------
## ORACLE SQL block
## -------------------------------------------------------------------------------------
## Macros to start SQLPLUS.  Looks in the ENV for IRPDEV_USER, IRPDEV_PASS and IRPDEV_DSN, etc.
## Assumes that SERVERS are oracle-based 
##

DW.NAME = IRPDEV

DW.USER.ID = $($(DW.NAME)_USER)/$($(DW.NAME)_PASS)@$(DW.NAME).WORLD
DW.CMD = sqlplus -S $(DW.USER.ID)

servers := IRPROD IRPDEV DWPROD DWTEST BGTEST IRPBAG DSGDEVW DSGDEVG DSGDEVM DSGTESTM BPROD DSGPRODM MPRODM DGWPRODM INSITETEST EDMDEVM EDMTESTM EDMPRODM RCDEV BPRODJ RCPROD WEBPROD INSITET2

$(foreach server,$(servers),$(eval $(server).CMD = sqlplus $($(server)_USER)/$($(server)_PASS)@$(server).WORLD ) )

$(servers):
	@echo + =============================================================================
	@echo + Running SQLPLUS on $($(@)_USER)@$(@).WORLD - $($(@)_DSN)
	@echo + -----------------------------------------------------------------------------
	$($(@).CMD)

