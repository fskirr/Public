import-module DataProtectionManager
$dpmserver = ''
$dpmserver = connect-dpmserver -DPMServerName "SRV-BKP01.ribigua.com.br" -WarningAction:SilentlyContinue
Start-sleep -Seconds 2
$dpmserver.alertcontroller.refreshalerts()
Start-sleep -Seconds 10
$alerts = @($dpmserver.AlertController.ActiveAlerts.Values)
$warnings = $alerts | where-object {$_.Severity -eq “Warning”} | Measure-Object | select count 
$errors = $alerts | where-object {$_.Severity -like “Error”} | Measure-Object | select count 
#
if ($errors.count -ne 0) {
$status = $returnCode
$returnCode = 2
}
elseif ($warnings.count -ne 0) {
$status = $returnCode
$returnCode = 1
}
else {
$status = $returnCode
$returnCode = 0
}

& 'C:\IP5Watch\bin\zabbix_sender.exe' -z monitoramento.ip5tecnologia.com.br -p 10051 -s RIBiguacu-SRV-BKP01  -k dpmstatus -o $returnCode  >> C:\temp\Script\sender.txt



