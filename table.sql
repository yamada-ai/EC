-- User Service

CREATE TABLE User (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    zipcode VARCHAR(20),
    address VARCHAR(255),
    telephone VARCHAR(20)
);



-- Order Service

CREATE TABLE Order (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES User(id),
    status VARCHAR(50),
    total_price INTEGER,
    order_date TIMESTAMP,
    address_id
);

-- Order Detail Service
CREATE TABLE OrderItem (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES Order(id),
    item_id INTEGER REFERENCES Item(id),
    quantity INTEGER,
    size CHAR(1)
);

CREATE TABLE OrderTopping (
    id SERIAL PRIMARY KEY,
    order_item_id INTEGER REFERENCES OrderItem(id),
    topping_id INTEGER REFERENCES Topping(id)
);


-- Item Service

CREATE TABLE Item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    price_m INTEGER,
    price_l INTEGER,
    image_path VARCHAR(255),
    deleted BOOLEAN
);

CREATE TABLE Topping (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    price_m INTEGER,
    price_l INTEGER
);

CREATE TABLE ItemTopping (
    item_id INTEGER REFERENCES Item(id),
    topping_id INTEGER REFERENCES Topping(id),
    PRIMARY KEY (item_id, topping_id)
);


-- Address Service
CREATE TABLE Address (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES User(id),
    name VARCHAR(255),
    email VARCHAR(255),
    zipcode VARCHAR(20),
    prefecture VARCHAR(255),
    address VARCHAR(255),
    telephone VARCHAR(20)
);
