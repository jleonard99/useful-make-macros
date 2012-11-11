@REM + Setting environment for RTOOLS
@REM
@REM This file is best kept on the global path so all projects can share
@REM these settings.  Also keep oegit.bat in same folder.
@REM
@SET R_VERSION=2.15.2
@SET R_TOOLS=2.16
@SET R_GCC=gcc-4.6.3
@REM
@REM For R-program base - uses R_VERSION from above
@SET PATH=%PATH%;C:\Program Files\R\R-%R_VERSION%\bin;
@REM
@REM this path is for RTOOLS version set in the R_TOOLS variable above
@SET PATH=%PATH%;C:\Rtools\%R_TOOLS%\bin;C:\Rtools\%R_TOOLS%\%R_GCC%\bin;
@REM
@REM For GIT version control
@SET PATH=%PATH%;C:\Program Files\Git\cmd;C:\Program Files\Git\bin
@REM
@REM 
@SET HOME=%HOMEDRIVE%%HOMEPATH%
@SET SVN_EDITOR=oegit.bat
@SET EDITOR=oegit.bat
@SET CYGWIN=nodosfilewarning
@REM
@REM R is available at:  http://cran.r-project.org/bin/windows/base/  (old versions also available)
@REM RTOOLS is available at:  http://www.murdoch-sutherland.com/Rtools/
@REM RTOOLS must be updated to "match" different versions of R.
@REM By default RTOOLS doesn't install into version-specific subdirectories. YOU NEED TO DO IT!
@ECHO + Setting RTOOLS environment.  R:%R_VERSION%  RTOOLS: %R_TOOLS% GCC: %R_GCC%  GIT: Yes
