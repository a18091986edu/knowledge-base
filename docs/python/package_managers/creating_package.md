#
### Структура проекта
```
context-analyzer/
├── pyproject.toml
├── README.md
├── src/
│   └── context_analyzer/
│       ├── __init__.py
│       ├── core.py
│       ├── ignore.py
│       ├── core_text.py
│       └── cli.py
```

??? example "core"
{% include "python/package_managers/parts/core.py" %}

??? example "cli"
{% include "python/package_managers/parts/cli.py" %}

??? example "core_text"
{% include "python/package_managers/parts/core_text.py" %}

??? example "ignore"
{% include "python/package_managers/parts/ignore.py" %}

??? example "pyproject.toml"
{% include "python/package_managers/parts/pyproject.toml" %}


!!! tip "публикация"
```
- регистрируемся в http://pypi.org
- создаем API токен
- uv add --dev twine #устанавливаем twine 
- uv build -> dist/context_analyzer-0.1.0-py3-none-any.whl
- uv run twine upload dist/* -> token
```

!!! tip "обновление"
```
- удаляем dist
- меняем версию в pyproject.toml
- uv build -> dist/context_analyzer-0.1.0-py3-none-any.whl
- uv run twine upload dist/* -> token
```

