
# E-Commerce Site Design

## Domain Model Overview

### 1. User (ユーザー)
- **Attributes:**
  - id: Integer
  - name (名前): String
  - email (メールアドレス): String
  - password (パスワード): String
  - zipcode (郵便番号): String
  - address (住所): String
  - telephone (電話番号): String

### 2. Order (注文)
- **Attributes:**
  - id: Integer
  - user_id (ユーザーID): Integer
  - status: Status (an enum representing different statuses such as ordered, shipped, delivered, etc.)
  - total_price (合計金額): Integer
  - order_date (注文日): java.util.Date
  - address_id (配送先ID): Integer

### 3. OrderItem (注文商品)
- **Attributes:**
  - id: Integer
  - order_id (注文ID): Integer
  - item_id (商品ID): Integer
  - quantity (注文数): Integer
  - size (サイズ): Character

### 4. OrderTopping (注文トッピング)
- **Attributes:**
  - id: Integer
  - order_item_id (注文商品ID): Integer
  - topping_id (トッピングID): Integer

### 5. Item (商品)
- **Attributes:**
  - id: Integer
  - name (名前): String
  - description (説明): String
  - price_m (Mの値段): Integer
  - price_l (Lの値段): Integer
  - image_path (画像パス): String
  - deleted (削除フラグ): Boolean

### 6. Topping (トッピング)
- **Attributes:**
  - id: Integer
  - name (名前): String
  - price_m (Mの値段): Integer
  - price_l (Lの値段): Integer

### 7. Address (配送先)
- **Attributes:**
  - id: Integer
  - user_id (ユーザーID): Integer
  - name (名前): String
  - email (メールアドレス): String
  - zipcode (郵便番号): String
  - prefecture (都道府県): String
  - address (住所): String
  - telephone (電話番号): String

## Service Breakdown

### User Service
- **Purpose:** Manage user information
- **Database Table:** User

### Order Service
- **Purpose:** Manage basic order information
- **Database Table:** Order

### Order Detail Service
- **Purpose:** Manage order item details
- **Database Table:** OrderItem, OrderTopping

### Item Service
- **Purpose:** Manage item and topping information
- **Database Table:** Item, Topping, ItemTopping

### Address Service
- **Purpose:** Manage delivery address information
- **Database Table:** Address

## Database Schema

### User Table
```sql
CREATE TABLE User (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    zipcode VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL
);

```

### Order Table
```sql
CREATE TABLE Order (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES User(id),
    status VARCHAR(50) NOT NULL,
    total_price INTEGER NOT NULL CHECK (total_price >= 0),
    order_date TIMESTAMP NOT NULL,
    address_id INTEGER NOT NULL REFERENCES Address(id)
);
```

### OrderItem Table
```sql
CREATE TABLE OrderItem (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES Order(id),
    item_id INTEGER NOT NULL REFERENCES Item(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    size CHAR(1) NOT NULL
);
```

### OrderTopping Table
```sql
CREATE TABLE OrderTopping (
    id SERIAL PRIMARY KEY,
    order_item_id INTEGER NOT NULL REFERENCES OrderItem(id),
    topping_id INTEGER NOT NULL REFERENCES Topping(id)
);
```

### Item Table
```sql
CREATE TABLE Item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price_m INTEGER NOT NULL CHECK (price_m >= 0),
    price_l INTEGER NOT NULL CHECK (price_l >= 0),
    image_path VARCHAR(255),
    deleted BOOLEAN NOT NULL DEFAULT FALSE
);
```

### Topping Table
```sql
CREATE TABLE Topping (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price_m INTEGER NOT NULL CHECK (price_m >= 0),
    price_l INTEGER NOT NULL CHECK (price_l >= 0)
);
```

### ItemTopping Table
```sql
CREATE TABLE ItemTopping (
    item_id INTEGER NOT NULL REFERENCES Item(id),
    topping_id INTEGER NOT NULL REFERENCES Topping(id),
    PRIMARY KEY (item_id, topping_id)
);
```

### Address Table
```sql
CREATE TABLE Address (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES User(id),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    zipcode VARCHAR(20) NOT NULL,
    prefecture VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL
);
```

## ユースケース
1. ユーザを登録する
2. ログイン/ログアウトする
3. 商品一覧を表示する
4. 商品詳細を表示する
5. ショッピングカートから商品を追加/削除/中身を表示する
6. 注文確認画面を表示する
7. 注文をする
8. 注文履歴を表示する

## 画面一覧
- ユーザ登録
- ログイン
- 商品一覧
- 商品詳細
- ショッピングカートの中
- 注文確認
- 注文完了


## Controller
- UserRegistrationController
  - /user
  - POST
    - /registration
      - ユーザを登録する
      - UserRegistrationForm

- LoginController
  - /user
  - POST
    - /login
      - ログインする
    - /logout
      - ログアウトする

- ItemController
  - /item
  - GET
    - /all
      - 全ての商品を取得する
    - /detail
      - 商品詳細を取得する
  
  - OrderControler
    - /order
    - GET


## Domain
- 