-- Drop tables if they exist
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Sets;
DROP TABLE IF EXISTS Tops;
DROP TABLE IF EXISTS Bottoms;
DROP TABLE IF EXISTS OrderStatuses;
DROP TABLE IF EXISTS PaymentMethods;
DROP TABLE IF EXISTS Addresses;
DROP TABLE IF EXISTS Users;

-- Create tables
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

CREATE TABLE Addresses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES Users(id),
    zipcode VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    telephone VARCHAR(20) NOT NULL
);

CREATE TABLE PaymentMethods (
    id SERIAL PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE OrderStatuses (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

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

CREATE TABLE OrderItems (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES Orders(id),
    item_id INTEGER NOT NULL,
    item_type VARCHAR(50) NOT NULL CHECK (item_type IN ('top', 'bottom', 'set')),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    size CHAR(1) NOT NULL
);

CREATE TABLE Tops (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price INTEGER NOT NULL CHECK (price >= 0),
    image_path TEXT
);

CREATE TABLE Bottoms (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price INTEGER NOT NULL CHECK (price >= 0),
    image_path TEXT
);

CREATE TABLE Sets (
    id SERIAL PRIMARY KEY,
    top_id INTEGER NOT NULL REFERENCES Tops(id),
    bottom_id INTEGER NOT NULL REFERENCES Bottoms(id),
    name TEXT NOT NULL,
    description TEXT,
    price INTEGER NOT NULL CHECK (price >= 0),
    image_path TEXT
);

-- Insert initial data
INSERT INTO Users (name, email, password, zipcode, prefecture, municipalities, address, telephone) VALUES
('User One', 'userone@example.com', 'password1', '123-4567', 'Prefecture A', 'City X', 'Street 1', '080-1234-5678'),
('User Two', 'usertwo@example.com', 'password2', '234-5678', 'Prefecture B', 'City Y', 'Street 2', '080-2345-6789'),
('User Three', 'userthree@example.com', 'password3', '345-6789', 'Prefecture C', 'City Z', 'Street 3', '080-3456-7890');

INSERT INTO Addresses (user_id, zipcode, address, telephone)
VALUES
(1, '12345', '123 Main St', '123-456-7890'),
(2, '67890', '456 Elm St', '987-654-3210'),
(3, '11223', '789 Oak St', '456-789-0123');

INSERT INTO PaymentMethods (method_name)
VALUES
('Credit Card'),
('PayPal'),
('Bank Transfer');

INSERT INTO OrderStatuses (status_name)
VALUES
('BEFORE_ORDER'),
('UNPAID'),
('PAID'),
('SHIPPED'),
('DELIVERED'),
('CANCELED');



INSERT INTO Tops (name, description, price, image_path)
VALUES
('Red T-Shirt', 'A red t-shirt', 1000, '/images/red_tshirt.png'),
('Blue T-Shirt', 'A blue t-shirt', 1500, '/images/blue_tshirt.png'),
('Green T-Shirt', 'A green t-shirt', 2000, '/images/green_tshirt.png');

INSERT INTO Bottoms (name, description, price, image_path)
VALUES
('Jeans', 'Blue jeans', 3000, '/images/jeans.png'),
('Shorts', 'Black shorts', 2000, '/images/shorts.png'),
('Skirt', 'White skirt', 2500, '/images/skirt.png');

INSERT INTO Sets (top_id, bottom_id, name, description, price, image_path)
VALUES
(1, 1, 'Red T-Shirt and Jeans', 'A red t-shirt and blue jeans', 3500, '/images/red_tshirt_jeans.png'),
(2, 2, 'Blue T-Shirt and Shorts', 'A blue t-shirt and black shorts', 3500, '/images/blue_tshirt_shorts.png'),
(3, 3, 'Green T-Shirt and Skirt', 'A green t-shirt and white skirt', 4500, '/images/green_tshirt_skirt.png');


INSERT INTO Orders (user_id, status_id, total_price, order_date, payment_method_id, delivery_date, address_id)
VALUES
(1, 3, 5000, '2024-06-18 10:00:00', 1, '2024-06-20', 1),
(1, 1, 5000, '2024-06-18 10:00:00', 1, '2024-06-20', 1);

INSERT INTO OrderItems (order_id, item_id, item_type, quantity, size)
VALUES
(1, 1, 'top', 2, 'M'),
(1, 1, 'bottom', 1, 'L'),
(1, 3, 'set', 1, 'S');
