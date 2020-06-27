@echo off
for %%a in (a b c d e f g h i j k l) do if not exist interrup.%%a goto missing
echo Combining the pieces of the interrupt list
echo.
copy interrup.a interrup.lst >nul
for %%a in (b c d e f g h i j k l) do copy /b interrup.lst+interrup.%%a interrup.lst >nul
echo The interrupt list has now been combined into INTERRUP.LST
goto end

:missing
echo Some sections of the interrupt list are missing.
goto end

:end
