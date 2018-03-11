@echo off
REM JZB20140126
REM A dos batch file to create a pdf document from Latex source files
REM Usage: runAll <input_file>
REM where 
REM     <input_file> tex input file name without extention
pdflatex %1
bibtex %1
makeglossaries %1
pdflatex %1
pdflatex %1
REM dvipdfmx %1
goto end
call cleanAll %1
:end