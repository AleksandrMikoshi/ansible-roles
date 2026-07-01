# Kaspersky Security Installation


[Русский язык](https://github.com/AleksandrMikoshi/ansible-roles/blob/main/Kaspersky/Readme_ru.md) 


Automation tools for deploying **Kaspersky Security Center Network Agent** and **Kaspersky Endpoint Security** on Linux and Windows systems.

This project includes:

* **Ansible role** for automated deployment on Debian/Ubuntu, Red Hat/CentOS, and Windows.
* **Standalone Bash script** for installing Kaspersky Endpoint Security on CentOS systems over SSH.

## Features

* 🖥️ Supports multiple operating systems:

  * Debian / Ubuntu
  * Red Hat / CentOS
  * Windows
* 📥 Downloads installation packages directly from the Kaspersky Security Center distribution server.
* 🔍 Detects existing installations and skips already protected hosts.
* ⚙️ Installs both:

  * Kaspersky Security Center Network Agent
  * Kaspersky Endpoint Security
* 🧹 Cleans temporary installation files after installation.
* 🔄 Automatically reboots Windows hosts after installation.
* 🖥️ Includes a standalone Bash installer for CentOS environments where Ansible is not available.

## Repository Structure

```text
kaspersky/
├── kaspersky.yml
└── scripts/
│   └── install_kaspersky_centos.sh
└── kaspersky/
    ├── tasks/
    │   ├── main.yml
    │   ├── Debian.yml
    │   ├── RedHat.yml
    │   └── Windows.yml
    └── vars/
        ├── main.yml
        ├── Debian.yml
        ├── RedHat.yml
        └── Windows.yml
```

## Supported Platforms

| Platform | Ansible Role | Bash Script |
| --- | --- | --- |
| Ubuntu | ✅ | ❌ |
| Debian | ✅ | ❌ |
| RHEL | ✅ | ❌ |
| CentOS | ✅ | ✅ |
| Windows | ✅ | ❌ |

## Requirements

### Ansible Role

* Ansible 2.12+
* SSH access for Linux hosts
* WinRM access for Windows hosts
* Administrative privileges (`become` or Administrator)
* Access to the Kaspersky Security Center package distribution server

### Bash Script

* Bash
* SSH access to target hosts
* `wget`
* `curl`
* `yum`
* Root privileges (or passwordless `sudo`)
* SSH key or password authentication

## Configuration

The Ansible role uses variables defined in the `vars` directory.

Important variables include:

| Variable | Description |
| --- | --- |
| `kes_url` | Base URL of the Kaspersky package distribution server |
| `deb_agent_id` | Debian/Ubuntu Network Agent package ID |
| `deb_antivirus_id` | Debian/Ubuntu Endpoint Security package ID |
| `rpm_agent_id` | RHEL/CentOS Network Agent package ID |
| `rpm_antivirus_id` | RHEL/CentOS Endpoint Security package ID |
| `windows_installer` | Windows installer package ID |

## Using the Ansible Role

Run the playbook:

```bash
ansible-playbook kaspersky.yml
```

The role automatically:

* detects the operating system;
* downloads the required packages;
* installs the Network Agent;
* installs Kaspersky Endpoint Security;
* removes temporary installation files;
* reboots Windows hosts if required.

## Using the Bash Script

The repository also includes a standalone Bash installer:

```bash
chmod +x install_kaspersky_centos.sh
./install_kaspersky_centos.sh
```

Before running the script, configure:

* target hosts (`HOSTS`);
* SSH user;
* SSH key (optional);
* Kaspersky package URLs.

The script performs the following operations:

1. Connects to each host over SSH.
2. Checks whether Kaspersky Endpoint Security is already installed.
3. Verifies package availability.
4. Installs required system packages.
5. Configures the Russian locale if necessary.
6. Installs the Network Agent.
7. Installs Kaspersky Endpoint Security.
8. Removes temporary installation files.
9. Displays installation status for each host.

## Notes

* Installation packages are downloaded from an internal Kaspersky Security Center distribution server.
* Existing installations are automatically skipped.
* The Windows role performs an automatic reboot after installation.
* The Bash script is intended for environments where Ansible is unavailable or not yet configured.

## License

MIT License.
