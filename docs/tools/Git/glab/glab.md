# GitLab CLI (`glab`)

Официальный CLI для GitLab: репозитории, issues, merge requests, CI и авторизация без веб-интерфейса.

## Установка

=== "Linux (Snap)"

    ```bash
    sudo snap install glab --classic
    # при необходимости: sudo ln -s /snap/bin/glab /usr/local/bin/glab
    ```

=== "Linux / macOS (бинарь / пакетный менеджер)"

    См. [установку в документации GitLab](https://gitlab.com/gitlab-org/cli#installation) — есть Homebrew, скрипт, tarball.

=== "Windows"

    ```bash
    winget search glab
    winget install <Id-из-списка>
    # или: choco install glab
    ```

Проверка: `glab version`.

## Авторизация

1. Создай **Personal Access Token**: GitLab → **Edit profile** → **Preferences** → **Access Tokens**. Для типичной работы достаточно scope: `api`, `write_repository` (точный набор зависит от политики инстанса).
2. Войди:

```bash
glab auth login
# GitLab.com, self-hosted или вставка токена
```

Self-hosted (свой хост):

```bash
glab auth login --hostname gitlab.example.com
```

Проверка сессии:

```bash
glab auth status
```

## Репозитории

| Действие | Команда |
|----------|---------|
| Создать (по умолчанию приватный) | `glab repo create my-new-project` |
| Создать с опциями | см. блок ниже |
| Клонировать | `glab repo clone group/project` или `glab repo clone my-awesome-project` |
| Открыть в браузере | `glab repo view --web` |
| Форк | `glab repo fork namespace/project` |

```bash
glab repo create my-project \
  --public \
  --description "Мой первый проект" \
  --readme \
  --defaultBranch main
```

После создания проекта привяжи локальный каталог: `git remote add origin <url>` и `git push -u origin main`. Имя remote по умолчанию можно задать при создании, если поддерживает твоя версия: `glab repo create -h` (часто есть `--remoteName`).

!!! tip "Уже есть `git init`"
    После `glab repo create ...` при необходимости добавь `origin` и сделай первый push — см. раздел «Быстрый старт».

## Issues

```bash
glab issue create --title "Fix bug" --description "Описание проблемы"
glab issue list
glab issue view 1          # в терминале
glab issue view 1 --web    # в браузере
```

## Merge requests

```bash
glab mr create --title "Feature A" --description "Добавлена новая фича"
glab mr create --fill      # заголовок/описание из коммитов (удобно после ветки)
glab mr list
glab mr view 1
glab mr merge 1            # при достаточных правах
```

## CI/CD

```bash
glab ci list               # список пайплайнов (если нет — см. glab pipeline -h)
glab ci status             # статус последнего пайплайна
glab ci trace <job-id>     # лог job
glab ci lint               # проверка .gitlab-ci.yml (зависит от API инстанса)
```

!!! note "Версии `glab`"
    Подкоманды CI/пайплайнов иногда переезжают между `glab ci` и `glab pipeline`. Ориентир: `glab -h`, `glab ci -h`.

## Конфигурация

Глобальные настройки (хост, редактор и т.д.):

```bash
glab config get host
glab config set editor "code --wait"
glab config list
```

Справка по флагам любой команды: `glab mr create -h`.

## Git: базовый цикл с GitLab

```bash
git status
git add .
git commit -m "init project"
git push origin main
```

## Генерация `.gitignore` (`gi` + gitignore.io)

В `~/.bashrc` или `~/.zshrc`:

```bash
function gi() { curl -L -s "https://www.gitignore.io/api/$@"; }
```

```bash
source ~/.bashrc   # или ~/.zshrc
gi python node linux >> .gitignore
```

## Быстрый старт (ручной remote)

```bash
git init
git add .
git commit -m "init"

glab repo create my-project --public --defaultBranch main
git remote add origin <url-из-вывода-glab-или-из-веба>
git push -u origin main
```

## См. также

- [Документация glab](https://gitlab.com/gitlab-org/cli/-/blob/main/docs/README.md)
- [Создание токенов](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
