# GNU Make Standard Library
# found it on source forge 2/10/2013.  Cool!  Added it to the useful-make-macros stuff
#

gmsl-version = 1.1.3

menu:
	@echo + Targets:
	@echo + install - download version $(gmsl-version) from source forge and test
	@echo + clean - delete everything but make file
	@echo +
	@echo + assumes that wget, 7z and make are on the path
	@echo +
	@echo + To use GMSL add the following line to your Makefile
	@echo + include useful-make-macros/gmsl
	
	
install:
	wget http://sourceforge.net/projects/gmsl/files/GNU%20Make%20Standard%20Library/v$(gmsl-version)/gmsl-$(gmsl-version).tar.gz
	7z x gmsl-$(gmsl-version).tar.gz
	7z x gmsl-$(gmsl-version).tar
	make -f gmsl-tests

clean:
	-rm "._README" index.html README __gmsl gmsl gmsl-tests 2>/dev/null
	

	