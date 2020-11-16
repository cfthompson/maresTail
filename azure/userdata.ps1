Start-Transcript -Path "C:\UserData.log" -Append;

pwd;

echo "make logout-no-screenlock shortcut";
$ShortcutFile = "$env:Public\Desktop\NoLockLogout.lnk";
$WScriptShell = New-Object -ComObject WScript.Shell;
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile);
$Shortcut.TargetPath = "C:\Windows\System32\tscon.exe";
$Shortcut.Arguments = "%sessionname% /dest:console";
$Shortcut.Save();

echo "disable Securty Ehanced IE (doesn't seem to be working)";

$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0

Stop-Process -Name Explorer
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green

echo "install chocolatey";

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

echo "install and join vpn (to be implemented later)";

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object System.Net.WebClient
$wc.DownloadFile("https://download.zerotier.com/dist/ZeroTier%20One.msi", "zerotier.msi")

zerotier.msi /q /norestart;
#pass environement variable to the command to join vpn here

echo "Turn off windows firewall";

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False;

echo "Update profile content to explicitly import Choco";
$ChocoProfileValue = @'
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
'@

Set-Content -Path "$profile" -Value $ChocoProfileValue -Force

. $profile

echo "install vb-cable for sound (needs to be finished manually)";
#choco install -y vb-cable

wget https://download.vb-audio.com/Download_CABLE/VBCABLE_Driver_Pack43.zip -outfile vbcable.zip
 
Expand-Archive .\vbcable.zip

echo "install steam";
choco install -y steam;

echo "start audio"
Get-Service | Where {$_.Name -match "audio"} | start-service
Get-Service | Where {$_.Name -match "audio"} | set-service -StartupType "Automatic"

echo "install nvidia driver";

(New-Object Net.WebClient).DownloadFile("http://us.download.nvidia.com/tesla/425.25/425.25-tesla-desktop-win10-64bit-international.exe", "nvidia.exe");

nvidia.exe -s -noreboot -noeula -clean
#/y /q /norestart;

takeown /f C:\Windows\System32\Drivers\BasicDisplay.sys;
cacls C:\Windows\System32\Drivers\BasicDisplay.sys /G Administrator:F;
del C:\Windows\System32\Drivers\BasicDisplay.sys;

echo "done";
