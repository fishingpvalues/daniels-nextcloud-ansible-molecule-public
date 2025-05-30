# Nextcloud Le Potato Production Automation

## Step-by-Step Setup for Le Potato with Armbian

### 1. Download and Flash Armbian

- Download the latest Armbian image for your board: <https://www.armbian.com/download/>
- Flash the image to an SD card using [Balena Etcher](https://www.balena.io/etcher/) or similar.

### 2. First Boot: Basic OS Configuration

- Insert the SD card and power on your Le Potato.
- On first boot:
  - Set the **root password** when prompted.
  - Create a **normal user** (e.g., `daniel`) and set the password (`xxx`).
  - Confirm language and locale settings.
  - (Optional) Use `armbian-config` to transfer the OS to internal media (eMMC/SATA/USB) if desired.

### 3. Configure the System with `armbian-config`

- Log in as your user or root.
- Run:

  ```sh
  sudo armbian-config
  ```

- Recommended steps in armbian-config:
  - **System > Personal:** Change shell to ZSH if desired, enable 2FA for SSH, etc.
  - **Network:** Set up your network (static IP recommended for server use, e.g., `192.168.178.40`).
  - **Software:** You can skip most software installs here, as Ansible will handle everything.
  - **Other:** Set hostname (e.g., `lepotato`), timezone, etc.

### 4. Update the System

- After configuration, update your system:

  ```sh
  sudo apt update && sudo apt upgrade -y
  ```

### 5. Prepare for Ansible Automation

- Ensure your user (`daniel`) is in the `sudo` group:

  ```sh
  sudo usermod -aG sudo daniel
  ```

- (Optional) Set up SSH key authentication for easier Ansible use:

  ```sh
  ssh-copy-id daniel@192.168.178.40
  ```

- Verify you can SSH into the device:

  ```sh
  ssh daniel@192.168.178.40
  ```

### 6. Clone and Configure the Project

- On your control machine (PC/laptop):

  ```sh
  git clone https://github.com/fishingpvalues/daniels-nextcloud.git
  cd daniels-nextcloud
  ```

- Edit `ansible/inventory` if your Le Potato IP is different.

### 7. Run the Ansible Playbook

- From the `ansible` directory:

  ```sh
  cd ansible
  ansible-playbook -i inventory playbook.yml
  ```

- The playbook will:
  - Install and configure all required software (Nginx, PHP, Nextcloud, UFW, Fail2Ban, BorgBackup, Cockpit, Dashy, Netdata, etc.)
  - Mount your Fritz!NAS for backups
  - Set up backup and restore automation
  - Harden the system

### 8. Access Your Services

- **Nextcloud:** <http://nextcloud.fritz.box>
- **Cockpit:** <https://lepotato:9090>
- **Dashy:** <http://lepotato:4000>
- **Netdata:** <http://lepotato:19999>

### 9. Device Integration

- **Android/iOS:** Use the Nextcloud app, DAVx⁵ for calendar/contacts.
- **PC/Mac:** Use the Nextcloud desktop client.
- **All devices:** Connect to `http://nextcloud.fritz.box` (ensure your Fritz!Box assigns the correct local DNS name).

### 10. Backup & Restore

- Backups are encrypted and stored on Fritz!NAS.
- Restore via Cockpit terminal or:

  ```sh
  sudo /usr/local/bin/nextcloud-restore.sh
  ```

## Features

- Hardened Nextcloud on Nginx + PHP-FPM
- TLS via Let's Encrypt
- UFW & Fail2Ban (safe SSH)
- Encrypted, rotated backups to Fritz!NAS (Borg + GPG)
- Dashy dashboard (Docker)
- Cockpit & Netdata for system management/monitoring
- Disaster recovery scripts & Cockpit integration

## Quick Start

1. **Clone this repo:**

   ```sh
   git clone https://github.com/fishingpvalues/daniels-nextcloud.git
   cd daniels-nextcloud
   ```

2. **Edit Ansible inventory if needed:**
   - Default user: `daniel`, password: `nicepassword`, Le Potato IP: `192.168.178.40`
   - Edit `ansible/inventory` if your IP differs.
3. **Run the playbook:**

   ```sh
   cd ansible
   ansible-playbook -i inventory playbook.yml
   ```

4. **Access your services:**
   - Nextcloud: <http://nextcloud.fritz.box>
   - Cockpit: <https://lepotato:9090>
   - Dashy: <http://lepotato:4000>
   - Netdata: <http://lepotato:19999>

## Backup & Restore

- Backups are encrypted and stored on Fritz!NAS.
- Restore via Cockpit or `scripts/nextcloud-restore.sh`.

## Security

- UFW/Fail2Ban only allow local subnet (192.168.178.0/24)
- All credentials are stored securely and not world-readable.

## Customization

- All variables in `ansible/group_vars/all.yml`.
- Add more roles or monitoring as needed.

## Support

- For issues, open a GitHub issue or contact the maintainer.

## Local Testing & CI

This project uses GitHub Actions for CI, but you can run all checks locally using [act](https://github.com/nektos/act).

### Install requirements

- Python tools: `pip install -r requirements-dev.txt`
- [ShellCheck](https://www.shellcheck.net/): install via your package manager (e.g., `sudo apt install shellcheck`)
- [Hadolint](https://github.com/hadolint/hadolint): install via your package manager (e.g., `sudo apt install hadolint`)
- [act](https://github.com/nektos/act): see [installation instructions](https://github.com/nektos/act#installation)

### Run all checks locally

```sh
act -j ci
```

---
**Plug & Play. Secure. Automated.**

---
**Plug & Play. Secure. Automated.**
