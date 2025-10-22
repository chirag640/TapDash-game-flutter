# Keystore helpers

This document shows common commands for creating, inspecting, and encoding an Android keystore for use with the CI workflow.

## Inspect existing keystore

To list aliases inside a keystore (PowerShell / cmd):

```powershell
keytool -list -v -keystore .\codemagic.keystore
```

If the alias already exists and you want to delete it, you generally need to recreate the keystore or create a new alias (keytool does not support removing single key pairs from JKS reliably across all Java versions).

## Generate a new keystore

Use this command (PowerShell / cmd):

```powershell
keytool -genkeypair -v -keystore codemagic.keystore -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias codemagic_new
```

If alias `codemagic` already exists in the same keystore, pick a new alias (e.g. `codemagic_v2`) or remove/rename the previous keystore file.

## Encode keystore to Base64 for GitHub Secrets

On Windows (PowerShell):

```powershell
$bytes = [System.IO.File]::ReadAllBytes("codemagic.keystore")
[System.Convert]::ToBase64String($bytes) | Out-File -Encoding ASCII keystore.b64
Get-Content keystore.b64 -Raw
```

On Linux/macOS:

```bash
base64 codemagic.keystore > keystore.b64
cat keystore.b64
```

Copy the single-line Base64 string to your GitHub repository secret `KEYSTORE_BASE64`.

## GitHub Secrets to set

- `KEYSTORE_BASE64`: Base64 encoded keystore content
- `KEYSTORE_PASSWORD`: Keystore password
- `KEY_ALIAS`: Key alias (e.g. `codemagic`)
- `KEY_PASSWORD`: Key password (if different from keystore password)

If you don't provide `KEYSTORE_BASE64`, the workflow will still produce unsigned APKs which can be installed locally (useful for testing).

## Re-create keystore if alias exists

If you receive `alias already exists`, either:

- Choose a new alias when generating with `-alias`, or
- Delete the existing keystore file and create a new one (if not needed):

```powershell
Remove-Item .\codemagic.keystore
```

Or move it aside:

```powershell
Rename-Item .\codemagic.keystore codemagic.keystore.bak
```


## Troubleshooting

- If `keytool` isn't found, ensure Java JDK is installed and `keytool` is on PATH.
- To view the store's entries with their validity dates and fingerprints, use the `-list -v` command.
