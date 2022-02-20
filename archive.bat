<# : batch portion (contained within a PowerShell multi-line comment)
@echo off & setlocal

echo abcd

set "JSON={ "year": 2016, "mobileapp":"mobileapp", "android":"android", "ios":"ios", "abcd1":"abcd1" }"
set "JSONDES={ "2016": "2016 is a year", "mobileapp":"mobileapp is a mobile app", "android":"android is an app runs on android", "ios":"ios is an apple mobile app", "abcd1":"abcd1 is abcd1" }"
rem # re-eval self with PowerShell and capture results
for /f "delims=" %%I in ('powershell "iex (${%~f0} | out-string)"') do set "%%~I"

rem # output captured results
set JSON[
set JSONDES[
rem # end main runtime
goto :EOF

: end batch / begin PowerShell hybrid code #>

add-type -AssemblyName System.Web.Extensions
$JSON = new-object Web.Script.Serialization.JavaScriptSerializer
$obj = $JSON.DeserializeObject($env:JSON)
$JSONDES = new-object Web.Script.Serialization.JavaScriptSerializer
$objdes = $JSON.DeserializeObject($env:JSONDES)

$str="nnnn111111"
# output object in key=value format to be captured by Batch "for /f" loop
#foreach ($key in $obj.keys) { mkdir $key;"JSON[{0}]={1}" -f $key, $obj[$key]}
#foreach ($key in $obj.keys) { mkdir $key }
foreach ($key in $obj.keys) {
#$str="acddd"
#Write-Host $str
$dirpath='public'+'\'+$key
New-Item -Path $dirpath -ItemType Directory 
$str='public\'+$key+'\'+'index'
$str1='public\'+$key+'\'+'readme'
New-Item -Path $str'.html'
New-Item -Path $str1'.md'
$content = '<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>'+$key+'</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>'+$obj[$key]+'
<script src="js/stmd.js"></script>
<script src="js/render.js"></script>
</script>
</body>
</html>' | out-file -filepath $str'.html' 

	foreach ($keydes in $objdes.keys) {
		if($key -eq $keydes){
			$content = $objdes[$keydes] | out-file -filepath $str1'.md' 
		}
	}
}



