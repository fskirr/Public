Clear-Host

$Vms = Get-VM 
$VMArray = @{ }
$CountArray = 0
$ResultadoSnap = 0
ForEach ($Vm in $Vms) {
    $VMSnap = (Get-VMSnapshot -VMName $Vm.name | Select-Object VMName, Name, SnapshotType, CreationTime, ComputerName)

    IF (($null -ne $VMSnap.CreationTime ) -and ($VMSnap.SnapshotType -eq 'Standard')-and ($ResultadoSnap -lt 3)) {
        $TempoSnap = new-timespan $VMSnap.CreationTime (get-date)
        $VMArray[$Vm.name] += @{NomeVM = $VMSnap.VMName; NomeSnap = $VMSnap.Name; Tipo = $VMSnap.SnapshotType; Data = $VMSnap.CreationTime; Host = $VMSnap.ComputerName; Tempo = $temposnap; }
        
        switch (($VMArray[$Vm.name].tempo.minutes)) {
            { $_ -lt 3 }  { if ($ResultadoSnap -lt 2) {$ResultadoSnap = 1}}
            { $_ -ge 3 -and $_ -lt 5 } { if ($ResultadoSnap -lt 3) {$ResultadoSnap = 2}}
            { $_ -ge 5 } { $ResultadoSnap = 3}
        } 
        $CountArray += 1
    }
    $VMSnap = ""
}
Write-Host $ResultadoSnap