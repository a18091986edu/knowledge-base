# 🔍 JPath (JsonPath)

- [JSON to YAML](https://codebeautify.org/json-to-yaml)

- [Online Evaluator](https://jsonpath.com/)



## Что это

**JPath** (или **JsonPath**) — это язык запросов для извлечения данных из JSON-документов.  
Аналог XPath для XML, но для JSON.

---

## 📦 Основной синтаксис

| Выражение | Описание | Пример |
|-----------|----------|--------|
| `$` | Корневой элемент | `$` |
| `.` | Доступ к ключу | `$.store.book` |
| `..` | Рекурсивный поиск | `$..author` |
| `*` | Wildcard (все элементы) | `$.store.*` |
| `@` | Текущий элемент (в фильтрах) | `$.books[?(@.price < 10)]` |
| `[n]` | Доступ по индексу | `$.store.book[0]` |
| `[start:end]` | Срез массива | `$.store.book[0:2]` |
| `[key1,key2]` | Несколько ключей | `$.store.["book","bicycle"]` |
| `[?(@.condition)]` | Фильтр | `$.store.book[?(@.price < 10)]` |

---

## 🎯 Популярные операторы фильтрации

| Оператор | Значение | Пример |
|----------|----------|--------|
| `==` | равно | `[?(@.price == 10)]` |
| `!=` | не равно | `[?(@.price != 10)]` |
| `<` | меньше | `[?(@.price < 10)]` |
| `<=` | меньше или равно | `[?(@.price <= 10)]` |
| `>` | больше | `[?(@.price > 10)]` |
| `>=` | больше или равно | `[?(@.price >= 10)]` |
| `=~` | regexp | `[?(@.name =~ /foo.*/i)]` |
| `in` | в массиве | `[?(@.color in ['red', 'blue'])]` |
| `nin` | не в массиве | `[?(@.color nin ['red', 'blue'])]` |
| `size()` | размер массива/строки | `[?(@.tags.size() > 2)]` |
| `empty()` | пустой | `[?(@.tags.empty())]` |

---

## 📝 Примеры

**JSON-документ:**

    ```json
    {
    "store": {
        "book": [
        {"title": "Clean Code", "author": "Robert Martin", "price": 45},
        {"title": "The Hobbit", "author": "J.R.R. Tolkien", "price": 25},
        {"title": "1984", "author": "George Orwell", "price": 15}
        ],
        "bicycle": {"color": "red", "price": 120}
    },
    "authors": ["Martin", "Tolkien", "Orwell"]
    }```

### Запросы и результаты

| JPath | Результат |
|-------|----------|
| `$.store.book[*].title` | `["Clean Code", "The Hobbit", "1984"]` |
| `$.store.book[0].author` | `"Robert Martin"` |
| `$.store.book[?(@.price < 30)].title` | `["The Hobbit", "1984"]` |
| `$..author` | `["Robert Martin", "J.R.R. Tolkien", "George Orwell"]` |
| `$.store.book[0:2]` | первые две книги |
| `$.authors[?(@ =~ /.*in/)]` | `["Martin"]` |


???+ example "Пример в python"
    ```python
    from jsonpath_ng import parse
    import json

    data = json.loads('{"store": {"book": [{"title": "1984"}]}}')

    # Найти все заголовки книг
    expr = parse('$.store.book[*].title')
    matches = expr.find(data)

    for match in matches:
    print(match.value)  # 1984
    ```