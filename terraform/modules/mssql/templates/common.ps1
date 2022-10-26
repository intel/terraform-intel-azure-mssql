Start-Transcript
###### DISABLE LEGACY Triple Des 168 CIPHER ######
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\" -Name 'Triple DES 168'
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168" -Name "Enabled" -Value 0 -PropertyType "DWord"

###### Set PowerShell as default command shell  ######
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

###### SSH for Ansible automatization ############
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service -Name sshd -StartupType Automatic
Start-Service sshd
(Get-Content C:\ProgramData\ssh\sshd_config).replace("#PasswordAuthentication yes","PasswordAuthentication no") | Set-Content "C:\ProgramData\ssh\sshd_config"
Restart-Service sshd

###### INJECT SSH KEYS ######
"${key}`r`n" | Out-File -FilePath "C:\ProgramData\ssh\administrators_authorized_keys" -Encoding ASCII
$acl = Get-Acl C:\ProgramData\ssh\administrators_authorized_keys
$acl.SetAccessRuleProtection($true, $false)
$administratorsRule = New-Object system.security.accesscontrol.filesystemaccessrule("Administrators","FullControl","Allow")
$systemRule = New-Object system.security.accesscontrol.filesystemaccessrule("SYSTEM","FullControl","Allow")
$acl.SetAccessRule($administratorsRule)
$acl.SetAccessRule($systemRule)
$acl | Set-Acl

Stop-Transcript