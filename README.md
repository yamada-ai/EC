
# E-Commerce Site Design

## Database Schema

## User Table
```sql
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    zipcode VARCHAR(20) NOT NULL,
    prefecture TEXT NOT NULL,
    municipalities TEXT NOT NULL,
    address TEXT NOT NULL,
    telephone VARCHAR(20) NOT NULL
);
```

## OrderStatus Table
```sql
CREATE TABLE OrderStatuses (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);
```

## Orders Table
```sql

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    status_id INTEGER NOT NULL REFERENCES OrderStatuses(id),
    total_price INTEGER NOT NULL CHECK (total_price >= 0),
    order_date TIMESTAMP NOT NULL,
    payment_method_id INTEGER NOT NULL REFERENCES PaymentMethods(id),
    delivery_date DATE NOT NULL,
    address_id INTEGER NOT NULL REFERENCES Addresses(id)
);

```

## OrderItems Table
```sql
CREATE TABLE OrderItems (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES Orders(id),
    item_id INTEGER NOT NULL,
    item_type VARCHAR(50) NOT NULL CHECK (item_type IN ('top', 'bottom', 'set')),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    size CHAR(1) NOT NULL
);
```

## Tops Table
```sql
CREATE TABLE Tops (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price INTEGER NOT NULL CHECK (price >= 0),
    image_path TEXT
);
```

## Bottoms Table
```sql
CREATE TABLE Bottoms (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price INTEGER NOT NULL CHECK (price >= 0),
    image_path TEXT
);

```

## Sets Table
```sql
CREATE TABLE Sets (
    id SERIAL PRIMARY KEY,
    top_id INTEGER NOT NULL REFERENCES Tops(id) ON DELETE CASCADE,
    bottom_id INTEGER NOT NULL REFERENCES Bottoms(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price INTEGER NOT NULL CHECK (price >= 0),
    image_path TEXT
);
```

## Address Table
```sql
CREATE TABLE Addresses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    zipcode VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    telephone VARCHAR(20) NOT NULL
);
```

## PaymentMethod Table
```sql
CREATE TABLE PaymentMethods (
    id SERIAL PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);
```


## Inventory Table
```sql
CREATE TABLE Inventory (
    id SERIAL PRIMARY KEY,
    item_id INTEGER NOT NULL,
    item_type VARCHAR(50) NOT NULL CHECK (item_type IN ('top', 'bottom', 'set')),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0),
    FOREIGN KEY (item_id, item_type) REFERENCES (
        SELECT id, 'top' AS item_type FROM TopItem
        UNION
        SELECT id, 'bottom' AS item_type FROM BottomItem
        UNION
        SELECT id, 'set' AS item_type FROM Set
    )
);
```

## FavoriteSet Table
```sql
CREATE TABLE FavoriteSet (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "User"(id),
    set_id INTEGER NOT NULL REFERENCES Set(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

## ComparisonScenario Table
```sql
CREATE TABLE ComparisonScenario (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    image_path TEXT,
    time_of_day VARCHAR(50) NOT NULL CHECK (time_of_day IN ('day', 'night')),
    weather VARCHAR(50) NOT NULL CHECK (weather IN ('sunny', 'rainy')),
    location VARCHAR(50) NOT NULL CHECK (location IN ('office', 'outdoor'))
);
```

## FavoriteSetComparison Table
```sql
CREATE TABLE FavoriteSetComparison (
    id SERIAL PRIMARY KEY,
    favorite_set_id INTEGER NOT NULL REFERENCES FavoriteSet(id),
    comparison_scenario_id INTEGER NOT NULL REFERENCES ComparisonScenario(id),
    comparison_result TEXT
);
```


## 1. User Service

### Domain Model
```java
/**
 * システム内のユーザーを表します。
 */
public class Users {
    private Long id;
    private String name;
    private String email;
    private String password;

    // コンストラクタ、getter、setterは省略
}

/**
 * ユーザーに関連付けられた住所を表します。
 */
public class Addresses {
    private Long id;
    private Long userId;  // 外部キーの代わりにユーザーIDを保持
    private String zipcode;
    private String address;
    private String telephone;

    // コンストラクタ、getter、setterは省略
}
```

## 2. Item Service

### Domain Model
```java
/**
 * トップスのアイテムを表します。
 */
public class Tops {
    private Long id;
    private String name;
    private String description;
    private Integer price;
    private String imagePath;

    // コンストラクタ、getter、setterは省略
}

/**
 * ボトムスのアイテムを表します。
 */
public class Bottoms {
    private Long id;
    private String name;
    private String description;
    private Integer price;
    private String imagePath;

    // コンストラクタ、getter、setterは省略
}

/**
 * トップスとボトムスのセットを表します。
 */
public class Sets {
    private Long id;
    private Long topId;    // 外部キーの代わりにトップスIDを保持
    private Long bottomId; // 外部キーの代わりにボトムスIDを保持
    private String name;
    private String description;
    private Integer price;
    private String imagePath;

    // コンストラクタ、getter、setterは省略
} // Getters and Setters
```

## 3. Inventory Service

### Domain Model
```java
@Entity
public class Inventory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Integer itemId;
    private String itemType;
    private Integer stockQuantity;
    // Getters and Setters
}
```

## 4. Order Service

### Domain Model
```java
/**
 * 注文を表します。
 */
public class Orders {
    private Long id;
    private Long userId;          // 外部キーの代わりにユーザーIDを保持
    private Long statusId;        // 外部キーの代わりにステータスIDを保持
    private Integer totalPrice;
    private java.sql.Timestamp orderDate;
    private Long paymentMethodId; // 外部キーの代わりに支払い方法IDを保持
    private java.sql.Date deliveryDate;
    private Long addressId;       // 外部キーの代わりに住所IDを保持
    private List<OrderItems> orderItems;

    // コンストラクタ、getter、setterは省略
}

@Entity
/**
 * 注文内のアイテムを表します。
 */
public class OrderItems {
    private Long id;
    private Long orderId; // 外部キーの代わりに注文IDを保持
    private Long itemId;  // アイテムIDを保持
    private String itemType;
    private Integer quantity;
    private String size;

    // コンストラクタ、getter、setterは省略
}

public enum OrderStatus {
    BEFORE_ORDER,
    UNPAID,
    PAID,
    SHIPPED,
    DELIVERED,
    CANCELED
}

public enum ItemType {
    TOP,
    BOTTOM,
    SET
}
```

## 5. Payment Service

### Domain Model
```java
@Entity
public class PaymentMethod {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String methodName;
    // Getters and Setters
}
```

## 6. Scenario Service

### Domain Model
```java
@Entity
public class ComparisonScenario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String name;
    private String description;
    private String imagePath;
    @Enumerated(EnumType.STRING)
    private TimeOfDay timeOfDay;
    @Enumerated(EnumType.STRING)
    private Weather weather;
    @Enumerated(EnumType.STRING)
    private Location location;
    // Getters and Setters
}

public enum TimeOfDay {
    DAY,
    NIGHT
}

public enum Weather {
    SUNNY,
    RAINY
}

public enum Location {
    OFFICE,
    OUTDOOR
}

@Entity
public class FavoriteSet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Integer userId;
    private Integer setId;
    private LocalDateTime createdAt;
    // Getters and Setters
}

@Entity
public class FavoriteSetComparison {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Integer favoriteSetId;
    private Integer comparisonScenarioId;
    private String comparisonResult;
    // Getters and Setters
}
```


### Paths

| Path | Method | Summary | Request Body | Response |
|------|--------|---------|--------------|----------|
| /users | POST | Create a new user | [User](#user) | 201: [User](#user) |
| /users/{userId} | GET | Get user information | - | 200: [User](#user) |
| /users/{userId} | PUT | Update user information | [User](#user) | 200: [User](#user) |
| /auth/login | POST | Login a user | [LoginRequest](#loginrequest) | 200: [LoginResponse](#loginresponse) |
| /auth/logout | POST | Logout a user | - | 200: User logged out |
| /items | GET | Get list of items | - | 200: Array of [Item](#item) |
| /items/{itemType} | GET | Get item details | - | 200: Array of [Item](#item) |
| /items/{itemType}/{itemId} | GET | Get item details | - | 200: [Item](#item) |
| /inventory | GET | Get inventory list | - | 200: Array of [Inventory](#inventory) |
| /inventory/{itemId}/{itemType} | GET | Get inventory for a specific item | - | 200: [Inventory](#inventory) |
| /orders | POST | Create a new order | [Order](#order) | 201: [Order](#order) |
| /orders/{userId} | GET | Get order history for a user | - | 200: Array of [Order](#order) |
| /orders/{orderId}/status | PUT | Update order status | [OrderStatusUpdate](#orderstatusupdate) | 200: Order status updated |
| /payment-methods | GET | Get list of payment methods | - | 200: Array of [PaymentMethod](#paymentmethod) |
| /payment-methods/{paymentMethodId} | PUT | Update a payment method | [PaymentMethod](#paymentmethod) | 200: [PaymentMethod](#paymentmethod) |
| /scenarios | GET | Get list of scenarios | - | 200: Array of [ComparisonScenario](#comparisonscenario) |
| /scenarios/{scenarioId} | PUT | Update a scenario | [ComparisonScenario](#comparisonscenario) | 200: [ComparisonScenario](#comparisonscenario) |
| /favorites | POST | Register a favorite set | [FavoriteSet](#favoriteset) | 201: [FavoriteSet](#favoriteset) |
| /favorites/{userId} | GET | Get favorite sets for a user | - | 200: Array of [FavoriteSet](#favoriteset) |
| /favorites/comparison | POST | Register a favorite set comparison result | [FavoriteSetComparison](#favoritesetcomparison) | 201: [FavoriteSetComparison](#favoritesetcomparison) |

### API Schemas(仮)

#### User

| Field | Type | Description |
|-------|------|-------------|
| id | integer | User ID |
| name | string | User name |
| email | string | User email |
| password | string | User password |
| zipcode | string | User zipcode |
| address | string | User address |
| telephone | string | User telephone |

#### LoginRequest

| Field | Type | Description |
|-------|------|-------------|
| email | string | User email |
| password | string | User password |

#### LoginResponse

| Field | Type | Description |
|-------|------|-------------|
| token | string | Authentication token |

#### Item

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Item ID |
| name | string | Item name |
| description | string | Item description |
| price | integer | Item price |
| imagePath | string | Item image path |

#### TopItem

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Top item ID |
| name | string | Top item name |
| description | string | Top item description |
| price | integer | Top item price |
| imagePath | string | Top item image path |
| deleted | boolean | Top item deletion status |

#### BottomItem

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Bottom item ID |
| name | string | Bottom item name |
| description | string | Bottom item description |
| price | integer | Bottom item price |
| imagePath | string | Bottom item image path |
| deleted | boolean | Bottom item deletion status |

#### Set

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Set ID |
| topItemId | integer | Top item ID |
| bottomItemId | integer | Bottom item ID |
| name | string | Set name |
| description | string | Set description |
| price | integer | Set price |
| imagePath | string | Set image path |

#### Inventory

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Inventory ID |
| itemId | integer | Item ID |
| itemType | string | Item type |
| stockQuantity | integer | Stock quantity |

#### Order

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Order ID |
| userId | integer | User ID |
| status | string | Order status (BEFORE_ORDER, UNPAID, PAID, SHIPPED, DELIVERED, CANCELED) |
| totalPrice | integer | Total price |
| orderDate | string | Order date (date-time) |
| paymentMethodId | integer | Payment method ID |
| deliveryDate | string | Delivery date (date) |
| addressId | integer | Address ID |
| items | array | Array of [OrderItem](#orderitem) |

#### OrderItem

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Order item ID |
| orderId | integer | Order ID |
| itemId | integer | Item ID |
| itemType | string | Item type (TOP, BOTTOM, SET) |
| quantity | integer | Quantity |
| size | string | Size |

#### OrderStatusUpdate

| Field | Type | Description |
|-------|------|-------------|
| status | string | Order status (BEFORE_ORDER, UNPAID, PAID, SHIPPED, DELIVERED, CANCELED) |

#### PaymentMethod

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Payment method ID |
| methodName | string | Method name |

#### ComparisonScenario

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Scenario ID |
| name | string | Scenario name |
| description | string | Scenario description |
| imagePath | string | Scenario image path |
| timeOfDay | string | Time of day (DAY, NIGHT) |
| weather | string | Weather (SUNNY, RAINY) |
| location | string | Location (OFFICE, OUTDOOR) |

#### FavoriteSet

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Favorite set ID |
| userId | integer | User ID |
| setId | integer | Set ID |
| createdAt | string | Creation date (date-time) |

#### FavoriteSetComparison

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Comparison ID |
| favoriteSetId | integer | Favorite set ID |
| comparisonScenarioId | integer | Scenario ID |
| comparisonResult | string | Comparison result |


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

### UserController
```java
@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping
    public ResponseEntity<User> registerUser(@RequestBody User user) {
        User createdUser = userService.registerUser(user);
        return new ResponseEntity<>(createdUser, HttpStatus.CREATED);
    }
}

```

### AuthController
```java
@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        String token = authService.login(request.getEmail(), request.getPassword());
        return ResponseEntity.ok(new LoginResponse(token));
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestHeader("Authorization") String token) {
        authService.logout(token);
        return ResponseEntity.ok().build();
    }
}
```

### ItemController
```java
@RestController
@RequestMapping("/items")
public class ItemController {

    @Autowired
    private ItemService itemService;

    // この型では上手く返せない
    @GetMapping
    public ResponseEntity<List<Item>> getAllItems() {
        List<Item> items = itemService.getAllItems();
        return ResponseEntity.ok(items);
    }

    // タイプを指定して全商品を取得する
    // Set かそれ以外かで型が異なるのが辛いのでどう対処すべきか
    @GetMapping("/{itemType}")
    public ResponseEntity<List<Item>> getItemsByType(@PathVariable String itemType) {
        List<Item> items = itemService.getItemsByType(itemType);
        return ResponseEntity.ok(items);
    }

    // タイプとid を指定して詳細を取得する
    @GetMapping("/{itemType}/{itemId}")
    public ResponseEntity<Item> getItemDetail(@PathVariable String itemType, @PathVariable Integer itemId) {
        Item item = itemService.getItemDetail(itemType, itemId);
        return ResponseEntity.ok(item);
    }
}

```


### CartController.
```java
@RestController
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping
    public ResponseEntity<Void> addItemToCart(@RequestBody CartItemRequest request) {
        cartService.addItemToCart(request);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{itemId}")
    public ResponseEntity<Void> removeItemFromCart(@PathVariable Integer itemId) {
        cartService.removeItemFromCart(itemId);
        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<List<CartItem>> getCartItems() {
        List<CartItem> items = cartService.getCartItems();
        return ResponseEntity.ok(items);
    }
}


```

### OrderController.

```java
@RestController
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // このorderの作り方がいまいち納得いかない
    @PostMapping
    public ResponseEntity<Order> placeOrder(@RequestBody OrderRequest request) {
        Order order = orderService.placeOrder(request);
        return new ResponseEntity<>(order, HttpStatus.CREATED);
    }

    // 注文履歴を取得する
    @GetMapping("/history/{userId}")
    public ResponseEntity<List<Order>> getOrderHistory(@PathVariable Integer userId) {
        List<Order> orders = orderService.getOrderHistory(userId);
        return ResponseEntity.ok(orders);
    }
}

```
フロント側にお願いしたいこと
- CSSを充てる
    - 商品詳細
    - カート
    - 注文確認画面
    - 注文完了画面
    - ログイン画面
- 追加機能を考える
    - お気に入り機能を実現するためのUI，仕様
