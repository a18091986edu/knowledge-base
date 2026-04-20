    ```python
    from fastapi import FastAPI
    import os
    import asyncpg

    app = FastAPI()

    DATABASE_URL = os.getenv("DATABASE_URL")


    @app.get("/")
    async def root():
        return {"status": "ok!"}


    @app.get("/db")
    async def db_check():
        conn = await asyncpg.connect(DATABASE_URL)
        val = await conn.fetchval("SELECT 1")
        await conn.close()
        return {"db": val}
    ```