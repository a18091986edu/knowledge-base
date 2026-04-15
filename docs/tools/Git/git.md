## 🧠 Работа с историей и изменениями

??? tip "✍️ commit и изменение последнего коммита"
    ### ✍️ commit и amend

    Изменение последнего коммита:

    ```bash
    git commit --amend
    ```

    📌 Что делает:
    - добавляет текущие изменения (staged) в последний коммит
    - позволяет изменить сообщение

    Без изменения сообщения:

    ```bash
    git commit --amend --no-edit
    ```

    📌 Используется когда:
    - забыли добавить файл
    - нужно поправить commit message

    ⚠️ Важно:
    - нельзя использовать после push (ломает историю)


??? tip "📜 Просмотр истории"
    ### 📜 Просмотр истории

    Основные команды:

    ```bash
    git log
    git log --oneline
    git log --stat
    ```

    📌 Полезные варианты:

    ```bash
    git log --since="2024-01-01" --until="2024-12-31"
    git log --oneline file.txt
    git log --graph --oneline --all
    ```

    📌 Краткая статистика:

    ```bash
    git shortlog
    ```

    📌 Детали коммита:

    ```bash
    git show <commit_id>
    ```

    📌 Используется когда нужно:

    - понять историю изменений
    - найти коммит
    - посмотреть изменения по файлу


??? tip "🧭 reflog (скрытая история)"
    ### 🧭 reflog

    reflog — история всех действий в локальном репозитории.

    ```bash
    git reflog
    ```

    📌 Включает:
    - reset
    - commit
    - checkout
    - merge

    📌 Используется когда:

    - нужно восстановить удалённый коммит
    - “сломал всё” и хочешь откатиться

    📌 Пример восстановления:

    ```bash
    git reset --hard HEAD@{2}
    ```


??? tip "↩️ reset (отмена изменений)"
    ### ↩️ reset

    reset — изменяет состояние репозитория.

    📌 Убрать файл из индекса:

    ```bash
    git reset file.txt
    ```

    📌 Отменить commit:

    ```bash
    git reset HEAD~1
    ```

    📌 Варианты:

    ```bash
    git reset --soft HEAD~1
    git reset --mixed HEAD~1
    git reset --hard HEAD~1
    ```

    📌 Разница:

    - soft → оставить изменения и индекс
    - mixed → оставить изменения, очистить индекс (по умолчанию)
    - hard → удалить ВСЁ

    📌 Полный откат:

    ```bash
    git reset --hard <commit_id>
    ```

    ⚠️ Опасно:
    - удаляет изменения без возможности восстановления (если нет reflog)


??? tip "🔁 revert (безопасный откат)"
    ### 🔁 revert

    revert — создаёт новый коммит, который отменяет изменения.

    ```bash
    git revert <commit_id>
    ```

    📌 Используется когда:
    - нельзя переписывать историю
    - уже сделали push

    📌 Серия коммитов:

    ```bash
    git revert A..B
    ```

    📌 Без авто-коммита:

    ```bash
    git revert <commit_id> --no-commit
    ```

    📌 Отмена при конфликте:

    ```bash
    git revert --abort
    ```


??? tip "🗑️ Удаление файлов"
    ### 🗑️ Удаление файлов

    Удаление из Git и файловой системы:

    ```bash
    git rm file.txt
    git rm -r dir/
    ```

    📌 Удаление неотслеживаемых файлов:

    ```bash
    git clean -f
    git clean -df
    ```

    📌 Предпросмотр:

    ```bash
    git clean -n
    ```

    📌 Используется когда:

    - очистить мусор
    - удалить временные файлы


??? tip "🔍 Просмотр изменений"
    ### 🔍 Просмотр изменений

    Разница между версиями:

    ```bash
    git diff
    ```

    📌 По словам:

    ```bash
    git diff --word-diff
    ```

    📌 Визуально:

    ```bash
    git difftool
    ```

    📌 Коммит:

    ```bash
    git show
    ```

    📌 Используется когда:

    - понять что изменилось
    - проверить перед commit


??? tip "📦 Клонирование репозитория"
    ### 📦 Клонирование

    ```bash
    git clone <repo>
    ```

    📌 Глубокий clone:

    ```bash
    git clone --depth=1
    ```

    📌 Без рабочей директории:

    ```bash
    git clone --bare
    ```

    📌 Используется когда:

    - скачать проект
    - сделать CI/CD mirror


??? tip "🍴 Fork (копия репозитория)"
    ### 🍴 Fork

    fork — это копия чужого репозитория (обычно через GitHub/GitLab UI).

    📌 Отличие от clone:

    - fork → отдельный репозиторий
    - clone → локальная копия

    📌 Workflow:

    1. Fork на GitHub
    2. Clone к себе
    3. Работа в своей копии
    4. Pull Request

    📌 Используется когда:

    - работа с open-source
    - нет прав на основной репозиторий



## 🌿 Ветки, merge и rebase

??? tip "🌿 Работа с ветками"
    ### 🌿 Работа с ветками

    Создание ветки:

    ```bash
    git branch feature          # создать ветку
    ```

    Переключение:

    ```bash
    git checkout feature        # перейти в ветку
    ```

    Создание + переход:

    ```bash
    git checkout -b feature     # создать и сразу перейти
    ```

    📌 Современный вариант:

    ```bash
    git switch -c feature       # создать и перейти
    git switch feature          # перейти
    ```

    📌 Просмотр веток:

    ```bash
    git branch                  # локальные ветки
    git branch -a               # все (локальные + удалённые)
    git branch -r               # только удалённые
    git branch -v               # последний commit
    git branch -vv              # + связь с origin
    git branch --list           # список (можно с фильтром)
    ```

    📌 Пример:

    ```bash
    git branch --list "feature*"
    ```

    📌 Удаление:

    ```bash
    git branch -d feature       # безопасно (если смержена)
    git branch -D feature       # принудительно
    ```

    📌 Отправка всех веток:

    ```bash
    git push --all              # push всех локальных веток
    ```

    📌 Используется когда:

    - изолировать разработку
    - работать параллельно


??? tip "🔀 merge (слияние веток)"
    ### 🔀 merge

    Слияние ветки в текущую:

    ```bash
    git checkout main           # перейти в основную ветку
    git merge feature           # влить feature в main
    ```

    📌 Просмотр истории (очень важно):

    ```bash
    git log --oneline --graph --all
    ```

    📌 Fast-forward (без merge commit):

    ```bash
    git merge --ff-only feature
    ```

    📌 Принудительный merge commit:

    ```bash
    git merge --no-ff feature
    ```

    📌 Конфликты:

    - возникают при изменении одних и тех же строк

    📌 Выбор версии:

    ```bash
    git checkout --ours file.txt     # оставить текущую ветку
    git checkout --theirs file.txt   # взять из вливаемой ветки
    ```

    📌 После решения:

    ```bash
    git add .
    git commit
    ```

    📌 Отмена merge:

    ```bash
    git merge --abort
    ```

    📌 Используется когда:

    - завершили feature
    - объединяем ветки


??? tip "🧬 rebase (переписывание истории)"
    ### 🧬 rebase

    Перенос коммитов:

    ```bash
    git checkout feature
    git rebase main
    ```

    📌 Визуально:

    ```text
    было:   A---B---C (main)
              \
               D---E (feature)

    стало: A---B---C---D'---E'
    ```

    📌 Работа с конфликтами:

    ```bash
    git add .
    git rebase --continue
    ```

    Отмена:

    ```bash
    git rebase --abort
    ```

    📌 Используется когда:

    - подтянуть изменения из main
    - сделать чистую историю

    ⚠️ Важно:

    - не делать после push
    - переписывает commit id


??? tip "⚖️ merge vs rebase"
    ### ⚖️ merge vs rebase

    📌 merge:

    - сохраняет историю
    - безопасный
    - создаёт merge commit

    📌 rebase:

    - линейная история
    - чище лог
    - опаснее (переписывает историю)

    📌 Практика:

    - rebase → локально
    - merge → в main


??? tip "🔍 diff и анализ изменений"
    ### 🔍 diff

    Просмотр изменений:

    ```bash
    git diff                     # изменения в рабочей директории
    ```

    📌 Между индексом и HEAD:

    ```bash
    git diff --staged
    ```

    📌 Между коммитами:

    ```bash
    git diff HEAD~1 HEAD
    ```

    📌 По файлу:

    ```bash
    git diff file.txt
    ```

    📌 Используется когда:

    - проверить изменения перед commit
    - анализировать код


??? tip "📦 stash (временное сохранение)"
    ### 📦 stash

    Сохранить изменения:

    ```bash
    git stash                   # сохранить текущие изменения
    ```

    📌 Список:

    ```bash
    git stash list
    ```

    📌 Применить:

    ```bash
    git stash pop              # применить и удалить из stash
    git stash apply            # применить без удаления
    ```

    📌 Конкретный stash:

    ```bash
    git stash apply stash@{1}
    ```

    📌 Просмотр:

    ```bash
    git stash show             # кратко
    git stash show -p          # полный diff
    ```

    📌 Используется когда:

    - нужно переключиться между ветками
    - изменения не готовы к commit

---

## 🧰 Продвинутые операции

??? tip "📦 stash (временное сохранение)"
    ### 📦 stash

    Сохранить изменения:

    ```bash
    git stash
    ```

    📌 Вернуть:

    ```bash
    git stash pop
    ```

    📌 Список:

    ```bash
    git stash list
    ```

    📌 Применить конкретный:

    ```bash
    git stash apply stash@{1}
    ```

    📌 Используется когда:

    - нужно быстро переключиться
    - незакоммиченные изменения мешают


??? tip "🍒 cherry-pick (перенос коммита)"
    ### 🍒 cherry-pick

    Применить конкретный коммит:

    ```bash
    git cherry-pick <commit_id>
    ```

    📌 Используется когда:

    - нужен один коммит из другой ветки
    - не нужен весь merge

    📌 Конфликты:

    ```bash
    git add .
    git cherry-pick --continue
    ```


??? tip "🧠 interactive rebase"
    ### 🧠 interactive rebase

    Редактирование истории:

    ```bash
    git rebase -i HEAD~3
    ```

    📌 Откроется список:

    ```text
    pick
    squash
    reword
    drop
    ```

    📌 Возможности:

    - объединить коммиты (squash)
    - изменить сообщение (reword)
    - удалить коммит (drop)

    📌 Используется когда:

    - привести историю в порядок
    - подготовить PR


??? tip "🔄 stash + rebase workflow"
    ### 🔄 stash + rebase workflow

    Частый сценарий:

    ```bash
    git stash
    git pull --rebase
    git stash pop
    ```

    📌 Используется когда:

    - есть локальные изменения
    - нужно обновить ветку


??? tip "🚀 Практический workflow"
    ### 🚀 Практический workflow

    Типичный flow разработки:

    ```bash
    git checkout -b feature
    # работа

    git add .
    git commit -m "feature"

    git fetch
    git rebase origin/main

    git push origin feature
    ```

    📌 После:

    - PR
    - merge в main



## 🪝 Git Hooks

??? tip "🪝 Что такое hooks"
    ### 🪝 Что такое hooks

    Git hooks — это скрипты, которые автоматически выполняются при событиях в Git.

    📌 Примеры событий:
    - commit
    - push
    - merge

    📌 Расположение:

    ```bash
    .git/hooks/
    ```

    📌 По умолчанию:
    - файлы с расширением `.sample`
    - нужно убрать `.sample` и сделать исполняемыми

    ```bash
    chmod +x .git/hooks/pre-commit
    ```

    📌 Используется для:

    - проверки кода
    - линтинга
    - запуска тестов
    - автоматизации


??? tip "⚙️ Основные виды hooks"
    ### ⚙️ Основные виды hooks

    📌 До коммита:

    - pre-commit → перед commit
    - prepare-commit-msg → перед вводом сообщения
    - commit-msg → проверка сообщения

    📌 После:

    - post-commit → после commit
    - post-merge → после merge

    📌 Перед push:

    - pre-push → перед отправкой

    📌 На сервере:

    - pre-receive
    - update
    - post-receive

    📌 Используется когда:

    - нужно контролировать процесс разработки
    - enforce правила команды


??? tip "🧪 Пример pre-commit"
    ### 🧪 Пример pre-commit

    Проверка перед коммитом:

    ```bash
    #!/bin/bash

    echo "Running checks..."

    npm run lint
    if [ $? -ne 0 ]; then
        echo "Lint failed"
        exit 1
    fi
    ```

    📌 Что происходит:

    - если exit != 0 → commit отменяется
    - если всё ок → commit проходит


??? tip "✍️ Проверка commit message"
    ### ✍️ commit-msg hook

    Пример проверки сообщения:

    ```bash
    #!/bin/bash

    message=$(cat $1)

    if [[ ! $message =~ ^(feat|fix|docs): ]]; then
        echo "Invalid commit message"
        exit 1
    fi
    ```

    📌 Используется для:

    - conventional commits
    - стандартизации истории


??? tip "🚀 pre-push hook"
    ### 🚀 pre-push

    Проверка перед push:

    ```bash
    #!/bin/bash

    echo "Running tests..."

    npm test
    if [ $? -ne 0 ]; then
        echo "Tests failed"
        exit 1
    fi
    ```

    📌 Используется когда:

    - нельзя пушить сломанный код


??? tip "⚠️ Важно про hooks"
    ### ⚠️ Важно про hooks

    📌 Hooks:

    - НЕ попадают в репозиторий
    - живут локально в `.git/hooks`

    📌 Проблема:

    - у каждого разработчика могут быть разные hooks


??? tip "📦 Управление hooks (husky)"
    ### 📦 Управление hooks (husky)

    Husky — популярный инструмент для управления hooks.

    Установка:

    ```bash
    npm install husky --save-dev
    npx husky install
    ```

    Добавление hook:

    ```bash
    npx husky add .husky/pre-commit "npm test"
    ```

    📌 Преимущества:

    - hooks хранятся в репозитории
    - одинаковые для всей команды


??? tip "🧠 Best practices"
    ### 🧠 Best practices

    - не делать тяжёлые проверки в pre-commit
    - быстрые проверки → pre-commit
    - тяжёлые → pre-push или CI

    - всегда использовать husky или аналог
    - валидировать commit message

    📌 Хорошая практика:

    ```bash
    lint → pre-commit
    tests → pre-push
    CI → финальная проверка
    ```