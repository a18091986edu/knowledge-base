
## Общие сведения

экстремально быстрый менеджер пакетов и проектов на Python, написанный на Rust  

UV позволяет:

- выбирать и фиксировать версию python
- создавать виртуальное окружение
- автоматически фиксировать версии устанавливаемых пакетов
- вести toml файлы
- интегрировать окружение с уже существующим venv poetry
- запускать скрипты Python c зависимостями, указываемыми напрямую в команде

UV является точкой входа для запуска Ruff, который заменяет целый зоопарк инструментов:

- pylint - [линтер](../../../glossary/glossary.md#glossary-linter), медленный и сложный анализатор кода
- flake8 - проверка стиля и поиск ошибок
- black - [форматтер](../../../glossary/glossary.md#glossary-formatter), инструмент для жесткого форматирования кода
- autopep8 - утилита для приведения кода к стандарту PEP8
- isort - сортировка импортов
- autoflake / pyupgrade - удаление неиспользуемого кода и обновление синтаксиса под новые версии Python

## Установка

```
curl -LsSf https://astral.sh/uv/install.sh | sh
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
pip install uv
```

## Автозавершение команд
```
Bash	echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc
Zsh	    echo 'eval "$(uv generate-shell-completion zsh)"' >> ~/.zshrc
fish	echo 'uv generate-shell-completion fish | source' >> ~/.config/fish/config.fish
Elvish	echo 'eval (uv generate-shell-completion elvish | slurp)' >> ~/.elvish/rc.elv
Powershell	if (!(Test-Path -Path $PROFILE)) {
New-Item -ItemType File -Path $PROFILE -Force
}
Add-Content -Path $PROFILE -Value '(& uv generate-shell-completion powershell) | Out-String | Invoke-Expression'
```

## Основные команды

??? tip "основные команды"
{% include "python/package_managers/uv/parts/general_comands.md" %}


## Структура python проекта (uv init)
```
├── .git
├── .gitignore
├── main.py # стартовый скрипт на Python
├── pyproject.toml - осноыной конфигурационный файл проекта
├── .python-version (версия python)
└── README.md - пустой файл документации
```
pyproject.toml описывает
```
- метаданные проекта
- зависимости
- настройки инструментов (линтеров, форматтеров, тестов)
- информацию для сборки и публикации пакета
```

## Удаление UV

```
uv cache clean
rm -r "$(uv python dir)"
rm -r "$(uv tool dir)"
rm ~/.local/bin/uv ~/.local/bin/uvx

Для windows:
$ rm $HOME\.local\bin\uv.exe
$ rm $HOME\.local\bin\uvx.exe
```

## Использование pre-commit хуков

uv можно интегрировать с [pre-commit](https://pre-commit.com/), чтобы запускать линтеры и форматтеры перед каждым коммитом

```
uv add --dev pre-commit
```

файл конфигурации .pre-commit-config.yaml

```
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.4
    hooks:
      - id: ruff
```

активируем хуки

```
uv run pre-commit install
```

теперь при каждом запуске git commit автоматические будет вызывать ruff для проверки кода

## Интеграция в CI/CD
.github/workflows/ci.yml

```
uv add ruff --dev
```
```
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install UV
        run: curl -LsSf https://astral.sh/uv/install.sh | sh
      - name: Sync dependencies
        run: uv sync
      - name: Run checks
        run: uv run ruff check

```

- установка текущего проета в режим разработки. весь исходный код надо разместить в /src. импорты в любом файле проекта должны работать корректно

```
 uv pip install -e .
```
- для запуска uv run app

```
[project.scripts]
app = "main:start"
```
```
def start():
    uvicorn.run(app="main:app", reload=True, port=8001)


if __name__ == "__main__":
    start()
```

## [Публикация проекта с помощью UV](https://stepik.org/lesson/1986391/step/1?unit=2014285)

## Полезные ресурсы
- [Курс [GG Python] UV: управляйте Python-версиями и не только](https://stepik.org/course/235889/syllabus)
