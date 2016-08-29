<#
Shortcut for jumping to GOPATH workspace
#>
function GoHome()
{
    . cd $env:GOPATH;
}
Set-Alias go.home GoHome;


<#
Runs go commands like build, install, or test that all share a common execution pattern. 
Will not be exported by default: (Export-ModuleMember -Alias * -Function Go*;)
#>
function RunPackageCommand([string]$Operation, [string]$PackageName, [string]$PackagePath)
{
    #Change adjust this to match src package path between GOPATH (workspace) and package dir
    $defaultPackagePath = "github.com\alockwood\";

    #Modify this list to add or remove support for go commands that follow the pattern of install, build, test...
    $supportedOperations = "build", "install", "test";

    if(!([string]::IsNullOrEmpty($Operation)))
    {
        $Operation = $Operation.ToLowerInvariant();
    }
    else
    {
        Write-Host "Operation must be specified!" -ForegroundColor Red;
        Exit;
    }

    if ($Operation -notin $supportedOperations)
    {
        Write-Host "Only the following operations are supported: $supportedOperations" -ForegroundColor Red;
        Exit;
    }

    if ([string]::IsNullOrEmpty($PackageName))
    {
        Write-Host "Must provide a package to $operation." -ForegroundColor Red;
        Exit;
    }

    if ([string]::IsNullOrEmpty($PackagePath))
    {
        $PackagePath = $defaultPackagePath;
    }

    . go $Operation (Join-Path -Path $PackagePath -ChildPath $PackageName);
};


<#
Shortcut for installing go packages.
Like the go install command the result is either no output (success) or an error (failure).
#>
function GoInstall ($PackageName, $PackagePath)
{
    RunPackageCommand -Operation "install" -PackageName $PackageName -PackagePath $PackagePath;
}
Set-Alias go.install GoInstall;


<#
Shortcut for building go packages.
Like the go build command the result is either no output (success) or an error (failure).
#>
function GoBuild ($PackageName, $PackagePath)
{
    RunPackageCommand -Operation "build" -PackageName $PackageName -PackagePath $PackagePath;
}
Set-Alias go.build GoBuild;


<#
Shortcut for testing go packages.
#>
function GoTest ($PackageName, $PackagePath)
{
    RunPackageCommand -Operation "test" -PackageName $PackageName -PackagePath $PackagePath;
}
Set-Alias go.test GoTest;




#Ensures the aliases are set
Export-ModuleMember -Alias * -Function Go*;