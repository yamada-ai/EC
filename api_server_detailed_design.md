
# API Server Detailed Design

## Use Cases
1. Register User
2. Login/Logout
3. Display Item List
4. Display Item Details
5. Add/Remove/View Items in Shopping Cart
6. Display Order Confirmation
7. Place Order
8. Display Order History

## Design Details

### 1. Register User

**Controller**
- Endpoint: `POST /users`
- Request: `UserRegistrationForm`
- Response: `ResponseEntity<User>`

**Service**
- Method: `registerUser(UserRegistrationForm form)`
- Request: `UserRegistrationForm`
- Response: `User`

**Repository**
- Method: `save(User user)`
- Request: `User`
- Response: `User`

**Form**
- `UserRegistrationForm`: name, email, password, zipcode, address, telephone

**Domain**
- `User`: id, name, email, password, zipcode, address, telephone

### 2. Login/Logout

**Controller**
- Endpoint: `POST /login`
- Request: `LoginForm`
- Response: `ResponseEntity<String>` (JWT Token)

- Endpoint: `POST /logout`
- Request: None
- Response: `ResponseEntity<Void>`

**Service**
- Method: `login(LoginForm form)`
- Request: `LoginForm`
- Response: `String` (JWT Token)

- Method: `logout()`
- Request: None
- Response: void

**Repository**
- Method: `findByEmail(String email)`
- Request: `String`
- Response: `User`

**Form**
- `LoginForm`: email, password

**Domain**
- `User`: id, name, email, password, zipcode, address, telephone

### 3. Display Item List

**Controller**
- Endpoint: `GET /items`
- Request: None
- Response: `ResponseEntity<List<Item>>`

**Service**
- Method: `getAllItems()`
- Request: None
- Response: `List<Item>`

**Repository**
- Method: `findAll()`
- Request: None
- Response: `List<Item>`

**Form**
- None

**Domain**
- `Item`: id, name, description, price_m, price_l, image_path, deleted

### 4. Display Item Details

**Controller**
- Endpoint: `GET /items/{id}`
- Request: `Long id`
- Response: `ResponseEntity<Item>`

**Service**
- Method: `getItemById(Long id)`
- Request: `Long id`
- Response: `Item`

**Repository**
- Method: `findById(Long id)`
- Request: `Long id`
- Response: `Optional<Item>`

**Form**
- None

**Domain**
- `Item`: id, name, description, price_m, price_l, image_path, deleted

### 5. Add/Remove/View Items in Shopping Cart

**Controller**
- Endpoint: `POST /cart/items`
    - Request: `CartItemForm`
    - Response: `ResponseEntity<Cart>`

- Endpoint: `DELETE /cart/items/{id}`
    - Request: `Long id`
    - Response: `ResponseEntity<Cart>`

- Endpoint: `GET /cart`
    - Request: None
    - Response: `ResponseEntity<Cart>`

**Service**
- Method: `addItemToCart(CartItemForm form)`
    - Request: `CartItemForm`
    - Response: `Cart`

- Method: `removeItemFromCart(Long id)`
    - Request: `Long id`
    - Response: `Cart`

- Method: `getCart()`
    - Request: None
    - Response: `Cart`

**Repository**
- Method: `save(Cart cart)`
    - Request: `Cart`
    - Response: `Cart`

**Form**
- `CartItemForm`: itemId, quantity, size

**Domain**
- `Cart`: id, userId, items
- `CartItem`: id, itemId, quantity, size

### 6. Display Order Confirmation

**Controller**
- Endpoint: `GET /orders/confirmation`
- Request: None
- Response: `ResponseEntity<OrderConfirmation>`

**Service**
- Method: `getOrderConfirmation()`
- Request: None
- Response: `OrderConfirmation`

**Repository**
- Method: `findByUserId(Long userId)`
- Request: `Long userId`
- Response: `List<Order>`

**Form**
- None

**Domain**
- `OrderConfirmation`: order, user, address

### 7. Place Order

**Controller**
- Endpoint: `POST /orders`
- Request: `OrderForm`
- Response: `ResponseEntity<Order>`

**Service**
- Method: `placeOrder(OrderForm form)`
- Request: `OrderForm`
- Response: `Order`

**Repository**
- Method: `save(Order order)`
- Request: `Order`
- Response: `Order`

**Form**
- `OrderForm`: addressId, paymentMethod

**Domain**
- `Order`: id, userId, status, totalPrice, orderDate, addressId

### 8. Display Order History

**Controller**
- Endpoint: `GET /orders/history`
- Request: None
- Response: `ResponseEntity<List<Order>>`

**Service**
- Method: `getOrderHistory()`
- Request: None
- Response: `List<Order>`

**Repository**
- Method: `findByUserId(Long userId)`
- Request: `Long userId`
- Response: `List<Order>`

**Form**
- None

**Domain**
- `Order`: id, userId, status, totalPrice, orderDate, addressId

## Implementation Priority

1. **Register User** (User Registration)
2. **Login/Logout** (Authentication)
3. **Display Item List**
4. **Display Item Details**
5. **Add/Remove/View Items in Shopping Cart**
6. **Display Order Confirmation**
7. **Place Order**
8. **Display Order History**
