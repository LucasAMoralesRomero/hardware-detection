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
) else (
    set bluetoothManufacturer=0
    set bluetoothName=0
)

REM informacion del sistema operativo
for /f "usebackq tokens=4 delims=] " %%a in (`ver`) do set versionOS=%%a

REM creacion del JSON

set "json={"

set "json=!json!"version_SO":"%versionOS%","

set "json=!json!"wi_fi_nombre":"%wifi_name%","
set "json=!json!"wi_fi_fabricante":"%wifi_manufacturer%","

set "json=!json!"bluetooth_nombre":"%bluetoothName%","
set "json=!json!"bluetooth_fabricante":"%bluetoothManufacturer%","

set "json=!json!"video_nombre":"%videoName%","
set "json=!json!"video_memoria":"%videoMemory% bytes","
set "json=!json!"video_procesador":"%videoProcessor%","

set "json=!json!"disco1_marca":"%diskCaption1%","
set "json=!json!"disco1_tamaño":"%diskSize1%","

set "json=!json!"disco2_marca":"%diskCaption2%","
set "json=!json!"disco2_tamaño":"%diskSize2%","

set "json=!json!"procesador_fabricante":"%manufacturer%","
set "json=!json!"procesador_modelo":"%name%","
set "json=!json!"procesador_núcleos":"%cores%","
set "json=!json!"procesador_velocidad":"%speed% MHz","

set "json=!json!"memoria_ram": ["
set RAM_Count=%index%.
for /l %%i in (1,1,%RAM_Count%) do (
  set "json=!json!{"
  set "json=!json!"capacidad":"!RAM_Capacity[%%i]! bytes","
  set "json=!json!"factor_forma":"!RAM_FormFactor[%%i]!","
  set "json=!json!"tipo_memoria":"!RAM_MemoryType[%%i]!","
  set "json=!json!"velocidad":"!RAM_Speed[%%i]!""
  set "json=!json!},"
)

rem quitar la coma extra al final del último elemento de la lista de memoria RAM
set "json=!json:~0,-1!"

set "json=!json!]"
set "json=!json!}"

echo %json% > hardware.json
