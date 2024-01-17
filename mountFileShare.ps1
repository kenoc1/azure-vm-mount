param (
  [string]$storageAccountName
  [string]$fileShareName
  [string]$storageAccountKeys
)

$connectTestResult = Test-NetConnection -ComputerName $("$storageAccountName.file.core.windows.net") -Port 445

if ($connectTestResult.TcpTestSucceeded) {
  $password = ConvertTo-SecureString -String $storageAccountKeys -AsPlainText -Force
  $credential = New-Object System.Management.Automation.PSCredential -ArgumentList "AZURE\$($storageAccountName)", $password
  New-PSDrive -Persist -Name Z -PSProvider FileSystem -Root "\\$($storageAccountName).file.core.windows.net\$($fileShareName)" -Credential $credential -Scope Global
}
else {
  Write-Output "Unable to reach the Azure storage account via port 445. Please check your network connection." | Out-File C:\FileShareMount.txt -Append
}
