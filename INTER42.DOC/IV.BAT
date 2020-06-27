@ECHO OFF
REM if you are using a DOS version prior to 3.30, remove the @ above
IF NOT "%INTERVUE%" == "" SET __DIR=%INTERVUE%\
IF EXIST %__DIR%INTERRUP.SUM GOTO RUN
IF EXIST %__DIR%INTERRUP.? GOTO CREATE
ECHO Could not find Interrupt List files.
GOTO END

:CREATE
ECHO Creating index, please wait....
INTPRINT -s%__DIR%INTERRUP.SUM -m -I %__DIR%INTERRUP.A NUL
:RUN
INTERVUE
:END
SET __DIR=
