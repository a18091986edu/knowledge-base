    ```
    ########################### base ###############################
    
    - uv help посмотреть справку
    - uv add --help | uv python list --help | uv self update --help
    - uv --version
    - uv self update / pip install --upgrade uv
    - uv python install | uv python list -> uv python install 3.12 3.11 3.10
    - uv python install --reinstall - обновление
    - uv python find - местонахождение текущего интерпретатора
    - uv sync
    
    ########################### venv and run ########################
    
    - uv init | uv init --python 3.12 another_project
    - uv venv | uv venv dir_name
    - source ./.venv/bin/activate
    - окружение активируется автоматически командами uv (uv add | uv run)
    - вручную окружение стоит активировать тогда, когда необходимо предоставить доступ внешним программам, например дебаггеру vs code
    - uv python pin 3.12 - зафиксировать версию интерпретатора для текущего проекта (.python-version)
    - uv run python | app.py | uvicorn | ruff check . | 
    - uv run --with requests main.py


    ########################### add|upgrade|remove ###################
    
    - uv add ... -> установит библиотеку, добавит запись в pyptoject.toml, обновит uv.lock
    - uv add "fastapi[standard]==0.114.2" - установить специфическую версию пакета
    - pyproject.toml - файл с тем, что мы хотим, а uv.lock - то, что получили
    - uv lock --upgrade - обновить все зависимости с учетом ограничений pyproject.toml
    - uv add --upgrade fastapi
    - uv add --dev ruff pytest (эти пакеты пойдут в секцию dev-dependencies)
    - uv tree | uv pip list
    - uv remove fastapi
    - uv add -r requirements.txt
    
    ########################### tools ###################

    - uvx ruff check - не устанавливает инструмент, но сохраняет в кэш
    - uv tool install ruff - установит ruff в отдельное от проекта и системы виртуальное окружение
    - uv tool upgrade --python 3.10 ruff
    - uv tool upgrade --all
    - uv tool uninstall ruff
    - uv tool list

    ```