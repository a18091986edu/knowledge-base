```
uv add alembic
alembic init --template async database/alembic

```

```
alembic revision --autogenerate -m "Create User Table"
alembic upgrade head
alembic downgrade -1
alembic history --verbose
```




!!! tip "alembic.ini"
```
# было
# file_template = %%(year)d_%%(month).2d_%%(day).2d_%%(hour).2d%%(minute).2d-%%(rev)s_%%(slug)s

# стало
file_template = %%(year)d_%%(month).2d_%%(day).2d_%%(hour).2d%%(minute).2d-%%(rev)s_%%(slug)s

# было
# hooks = ruff  
# ruff.type = exec  
# ruff.executable = %(here)s/.venv/bin/ruff  
# ruff.options = --fix REVISION_SCRIPT_FILENAME

# стало
hooks = ruff
ruff.type = exec
ruff.executable = poetry
ruff.options = run ruff format REVISION_SCRIPT_FILENAME

# было
sqlalchemy.url = driver://user:pass@localhost/dbname

# стало
# sqlalchemy.url = driver://user:pass@localhost/dbname
```


!!! tip "env.py"
```
- после строки config = context.config

from core.settings import settings

config.set_main_option("sqlalchemy.url", settings.db_settings.db_url)

- вместо target_metadata = None:

from database.models.base import Base

target_metadata = Base.metadata
```


