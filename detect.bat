@echo off

setlocal EnableDelayedExpansion

set index=0
for /f "tokens=1-4" %%a in ('wmic memorychip get Capacity^,FormFactor^,MemoryType^,Speed /format:table') do (
  if !index! neq 0 (
    set RAM_Capacity[!index!]=%%a 
    set RAM_FormFactor[!index!]=%%b
    set RAM_MemoryType[!index!]=%%c
    set RAM_Speed[!index!]=%%d
  )
  set /a index+=1
)

echo Información del procesador:
echo ------------------------------------
for /f "tokens=1-2 delims==" %%a in ('wmic cpu get name^,NumberOfCores^,MaxClockSpeed^,Manufacturer /format:value') do (
    if "%%a"=="Manufacturer" set manufacturer=%%b
    if "%%a"=="Name" set name=%%b
    if "%%a"=="NumberOfCores" set cores=%%b
    if "%%a"=="MaxClockSpeed" set speed=%%b
)



set RAM_Count=%index%

echo Información de la memoria RAM:
echo ------------------------------------
for /l %%i in (1,1,%RAM_Count%) do (
  echo Módulo [%%i]:
  echo Capacidad: !RAM_Capacity[%%i]! bytes
  echo Factor de forma: !RAM_FormFactor[%%i]!
  echo Tipo de memoria: !RAM_MemoryType[%%i]!
  echo Velocidad: !RAM_Speed[%%i]! MHz
  echo.
)

echo info de procesador
echo Fabricante: %manufacturer%
echo Modelo: %name%
echo Número de núcleos: %cores%
echo Velocidad: %speed% MHz

pause