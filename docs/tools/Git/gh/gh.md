# GitHub CLI (`gh`)

Официальный CLI для GitHub: репозитории, pull request’ы, issues, Actions и запросы к API без постоянного переключения в браузер.

## Установка

=== "Linux (apt)"

    ```bash
    sudo apt update
    sudo apt install gh -y
    ```

=== "macOS / другие способы"

    См. [установку в документации GitHub](https://github.com/cli/cli#installation) — Homebrew, Conda, скачиваемый бинарь.

=== "Windows"

    ```bash
    winget install --id GitHub.cli
    # или: choco install gh
    ```

Проверка: `gh version`.

## Авторизация

```bash
gh auth login
# браузер, HTTPS/SSH, GitHub.com или GitHub Enterprise Server
```

Корпоративный сервер (пример):

```bash
export GH_HOST=github.example.com
gh auth login --hostname github.example.com
```

Проверка:

```bash
gh auth status
```

Выход: `gh auth logout`.

!!! tip "Токен вместо браузера"
    В средах без GUI можно выбрать аутентификацию по **Personal Access Token** (classic или fine-grained — по политике организации). Права зависят от задач: для `repo`, PR и Issues обычно нужны соответствующие scopes у [classic token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) или разрешения у fine-grained.

## Репозитории

| Действие | Команда |
|----------|---------|
| Создать и запушить из текущей папки | см. блок ниже |
| Клонировать | `gh repo clone owner/repo` |
| Открыть в браузере | `gh repo view --web` |
| Форк | `gh repo fork owner/repo --clone` |
| Список своих репо | `gh repo list` |

Создание репозитория из уже инициализированного git-каталога:

```bash
gh repo create my-project \
  --public \
  --description "Мой первый проект" \
  --source=. \
  --remote=origin \
  --push
```

С шаблоном `.gitignore` (встроенные имена GitHub):

```bash
gh repo create my-project --public --source=. --push --gitignore "Python,Linux"
```

## Файл `.gitignore`

Через API шаблонов GitHub:

```bash
curl -s -H "Accept: application/vnd.github.raw+json" \
  https://api.github.com/gitignore/templates/Python > .gitignore
```

Альтернатива — утилита **gignr** (если установлена): `gignr create gh:Python .gitignore`.

## Pull requests

```bash
gh pr create --title "Feature" --body "Описание изменений"
gh pr create --fill              # заголовок и описание из ветки/коммитов
gh pr list
gh pr view
gh pr view --web
gh pr merge
```

## Issues

```bash
gh issue create --title "Bug" --body "Описание проблемы"
gh issue list
gh issue view 1
gh issue view 1 --web
```

## GitHub Actions

```bash
gh workflow list
gh run list
gh run view <run-id>
gh run watch
```

## Полезное

```bash
gh browse                    # репозиторий в браузере
gh api user                  # GET /user (JSON)
gh api repos/<owner>/<repo>/issues --paginate
```

Справка по подкоманде: `gh pr create -h`.

## Git: базовый цикл

```bash
git status
git add .
git commit -m "update"
git pull
git push
```

## Настройка Git и учётных данных

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global credential.helper store   # или менеджер ОС / cache
```

## См. также

- [Руководство по GitHub CLI](https://cli.github.com/manual/)
- [Создание personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
