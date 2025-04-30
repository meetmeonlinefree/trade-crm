# Warehouse & Orders API

RESTful API для управления складами, товарами, заказами и их движениями.

## 📦 Установки

1. Клонировать репозиторий
```bash
git clone https://github.com/your-username/your-repo.git
```

2. Установить зависимости
```bash
composer install
```

3. Настроить `.env` и запустить миграции
```bash
php artisan migrate
```

4. Запустить сервер
```bash
php artisan serve
```

## 📚 API Маршруты

### Склады
| Метод | Маршрут | Описание |
|-------|---------|----------|
| GET | `/api/warehouses` | Получить список складов |

### Товары с остатками
| Метод | Маршрут | Описание |
|-------|---------|----------|
| GET | `/api/products-with-stocks` | Получить список товаров с остатками |

### Заказы
| Метод | Маршрут | Описание |
|-------|---------|----------|
| GET | `/api/orders` | Получить список заказов |
| POST | `/api/orders` | Создать новый заказ |
| PUT | `/api/orders/{order}` | Обновить заказ |
| POST | `/api/orders/{order}/complete` | Завершить заказ |
| POST | `/api/orders/{order}/cancel` | Отменить заказ |
| POST | `/api/orders/{order}/resume` | Возобновить заказ |

### Движения товаров
| Метод | Маршрут | Описание |
|-------|---------|----------|
| GET | `/api/product-movements` | Получить историю движений товаров |

## ⚙️ Примеры запросов

### Создание заказа
```bash
POST /api/orders
```
```json
{
  "customer": "John Doe",
  "warehouse_id": 1,
  "items": [
    { "product_id": 2, "count": 3 },
    { "product_id": 5, "count": 1 }
  ]
}
```

### Завершение заказа
```bash
POST /api/orders/1/complete
```

## 🛠️ Технологии
- Laravel (Lumen или Full Laravel)
- PHP
- MySQL (или другая СУБД)

## ✍️ Автор
[Ваше имя или никнейм](https://github.com/your-username)

## 📝 Лицензия
Этот проект лицензируется под MIT License.

