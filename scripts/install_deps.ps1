Write-Host "Installing deps."


# ---- Rust installation
Write-Host "Installing Rust..." -ForegroundColor Cyan
$exePath = "$env:TEMP\rustup-init.exe"

Write-Host "Downloading..."
(New-Object Net.WebClient).DownloadFile('https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe', $exePath)

Write-Host "Installing..."
cmd /c start /wait $exePath -y
Remove-Item $exePath

$env:Path = "$env:USERPROFILE\.cargo\bin"

cargo --version
rustup --version
rustc --version

Write-Host "Rust installed" -ForegroundColor Green
# ---- End rust installation

# Cmake

Write-Host "Installing Cmake..." -ForegroundColor Cyan
$exePath = "$env:TEMP\cmake.exe"

Write-Host "Downloading..."
(New-Object Net.WebClient).DownloadFile('https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0-windows-x86_64.msi', $exePath)

Write-Host "Installing..."
MsiExec.exe /i $exePath ADD_CMAKE_TO_PATH=User /qn