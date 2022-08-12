Write-Host "Installing deps."

# ---- Flutter installation
Write-Host "Installing Flutter..." -ForegroundColor Cyan
$zipFile = "$env:TEMP\flutter.zip"

Write-Host "Downloading..."
(New-Object Net.WebClient).DownloadFile('https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.0.5-stable.zip', $zipFile)

Write-Host "Unzipping..."
Expand-Archive -Path "$zipFile" -DestinationPath "C:\src\flutter" -Verbose

[Environment]::SetEnvironmentVariable('PATH', 'C:\src\flutter\flutter\bin;' + $env:PATH, 'Machine')

flutter --version

# ---- Cmake installation
Write-Host "Installing Cmake..." -ForegroundColor Cyan
$exePath = "$env:TEMP\cmake.msi"

Write-Host "Downloading..."
(New-Object Net.WebClient).DownloadFile('https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0-windows-x86_64.msi', $exePath)

Write-Host "Installing..."
#msiexec.exe /i $exePath ADD_CMAKE_TO_PATH=User /qn | Out-Null
Start-Process msiexec.exe -ArgumentList "/i $exePath ADD_CMAKE_TO_PATH=User /qn" -Wait

foreach($level in "Machine","User") {
   [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
      # For Path variables, append the new values, if they're not already in there
      if($_.Name -match 'Path$') { 
         $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
      }
      $_
   } | Set-Content -Path { "Env:$($_.Name)" }
}

cmake --version

# ---- Git For Windows Installation
Write-Host "Installing Git for windows..." -ForegroundColor Cyan
$exePath = "$env:TEMP\git.exe"

Write-Host "Downloading..."
(New-Object Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.37.1.windows.1/Git-2.37.1-64-bit.exe', $exePath)

Write-Host "Installing..."
Start-Process $exePath -Wait -ArgumentList '/NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh" /LOG="C:\git-for-windows.log"'

foreach($level in "Machine","User") {
   [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
      # For Path variables, append the new values, if they're not already in there
      if($_.Name -match 'Path$') { 
         $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
      }
      $_
   } | Set-Content -Path { "Env:$($_.Name)" }
}

git --version
bash --version

# ---- Rust installation
Write-Host "Installing Rust..." -ForegroundColor Cyan
$exePath = "$env:TEMP\rustup-init.exe"

Write-Host "Downloading..."
(New-Object Net.WebClient).DownloadFile('https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe', $exePath)

Write-Host "Installing..."
cmd /c start /wait $exePath -y
Remove-Item $exePath

#$env:Path = "$env:USERPROFILE\.cargo\bin"
[Environment]::SetEnvironmentVariable('PATH', $env:PATH, "USERPROFILE\.cargo\bin")

cargo --version
rustup --version
rustc --version

Write-Host "Rust installed" -ForegroundColor Green
