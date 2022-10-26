###### FETCH ADMINISTRATOR PASSWORD AND NEW USERNAME FROM SECRETS MANAGER ######
$sec = Get-SECSecretValue -SecretId ${secret_arn}
$pass = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($sec.SecretString))
$secPass = ConvertTo-SecureString $pass -AsPlainText -Force
###### MODIFY ADMINISTRATOR PROFILE PATH ######
Get-ChildItem 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList' | % { Get-ItemProperty $_.pspath } | Where-Object ProfileImagePath -eq "C:\Users\Administrator" | Set-ItemProperty -Name ProfileImagePath -value "C:\Users\${admin_username}"
###### MOVE ADMINISTRATOR FOLDER TO NEW DIRECTORY #######
Rename-Item -Path "C:\Users\Administrator" -NewName "C:\Users\testadmin" -Force
###### RENAME ADMINISTRATOR TO OUR REQUESTED USERNAME ######
Rename-LocalUser -Name "Administrator" -NewName "${admin_username}"
###### CHANGE NEW ADMINISTRATOR PASSWORD TO WHAT WE WANT ######
Set-LocalUser -Name "${admin_username}" -Password $secPass
