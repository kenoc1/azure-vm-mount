param (
  [string]$storageAccountName,
  [string]$fileShareName,
  [string]$storageAccountKeys
)

param (
  [string]$storageAccountName,
  [string]$fileShareName,
  [string]$storageAccountKeys
)

$connectTestResult = Test-NetConnection -ComputerName $("$storageAccountName.file.core.windows.net") -Port 445

if ($connectTestResult.TcpTestSucceeded) {
  $password = ConvertTo-SecureString -String $storageAccountKeys -AsPlainText -Force
  $credential = New-Object System.Management.Automation.PSCredential -ArgumentList "localhost\$($storageAccountName)", $password
  New-PSDrive -Persist -Name Z -PSProvider FileSystem -Root "\\$($storageAccountName).file.core.windows.net\$($fileShareName)" -Credential $credential -Scope Global
}
else {
  Write-Output "Unable to reach the Azure storage account via port 445. Please check your network connection." | Out-File C:\FileShareMount.txt -Append
}

# if ($connectTestResult.TcpTestSucceeded) {
#     # Save the password so the drive will persist on reboot
#     $password = ConvertTo-SecureString -String $storageAccountKeys -AsPlainText -Force
#     $credentialString = "`"$storageAccountName.file.core.windows.net`" /user:`"localhost\$storageAccountName`" /pass:`"$password`""
#     cmd.exe /C "cmdkey /add:$credentialString"
    
#     # Mount the drive
#     New-PSDrive -Name I -PSProvider FileSystem -Root "\\$($storageAccountName).file.core.windows.net\$($fileShareName)" -Persist -Scope Global
# } else {
#     Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
# }
