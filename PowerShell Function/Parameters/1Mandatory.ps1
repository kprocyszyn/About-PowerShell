function Get-Person {
    [cmdletbinding()]
    param (
        #[Parameter(Mandatory)]
        [string]$Surname,

        [string]$Firstname,

        #[Parameter(Mandatory)]
        [int]$Id,

        [switch]$All,

        [switch]$IncludeInactive,

        [string]$Region
    )

    $items = [System.Collections.Generic.List[pscustomobject]]::new()
    $data = Import-PowerShellDataFile -Path "$PSScriptRoot\data.psd1"
    $users = $data.users

    if (!($IncludeInactive.IsPresent)) {
        $users = $users | Where-Object {$_.Active -eq $true}
    }

    if ($PSBoundParameters.ContainsKey('Region')) {
        $users = $users | Where-Object {$_.Region -eq $Region}
    } 

    foreach ($u in $users) {
        $items.Add([pscustomobject]$u)
    }

    if ($PSBoundParameters.ContainsKey('All')) {
        return $items
    }

    if ($PSBoundParameters.ContainsKey('ID')) {
        return $items.Where({$_.ID -eq $Id})
    }

    if ($PSBoundParameters.ContainsKey('Surname')) {

        if ($PSBoundParameters.ContainsKey("Firstname")) {
            return $items.Where( { $_.Surname -eq $Surname -and $_.FirstName -eq $Firstname })
        }
        else {
            return $items.Where( { $_.Surname -eq $Surname })
        }
    }
}