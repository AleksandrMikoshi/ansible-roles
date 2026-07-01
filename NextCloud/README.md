# Nextcloud Upgrade Ansible Role


[Русский язык](https://github.com/AleksandrMikoshi/ansible-roles/blob/main/NextCloud/Readme_ru.md) 


Ansible role for upgrading an existing self-hosted Nextcloud installation.

The role downloads a specified Nextcloud release, prepares a new installation directory, preserves the existing configuration, switches the active installation using a symbolic link, performs the database upgrade, and restores the service.

## Actions to be performed

* 📥 Downloads the requested Nextcloud release
* 📦 Extracts the archive on the remote host
* ⚙️ Preserves the current configuration
* 🛠 Enables maintenance mode before the upgrade
* 🌐 Stops Apache during the upgrade
* 🔗 Preserves the external applications directory using a symbolic link
* 🔄 Switches the active installation to the new version
* 🚀 Restarts PHP-FPM
* 🗄 Runs `occ upgrade`
* ✅ Disables maintenance mode
* 🧹 Removes temporary installation files

## Directory Structure

```text
nextcloud/
├── group_vars/
│   └── all.yml
├── nextcloud.yml
└── nextcloud/
    └── tasks/
        ├── main.yml
        └── Update_service.yml
```

## Requirements

* Ansible 2.12 or later
* Linux server
* Apache HTTP Server
* PHP-FPM
* Existing Nextcloud installation
* PHP CLI installed
* `www-data` user
* Existing external apps directory

## Variables

| Variable | Description | Default |
| --- | --- | --- |
| `nextcloud_version` | Nextcloud version to install | `34.0.0` |
| `nextcloud_user` | User executing OCC commands | `www-data` |
| `nextcloud_base_path` | Base installation directory | `/var/www` |
| `nextcloud_current_path` | Symlink to the active installation | `/var/www/nextcloud` |
| `nextcloud_new_path` | Directory for the new version | `/var/www/{{ nextcloud_version }}` |
| `apps_path` | External applications directory | `/var/www/nextcloud_apps` |
| `download_url` | Official download URL | Generated automatically |
| `php_service` | PHP-FPM service name | `php8.3-fpm.service` |

## Playbook

```yaml
- name: Upgrade Nextcloud
  hosts: host_group
  become: true

  roles:
    - nextcloud
```

## Run

```bash
ansible-playbook nextcloud.yml --tags update_service
```

## Upgrade Process

The role performs the following steps:

1. Download the specified Nextcloud release.
2. Extract the archive.
3. Move the extracted directory into the versioned installation path.
4. Copy the existing configuration.
5. Enable maintenance mode.
6. Stop Apache.
7. Apply ownership and permissions.
8. Replace the bundled `apps` directory with a symbolic link.
9. Update the `nextcloud` symbolic link to point to the new version.
10. Start Apache.
11. Restart PHP-FPM.
12. Execute `occ upgrade`.
13. Disable maintenance mode.
14. Remove temporary files.

## Expected installation structure

The role is designed for the following file layout:

```text
/var/www/
├── nextcloud -> /var/www/34.0.0
├── 34.0.0/
├── nextcloud_apps/
└── nextcloud_data/
```

The `nextcloud` directory is a symbolic link to the active version of the application.

## Notes

* The role assumes that `/var/www/nextcloud` is a symbolic link to the active installation.
* The applications directory is stored outside the installation directory and linked through `apps`.
* The `data` directory is not modified.
* Create a backup of the database and the `data` directory before running an upgrade.
* The role is intended for upgrading an existing installation and does not perform a fresh installation.

## License

MIT
