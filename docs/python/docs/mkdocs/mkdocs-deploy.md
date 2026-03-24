???+ example "Установка MkDocs"
    ```bash
    pip install mkdocs
    mkdocs new doc
    cd doc
    pip install mkdocs-material # mkdocs-materialx, shadcn, bootstrap
    mkdocs serve
    ```

???+ "пример структуры проекта"
```
KNOWLEDGE-BASE/
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── docs/
│   ├── devops/
│   │   └── docker/
│   │       └── examples/
│   │           (пустая папка для примеров)
│   │
│   ├── python/
│   │   ├── docs/
│   │   │   (документация по Python)
│   │   ├── examples/
│   │   │   (примеры кода на Python)
│   │   ├── mkdocs.md
│   │   ├── fastapi.md
│   │   └── python.md
│   │
│   ├── devops.md
│   ├── docker-commands.md
│   ├── docker-compose-example.md
│   ├── dockerfile-example.md
│   ├── fastapi/
│   │   └── examples/
│   │       (примеры для FastAPI)
│   ├── index.md
│   └── python.md
│
├── mkdocs.yml
└── requirements.txt
```

???+ "1 пример mkdocs.yml"
```
site_name: Моя База Знаний
site_url: https://a18091986edu.github.io/my-knowledge-base/
repo_url: https://github.com/a18091986edu/knowledge-base

theme:
  name: materialx
  features:
    - navigation.tabs        # вкладки в главном меню
    - navigation.tabs.sticky # Закрепленные вкладки
    - navigation.prune
    # - navigation.sections    # секции в сайдбаре
    - navigation.expand      # раскрытие текущей секции в сайдбаре
    - navigation.instant     # мгновенная навигация
    - navigation.top         # кнопка "наверх"
    - navigation.tracking    # отслеживание позиции
    - navigation.indexes
    - search.suggest         # подсказки в поиске
    - search.highlight       # подсветка в поиске
    - content.code.copy      # копирование кода
    - content.code.annotate
    # - toc.follow
    # - toc.integrate
    - navigation.path


  palette:
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to light mode

markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  # - pymdownx.snippets
  - pymdownx.superfences      # для сворачиваемых блоков
  - pymdownx.details          # для сворачиваемых блоков
  - admonition                # для заметок
  - tables
  - toc:
      permalink: true
  - pymdownx.tabbed:
      alternate_style: true  # Для более красивого оформления
  - pymdownx.details  # Для ??? блоков
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.emoji:
      emoji_index: !!python/name:material.extensions.emoji.twemoji
      emoji_generator: !!python/name:material.extensions.emoji.to_svg

# Для поддержки include
plugins:
  - search
  - macros:
      include_dir: docs

nav:
  # - Главная: index.md
  
  - DevOps:
    - devops.md
    - Основы Linux: themes/linux.md
    - Контейнеризация:
      - Docker: themes/docker.md
      - Kubernetes: themes/kubernetes.md
    - CI/CD:
      - GitHub Actions: themes/github-actions.md
      - GitLab CI: themes/gitlab-ci.md
  
  - Python:
    - python.md
    - Веб-фреймворки:
      - FastAPI: python/fastapi/fastapi.md
    - Документирование: 
      - MkDoks: python/docs/mkdocs.md
  
  # - ML:
  
extra:
  generator: false
  social:
    - icon: fontawesome/brands/github
      link: https://github.com/yourusername
      name: GitHub

copyright: © 2024 Моя База Знаний
```
???+ "2 пример mkdocs.yml"
```
# Информация о сайте
site_name: Моя База Знаний
site_url: https://a18091986edu.github.io/knowledge-base/
site_description: Персональная база знаний по разработке
site_author: Ваше Имя
copyright: © 2024 Ваше Имя

# Репозиторий
repo_name: knowledge-base
repo_url: https://github.com/a18091986edu/knowledge-base
edit_uri: edit/main/docs/

# Настройки темы
theme:
  name: material
  language: ru
  features:
    # Навигация
    - navigation.tabs           # Вкладки в навигации
    - navigation.sections       # Секции в навигации
    - navigation.expand         # Развернутая навигация
    - navigation.top            # Кнопка "наверх"
    - navigation.tracking       # Отслеживание позиции
    - navigation.indexes        # Индексы в навигации
    - navigation.instant        # Мгновенная загрузка страниц
    - navigation.instant.prefetch
    - navigation.instant.progress
    
    # Поиск
    - search.suggest            # Подсказки при поиске
    - search.highlight          # Подсветка результатов
    - search.share              # Поделиться поиском
    
    # Контент
    - content.code.copy         # Кнопка копирования кода
    - content.code.annotate     # Аннотации в коде
    - content.tabs.link         # Связанные вкладки
    
    # Дополнительно
    - header.autohide           # Автоскрытие шапки
    - toc.integrate             # Интеграция оглавления
    - toc.follow                # Следование оглавления
    
  palette:
    # Светлая тема
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Переключить на темную тему
    
    # Темная тема
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Переключить на светлую тему
  
  font:
    text: Roboto
    code: Roboto Mono
  
  favicon: assets/images/favicon.png
  logo: assets/images/logo.svg

# Расширения Markdown
markdown_extensions:
  # Базовые расширения
  - admonition                   # Блоки предупреждений
  - md_in_html                  # HTML внутри Markdown
  - attr_list                   # Атрибуты для элементов
  - toc:
      permalink: true           # Постоянные ссылки
      toc_depth: 3              # Глубина оглавления
  
  # Расширения PyMdown
  - pymdownx.highlight:
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
      use_pygments: true
      linenums: true            # Нумерация строк
  - pymdownx.inlinehilite       # Подсветка в строке
  - pymdownx.snippets           # Вставка файлов
  - pymdownx.superfences        # Улучшенные блоки кода
  - pymdownx.details            # Сворачиваемые блоки
  - pymdownx.tabbed:
      alternate_style: true     # Альтернативный стиль вкладок
  - pymdownx.critic             # Отслеживание изменений
  - pymdownx.caret              # Верхний индекс
  - pymdownx.keys               # Отображение клавиш
  - pymdownx.mark               # Выделение текста
  - pymdownx.tilde              # Зачеркивание
  - pymdownx.tasklist:
      custom_checkbox: true     # Чекбоксы
  - pymdownx.emoji:
      emoji_index: !!python/name:material.extensions.emoji.twemoji
      emoji_generator: !!python/name:material.extensions.emoji.to_svg
  
  # Вставка кода из файлов
  - pymdownx.snippets:
      base_path: docs/includes
      check_paths: true
  
  # Математические формулы
  - pymdownx.arithmatex:
      generic: true

# Плагины
plugins:
  # Поиск
  - search:
      lang: ru
      separator: '[\s\-_–—]+'
      pipeline:
        - stemmer
        - stopWordFilter
        - trimmer
  
  # Минификация
  - minify:
      minify_html: true
      minify_css: true
      minify_js: true
      htmlmin_opts:
        remove_comments: true
      cache_safe: true
  
  # Даты обновления
  - git-revision-date-localized:
      enable_creation_date: true
      type: timeago
      fallback_to_build_date: true
  
  # Информация о авторах
  - git-committers:
      repository: a18091986edu/knowledge-base
      branch: main
      token: !!null
  
  # Управление навигацией
  - awesome-pages:
      collapse_single_pages: true
      filename: .pages
  
  # Редиректы
  - redirects:
      redirect_maps:
        'old-page.md': 'new-page.md'
  
  # Макросы
  - macros:
      include_yaml:
        - data/config.yml
  
  # RSS лента
  - rss:
      match_path: '.*'
      date_from_meta:
        as_creation: date
      categories:
        - categories
        - tags
  
  # Блог
  - blogging:
      locale: ru
      posts_dir: blog
      posts_url: /blog/
      feed: true
      feed_url: /feed.xml
      feed_title: Блог

# Дополнительные настройки
extra:
  social:
    - icon: fontawesome/brands/github
      link: https://github.com/a18091986edu
      name: GitHub
    - icon: fontawesome/brands/telegram
      link: https://t.me/username
      name: Telegram
  
  analytics:
    provider: google
    property: UA-XXXXXXXXX-X
  
  consent:
    title: Cookie consent
    description: >-
      Мы используем cookies для анализа трафика и улучшения работы сайта.
  
  generator: false

# Навигация
nav:
  - Главная: index.md
  
  - Python:
    - Обзор: python/index.md
    - Основы: python/basics.md
    - Flask: python/flask.md
    - Django: python/django.md
    - Асинхронность: python/async.md
  
  - DevOps:
    - Обзор: devops/index.md
    - Docker: devops/docker.md
    - Kubernetes: devops/kubernetes.md
  
  - Frontend:
    - Обзор: frontend/index.md
    - React: frontend/react.md
    - Vue: frontend/vue.md
  
  - ML:
    - Обзор: ml/index.md
    - Pandas: ml/pandas.md
    - Scikit-learn: ml/sklearn.md

# Дополнительные стили и скрипты
extra_css:
  - assets/stylesheets/extra.css

extra_javascript:
  - assets/javascripts/extra.js
  - https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML

# Управление валидацией ссылок
validation:
  omitted_files: warn
  absolute_links: warn
  unrecognized_links: warn
  anchors: warn
```

???+ плагины 
```
pip install mkdocs-minify-plugin           # Минификация HTML, CSS, JS
pip install mkdocs-git-revision-date-localized-plugin  # Даты последнего обновления
pip install mkdocs-git-committers-plugin-2 # Информация о авторах
pip install mkdocs-static-i18n             # Мультиязычность
pip install mkdocs-rss-plugin              # RSS лента
pip install mkdocs-awesome-pages-plugin    # Управление навигацией
pip install mkdocs-video                   # Встраивание видео
pip install mkdocs-macros-plugin           # Макросы и переменные
pip install mkdocs-exclude                  # Исключение файлов при сборке
pip install mkdocs-redirects                # Редиректы страниц
pip install mkdocs-blogging-plugin         # Блог на MkDocs
pip install mkdocs-newsletter              # Подписка на обновления
pip install mkdocs-code-validator          # Валидация примеров кода
```


???+ расширения для markdown
```
pip install pymdown-extensions    # Мощные расширения для Markdown
pip install markdown-include      # Включение файлов
pip install markdown-captions     # Подписи к изображениям
pip install markdown-toc          # Автоматическое оглавление
```

