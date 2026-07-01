# Установка Kaspersky Security

Набор инструментов для автоматизированной установки **Kaspersky Security Center Network Agent** и **Kaspersky Endpoint Security** на серверы и рабочие станции под управлением Linux и Windows.

Проект включает в себя:

* **Ansible-роль** для автоматической установки на Debian/Ubuntu, Red Hat/CentOS и Windows.
* **Отдельный Bash-скрипт** для установки Kaspersky Endpoint Security на CentOS по SSH.

## Возможности

* 🖥️ Поддержка нескольких операционных систем:

  * Debian / Ubuntu
  * Red Hat / CentOS
  * Windows
* 📥 Загрузка установочных пакетов напрямую с сервера распространения Kaspersky Security Center.
* 🔍 Проверка наличия установленного Kaspersky и пропуск уже защищённых хостов.
* ⚙️ Автоматическая установка:

  * Kaspersky Security Center Network Agent;
  * Kaspersky Endpoint Security.
* 🧹 Очистка временных файлов после завершения установки.
* 🔄 Автоматическая перезагрузка Windows после установки.
* 🖥️ Наличие отдельного Bash-скрипта для установки на CentOS в средах, где Ansible не используется.

## Структура репозитория

```text
kaspersky/
├── kaspersky.yml
├── scripts/
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

## Поддерживаемые платформы

| Платформа | Ansible-роль | Bash-скрипт |
| --- | --- | --- |
| Ubuntu | ✅ | ❌ |
| Debian | ✅ | ❌ |
| RHEL | ✅ | ❌ |
| CentOS | ✅ | ✅ |
| Windows | ✅ | ❌ |

## Требования

### Ansible-роль

* Ansible 2.12 или выше.
* SSH-доступ к Linux-хостам.
* WinRM-доступ к Windows-хостам.
* Пользователь с административными правами (`become` или Administrator).
* Доступ к серверу распространения пакетов Kaspersky Security Center.

### Bash-скрипт

* Bash.
* SSH-доступ к целевым хостам.
* `wget`.
* `curl`.
* `yum`.
* Права `root` или возможность выполнения `sudo` без запроса пароля.
* Аутентификация по SSH-ключу или паролю.

## Настройка

Ansible-роль использует переменные, расположенные в каталоге `vars`.

Основные переменные:

| Переменная | Описание |
| --- | --- |
| `kes_url` | Базовый URL сервера распространения пакетов Kaspersky Security Center |
| `deb_agent_id` | Идентификатор пакета Network Agent для Debian/Ubuntu |
| `deb_antivirus_id` | Идентификатор пакета Endpoint Security для Debian/Ubuntu |
| `rpm_agent_id` | Идентификатор пакета Network Agent для RHEL/CentOS |
| `rpm_antivirus_id` | Идентификатор пакета Endpoint Security для RHEL/CentOS |
| `windows_installer` | Идентификатор установщика для Windows |

## Использование Ansible-роли

Запустите playbook:

```bash
ansible-playbook kaspersky.yml
```

Во время выполнения роль автоматически:

* определяет операционную систему;
* загружает необходимые установочные пакеты;
* устанавливает Kaspersky Security Center Network Agent;
* устанавливает Kaspersky Endpoint Security;
* удаляет временные файлы;
* при необходимости выполняет перезагрузку Windows.

## Использование Bash-скрипта

В репозитории также присутствует отдельный Bash-скрипт:

```bash
chmod +x scripts/install_kaspersky_centos.sh
./scripts/install_kaspersky_centos.sh
```

Перед запуском необходимо настроить:

* список целевых хостов (`HOSTS`);
* пользователя SSH;
* SSH-ключ (при необходимости);
* URL пакетов Kaspersky.

Скрипт выполняет следующие действия:

1. Подключается к каждому серверу по SSH.
2. Проверяет, установлен ли Kaspersky Endpoint Security.
3. Проверяет доступность установочных пакетов.
4. Устанавливает необходимые системные зависимости.
5. При необходимости настраивает локаль `ru_RU.UTF-8`.
6. Устанавливает Kaspersky Security Center Network Agent.
7. Устанавливает Kaspersky Endpoint Security.
8. Удаляет временные файлы.
9. Выводит результат установки для каждого сервера.

## Примечания

* Все установочные пакеты загружаются с внутреннего сервера распространения Kaspersky Security Center.
* Если Kaspersky уже установлен, установка автоматически пропускается.
* После установки на Windows выполняется автоматическая перезагрузка системы.
* Bash-скрипт предназначен для использования в средах, где Ansible отсутствует или ещё не настроен.

## Лицензия

MIT License.
