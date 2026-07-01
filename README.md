# Ansible Roles

A collection of reusable Ansible roles for automating Linux server administration and infrastructure management.

This repository contains Ansible roles developed to simplify system administration, software deployment, service configuration, and maintenance tasks. Each role is self-contained, configurable, and documented for easy integration into existing Ansible projects.

## Goals

* Automate repetitive administration tasks.
* Provide reusable and maintainable Ansible roles.
* Follow Ansible best practices whenever possible.
* Simplify infrastructure management.
* Keep personal automation projects in a single repository.

## Repository Structure

```text
.
├── nextcloud/
│   ├── group_vars/
│   ├── nextcloud.yml
│   ├── nextcloud/
│   └── README.md
│
├── kaspersky/
│   ├── kaspersky.yml
│   ├── scripts/
│   ├── kaspersky/
│   └── README.md
│
└── README.md
```

Each role contains its own documentation, variables, requirements, and usage examples.

## Available Roles

| Role | Description | Status |
| --- | --- | --- |
| `nextcloud` | Upgrade an existing Nextcloud installation with minimal downtime | ✅ |
| `kaspersky` | Deploy Kaspersky Security Center Network Agent and Kaspersky Endpoint Security on Linux and Windows | ✅ |

> More roles will be added over time.

## Requirements

* Ansible 2.12+
* Linux-based control node
* SSH access to Linux hosts
* WinRM access for Windows hosts (where applicable)
* A user with administrative privileges (`become`)

## Usage

Navigate to the desired role directory and follow the instructions provided in its `README.md`.

Example:

```bash
ansible-playbook nextcloud/nextcloud.yml
```

or

```bash
ansible-playbook kaspersky/kaspersky.yml
```

Each role provides its own configurable variables, requirements, and usage examples.

## Design Principles

The roles in this repository are developed with the following principles in mind:

* Modular design
* Readable project structure
* Configurable through variables
* Reusable across multiple environments
* Idempotent whenever possible
* Preference for built-in Ansible modules over `shell` and `command`
* Clear documentation for every role

## Roadmap

Planned additions include roles for:

* Apache and Nginx
* PHP and PHP-FPM
* Docker
* Databases
* Monitoring
* Backup automation
* CI/CD tools
* Security hardening
* Mail services
* Logging
* Other infrastructure services

## Contributing

Suggestions, improvements, and pull requests are welcome.

## License

This project is licensed under the MIT License.
