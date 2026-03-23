### **docs/frontend.md**

# Frontend

## Программа изучения

### 1. React
[Перейти к разделу](#react) - Библиотека для UI

### 2. Vue.js
[Перейти к разделу](#vue) - Прогрессивный фреймворк

### 3. TypeScript
[Перейти к разделу](#typescript) - Типизированный JavaScript

---

## React {#react}

### Компоненты

??? example "Функциональный компонент с хуками"
    ```jsx
    import React, { useState, useEffect } from 'react';
    
    const UserProfile = ({ userId }) => {
        const [user, setUser] = useState(null);
        const [loading, setLoading] = useState(true);
        
        useEffect(() => {
            fetch(`/api/users/${userId}`)
                .then(res => res.json())
                .then(data => {
                    setUser(data);
                    setLoading(false);
                });
        }, [userId]);
        
        if (loading) return <div>Loading...</div>;
        
        return (
            <div>
                <h1>{user.name}</h1>
                <p>Email: {user.email}</p>
            </div>
        );
    };
    
    export default UserProfile;