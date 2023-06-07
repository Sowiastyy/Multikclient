@echo off
set fileName=game
set zipName=%fileName%.zip
set loveName=%fileName%.love
xcopy /S /E .\* .\temp
cd temp
powershell Compress-Archive -Path * -DestinationPath %zipName%
ren %zipName% %loveName%
rmdir /S /Q temp
