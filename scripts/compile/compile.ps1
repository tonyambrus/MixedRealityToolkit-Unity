Param(
	$defines = "WINDOWS_UWP UNITY_EDITOR UNITY_WSA",
	$configuration = "Debug",
	$filterDir = "MRTK",
	$pluginsDir = "MRTK\Plugins"
)

# Add this location to the path as NuGet.exe may be installed here
$env:PATH = "$($env:Path);$((Get-Location).Path)"

# Check if NuGet.exe is in the environment PATH, if not go ahead and install it to this directory
where.exe nuget > $null 2> $null
if ($lastexitcode -ne 0) {
    Write-Host "Could not find NuGet.exe in the path. Downloading it now from: https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
    Invoke-WebRequest -Uri "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile ".\nuget.exe"
}

. nuget install UnityPrecompiler -OutputDirectory UnityPrecompiler

$srcProjectDir = [IO.Path]::GetFullPath([io.path]::Combine((Get-location).Path, "..\.."));
$dstProjectDir = [IO.Path]::GetFullPath([io.path]::Combine($srcProjectDir, "..\compiled"));


$unityPrecompiler = (gci -Filter "UnityPrecompiler.exe" -Recurse )[-1].FullName
#$unityPrecompiler = "D:\Code\Experiments\unity-precompiler\bin\Debug\UnityPrecompiler.exe";

echo "$unityPrecompiler all -s $srcProjectDir -d $dstProjectDir -# $defines -c $configuration -f $filterDir -p $pluginsDir"
. $unityPrecompiler all -s $srcProjectDir -d $dstProjectDir -# $defines -c $configuration -f $filterDir -p $pluginsDir