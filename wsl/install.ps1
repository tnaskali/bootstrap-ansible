<#
.SYNOPSIS
  Install and configure Ubuntu 22.04 under WSL on a local Windows machine,
  write an embedded cloud-init user-data for first-run configuration,
  create a "runner" user with passwordless sudo, and set WSL-related environment forwarding.

.NOTES
  - Run this script from an elevated PowerShell (Run as Administrator) for the automated experience.
  - If you prefer to supply your own cloud-init file, provide its path with -CloudInitSource.
  - cloud-init documentation: https://documentation.ubuntu.com/wsl/latest/howto/cloud-init/
#>

# Prepare cloud-init user-data
$cloudInitPath = "$env:USERPROFILE\.cloud-init"
New-Item -ItemType Directory -Path $cloudInitPath -Force | Out-Null

# get the current user name
$currentUser = $env:USERNAME
# get the current user full name
$currentUserFullName = (Get-LocalUser -Name $currentUser).FullName

@"
#cloud-config
users:
  - name: $currentUser
    gecos: $currentUserFullName
    primary_group: $currentUser
    groups: [sudo]
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash

write_files:
  - path: /etc/wsl.conf
    content: |
      [boot]
      systemd=true
      [user]
      default=$currentUser

packages:
  - dos2unix
  - python3-pip
  - python3-venv
"@ | Set-Content -Path "$cloudInitPath\Ubuntu.user-data"

# wsl --install Ubuntu
winget install --id 9pdxgncfsczv --exact --source msstore --accept-source-agreements --accept-package-agreements

ubuntu install
