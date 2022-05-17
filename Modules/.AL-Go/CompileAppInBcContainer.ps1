Param(
    [Hashtable] $parameters
)

$appFile = Compile-AppInBcContainer @parameters

if ($appFile) {
    $filename = [System.IO.Path]::GetFileName($appFile)
    if ($filename -like "Microsoft_System Application_*.*.*.*.app") {
        # System application compiled - add BaseApp and Application app from container to output
        Invoke-ScriptInBcContainer -containerName $parameters.ContainerName -scriptblock { Param([string]$packagesFolder)
            $baseApp = "C:\Applications.*\Microsoft_Base Application_*.*.*.*.app"
            $application = "C:\Applications.*\Microsoft_Application_*.*.*.*.app"
            if (-not (Test-Path $baseApp)) {
                $baseApp = "C:\Applications\BaseApp\Source\Microsoft_Base Application.app"
            }
            if (-not (Test-Path $application)) {
                $application = "C:\Applications\Application\Source\Microsoft_Application.app"
            }
            Write-Host "Copying Base Application to packages path"
            Copy-Item -Path $baseApp -Destination (Join-Path $packagesFolder "Microsoft_Base Application.app")
            
            Write-Host "Copying Application to packages path"
            Copy-Item -Path $application -Destination (Join-Path $packagesFolder "Microsoft_Application.app")
        } -argumentList (Get-BcContainerPath -ContainerName $parameters.ContainerName -path $Parameters.appSymbolsFolder)
    }
}
$appFile
