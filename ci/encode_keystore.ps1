Param(
  [string]$KeystorePath = "codemagic.keystore",
  [string]$Output = "keystore.b64"
)

if (-not (Test-Path $KeystorePath)) {
  Write-Error "Keystore file not found at $KeystorePath"
  exit 1
}

$bytes = [System.IO.File]::ReadAllBytes($KeystorePath)
[System.Convert]::ToBase64String($bytes) | Out-File -Encoding ASCII $Output
Write-Output "Base64 saved to $Output"
