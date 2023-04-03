@echo off

setlocal EnableDelayedExpansion
REM Informacion de memoria ram

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

REM Información del procesador:

for /f "tokens=1-2 delims==" %%a in ('wmic cpu get name^,NumberOfCores^,MaxClockSpeed^,Manufacturer /format:value') do (
    if "%%a"=="Manufacturer" set manufacturer=%%b
    if "%%a"=="Name" set name=%%b
    if "%%a"=="NumberOfCores" set cores=%%b
    if "%%a"=="MaxClockSpeed" set speed=%%b
)

REM Información de disco

set count=1

for /f "tokens=1-2 delims==" %%a in ('wmic diskdrive get caption^,size /format:value') do (
  if "%%a"=="Caption" (
    set diskCaption!count!=%%b
  )
  if "%%a"=="Size" (
    set diskSize!count!=%%b
    set /a count+=1
  )
)

REM informacion de placa de video

for /f "tokens=1-2 delims==" %%a in ('wmic path win32_VideoController get name^,adapterram^,VideoProcessor /format:list') do (
  if "%%a"=="AdapterRAM" set videoMemory=%%b
  if "%%a"=="Name" set videoName=%%b
  if "%%a"=="VideoProcessor" set videoProcessor=%%b
)

REM Informacion de adaptador wi fi

for /f "tokens=2 delims==" %%a in ('wmic nic where "NetEnabled='true' and PhysicalAdapter='true'" get "Name" /format:value') do set "wifi_name=%%a"
for /f "tokens=2 delims==" %%a in ('wmic nic where "NetEnabled='true' and PhysicalAdapter='true'" get "Manufacturer" /format:value') do set "wifi_manufacturer=%%a"

REM ver si tiene placa bt
REM si hay placa, uarda la informacion en las variables bluetoothManufacturer y bluetoothName, sino guarda 0 en las variables
for /f "tokens=3" %%a in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\bthport /v Start ^| findstr "REG_DWORD"') do set bluetooth=%%a

if "%bluetooth%"=="2" (
    for /f "tokens=2 delims== " %%a in ('wmic path win32_pnpentity where "deviceid like '%%BTHENUM%%'" get manufacturer /format:list ^| findstr /i "manufacturer"') do set "bluetoothManufacturer=%%a"
    for /f "tokens=2 delims== " %%a in ('wmic path win32_pnpentity where "deviceid like '%%BTHENUM%%'" get name /format:list ^| findstr /i "name"') do set "bluetoothName=%%a"
    echo Tienes una placa Bluetooth instalada.
) else (
    set bluetoothManufacturer=0
    set bluetoothName=0
    echo manufacturer !bluetoothManufacturer! name !bluetoothName!
)
echo --------------------
echo Informacion de wi fi 
echo --------------------------------
echo Nombre de la placa Wi-Fi: %wifi_name%
echo Fabricante de la placa Wi-Fi: %wifi_manufacturer%

echo Información de la placa de video:
echo ------------------------------------
echo Nombre: %videoName%
echo Memoria de video: %videoMemory% bytes
echo Procesador de video: %videoProcessor%
echo ..............................

echo Información del disco 1:
echo --------------------------
echo Marca: %diskCaption1%
echo Tamaño: %diskSize1%

echo Información del disco 2:
echo --------------------------
echo Marca: %diskCaption2%
echo Tamaño: %diskSize2%

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