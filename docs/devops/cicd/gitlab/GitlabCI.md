##  Установка GitLab локально

[Ansible](https://galaxy.ansible.com/ui/standalone/roles/geerlingguy/gitlab/install/){target="_blank"}
[Stepik. CI/CD простым языком](https://stepik.org/lesson/1987366/step/1?unit=2015277){target="_blank"}


## Создание Pipeline

- 1. [Stepik. CI/CD простым языком](https://stepik.org/lesson/1987368/step/1?unit=2015279){target="_blank"}
- 2. [Stepik. CI/CD простым языком](https://stepik.org/lesson/1987310/step/1?unit=2015220){target="_blank"}


## Основные инструкции Gitlab CI
- script - команды для выполнения
```
test:
  script:
    - npm test
```
- image - docker-образ, в котором запустится джоба
```
test:
  image: node:18  # Используем Node.js версии 18
  script:
    - npm test
```
- only/except - условия запуска джобы
```
deploy:
  script:
    - ./deploy.sh
  only:
    - main  # Только для ветки main
```
- variables - переменные окружения
```
test:
  variables:
    NODE_ENV: test
  script:
    - npm test
```
- artifacts - файлы, которые нужно сохранить
```
build:
  script:
    - npm run build
  artifacts:
    paths:
      - dist/  # Сохраняем папку dist
```
- cache - кеширование для ускорения
```
test:
  cache:
    paths:
      - node_modules/  # Кешируем зависимости
  script:
    - npm install
    - npm test
```
- needs - зависимости между джобами
```
deploy:
  needs: ["build"]  # Запустится сразу после build
  script:
    - ./deploy.sh
```


## Пример pipeliтe
### 1
    ```yml
    .gitlab-ci.yml
    # джобы
    
    test: # название джобы
      sctipt: # ключевое словл
        - echo "Запускаем тесты"
        - npm test

    ---------------------------------------
    # стейджи

    stages:
      - test
      - build
      - deploy

    run_tests: # джоба для тестов
      stage: test # ключевое слово
      script:
        - echo "Запускаем тесты..."
        - npm install

    build_app: # джоба ждя сборки
      stage: build # ключевое слово
      script:
        - echo "Собираем приложение"
        - npm run build
        - echo "Собирка готова!"
    
    deploy_app: # джоба для деплоя
      stage: deploy # ключевое слово
      script: 
        - echo "Деплоим на сервер"
      when: manual # требует ручного запуска
    ```
### 2
    ```yml
    stages:
      - test
      - build
      - deploy

    run_tests:
    stage: test
    image: node:18-alpine
    script:
        - npm ci
        - npm test

    build_app:
    stage: build
    image: node:18-alpine
    script:
        - npm ci
        - npm run build
    artifacts:
        paths:
        - dist/
        expire_in: 1 hour
    only:
        - develop
        - main

    deploy_staging:
    stage: deploy
    script:
        - echo "Deploying to staging..."
    when: manual
    only:
        - develop

    ```


## Матричные сборки
```
Тестирование на разных версиях:

test:             ┌─→ [Node 16 + Chrome]
  matrix:         ├─→ [Node 16 + Firefox]  
    node: [16,18] ├─→ [Node 18 + Chrome]
    browser:      └─→ [Node 18 + Firefox]
      - chrome
      - firefox
      
Создаёт 4 джобы автоматически
```