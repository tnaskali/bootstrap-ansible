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

# Install Ubuntu 22.04 under WSL without launching it
wsl --install -d Ubuntu --no-launch

# Prepare cloud-init user-data
$cloudInitPath = "$env:USERPROFILE\.cloud-init"
New-Item -ItemType Directory -Path $cloudInitPath -Force | Out-Null

@"
#cloud-config
users:
  - name: ansible
    gecos: Ansible User
    primary_group: ansible
    groups: [sudo]
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash

write_files:
  - path: /etc/wsl.conf
    content: |
      [boot]
      systemd=true
      [network]
      generateResolvConf=false
  - path: /etc/resolv.conf
    content: |
      # CloudFlare DNS
      nameserver 1.1.1.1
      nameserver 1.0.0.1
      nameserver 2606:4700:4700::1111
      nameserver 2606:4700:4700::1001

packages:
  - dos2unix
EOT
"@ | Set-Content -Path "$cloudInitPath\Ubuntu.user-data"

ubuntu install
