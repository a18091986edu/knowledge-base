# Python

#### 1. Основы Python
[Перейти к разделу](#basics) - Синтаксис и структуры данных

### 2. Flask
[Перейти к разделу](#flask) - Микрофреймворк для веб-приложений

### 3. Django
[Перейти к разделу](#django) - Полноценный веб-фреймворк

### 4. Асинхронность
[Перейти к разделу](#async) - asyncio и async/await

---

<a id="basics"></a>

## Основы Python

### Полезные сниппеты

???+ tip ":material-code-braces: Работа со списками"
    ```python linenums="1" 
        # Генератор списка
        squares = [x**2 for x in range(10)]
        evens = [x for x in range(20) if x % 2 == 0]
        # Map и Filter
        numbers = [1, 2, 3, 4, 5]
        doubled = list(map(lambda x: x * 2, numbers))
    ```

