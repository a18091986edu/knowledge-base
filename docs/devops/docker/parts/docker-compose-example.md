    ```
    services:
      postgres:
        image: postgres:15-alpine
        environment:
          POSTGRES_USER: appuser
          POSTGRES_PASSWORD: secret
          POSTGRES_DB: appdb
        volumes:
          - postgres_data:/var/lib/postgresql/data
        ports:
          - "5432:5432"

      redis:
        image: redis:7-alpine
        ports:
          - "6379:6379"

      backend:
        build: ./backend
        ports:
          - "8000:8000"
        environment:
          DATABASE_URL: postgresql://appuser:secret@postgres:5432/appdb
          REDIS_URL: redis://redis:6379/0
        depends_on:
          - postgres
          - redis
        volumes:
          - ./backend:/app

      frontend:
        build: ./frontend
        ports:
          - "3000:3000"
        depends_on:
          - backend

    volumes:
      postgres_data:
    ```