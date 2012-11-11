Useful Make Macros
==================
I regularly create light-weight projects (PDF documents build from tex via knitr and R), storing
these projects in their own folders.  

I found myself copying useful make macros and recipes from folder to folder as I created new projects.
As I improved my skills, I found it difficult to remember where the latest/best version of the macros
lived.

By putting the macros in GITHUB I can reuse them across multiple projects, pushing my best practices to the
repository.  At times that won't break the main project, I can freshen the local copy of the macros and leverage
my newfound skills.


# Installation

Pretty simple, go to the main project folder and clone a copy of the useful macros.

  >> git clone http://github.com/jleonard99/useful-make-macros.git
  
# Use

The macros are stored in 5 different MAK files in the src/ folder.  At the top of the main Make, include 
the following code:

  include useful-make-macros/src/Menus.mak     # common menus and configuration checks
  include useful-make-macros/src/Makefile.mak  # environment related makefile settings and macros
  include useful-make-macros/src/Machines.mak  # contains machine specific overrides with examples
  include useful-make-macros/src/Macros.mak    # additional macros not related to environment
  include useful-make-macros/src/Recipes.mak   # common recipes

Need a sample makefile?  copy a working makefile to your project root:

  cp useful-make-macros/samples/Makefile .
  
# Other useful tools

Because I regularly use LaTex, R, and other gnu utilities on a windows platform, the macros assume that you've 
got this relative robust development environment installed.  Tools include

  gnu utilities including sed, grep, make
  R statistical software
  Latex (miktex)
  
Need help installing these tools?  I've got another light-weight project with instructions for getting started
with these tools.  See:

  http://github.com/jleonard99/Getting-Started


# License

http://github.com/jleonard99/useful-make-macros/LICENSE
