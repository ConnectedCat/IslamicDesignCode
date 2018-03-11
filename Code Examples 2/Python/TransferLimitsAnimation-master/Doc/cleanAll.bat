REM JZB20120926
REM A dos batch file to cleanup the directory after runAll
REM Use only if the document is almost done, interim files are useful for 
REM troubleshooting
REM Usage: cleanAll <input_file>
REM where 
REM   <input_file> tex input file name without extention
REM del %1.pdf
REM del %1.synctex
REM del %1.dvi
del %1.ps
del *.log
del *.aux
del *.bbl
del *.bbg
del *.blg
del *.idx
del *.ind
del *.ilg
del *.glo
del *.gls
del *.glg
del *.lof
del *.lot
del *.toc
del *.out
del *.bak
del *.sav
del *.tmp
del _temp.*
del *.lol
