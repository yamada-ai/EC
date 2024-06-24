-- テーブルが存在していたら削除する
DROP TABLE IF EXISTS Orders cascade;
DROP TABLE IF EXISTS OrderItems cascade;
DROP TABLE IF EXISTS Items cascade;
DROP TABLE IF EXISTS Sets cascade;
DROP TABLE IF EXISTS OrderStatuses cascade;
DROP TABLE IF EXISTS PaymentMethods cascade;
DROP TABLE IF EXISTS Addresses cascade;
DROP TABLE IF EXISTS Users cascade;
DROP TABLE IF EXISTS Destinations cascade;
DROP TABLE IF EXISTS Favorite cascade;


-- テーブルを作成
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
    prefecture VARCHAR(20) NOT NULL,
	municipalities TEXT NOT NULL,
    address TEXT NOT NULL,
    telephone VARCHAR(20) NOT NULL
);

CREATE TABLE PaymentMethods (
    id SERIAL PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE OrderStatuses (
    id INTEGER PRIMARY KEY,
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

CREATE TABLE Destinations (
    order_id INTEGER NOT NULL REFERENCES Orders(id),
    destination_name TEXT NOT NULL,
    destination_email TEXT NOT NULL,
    address_id INTEGER NOT NULL REFERENCES Addresses(id)
);

CREATE TABLE OrderItems (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES Orders(id),
    item_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    size CHAR(1) NOT NULL
);

-- 商品テーブルを作成するためのSQLコード
CREATE TABLE Items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    item_type VARCHAR(50) NOT NULL CHECK (item_type IN ('top', 'bottom', 'set')),
    image_path VARCHAR(255)
);

-- セット商品テーブルを作成するためのSQLコード
CREATE TABLE Sets (
    id SERIAL PRIMARY KEY,
    item_id INT NOT NULL,
    top_id INT NOT NULL,
    bottom_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES Items(id),
    FOREIGN KEY (top_id) REFERENCES Items(id),
    FOREIGN KEY (bottom_id) REFERENCES Items(id)
);

-- Favoriteテーブルを作成するためのSQLコード
CREATE TABLE Favorite (
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    PRIMARY KEY (user_id, item_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (item_id) REFERENCES Items(id)
);

-- Usersにデータを挿入する
INSERT INTO Users (name, email, password, zipcode, prefecture, municipalities, address, telephone) VALUES
('イオ', 'userone@example.com', 'password1', '123-4567', '東京都', '市町村X', '1番地', '080-1234-5678'),
('ハツ', 'usertwo@example.com', 'password2', '234-5678', '奈良県', '市町村Y', '2番地', '080-2345-6789'),
('ヤス', 'userthree@example.com', 'password3', '345-6789', '千葉県', '市町村Z', '3番地', '080-3456-7890');

-- Addressesにデータを挿入する
INSERT INTO Addresses (user_id, zipcode, prefecture, municipalities, address, telephone)
VALUES
(1, '123-4567', '東京都', '渋谷区', '渋谷1-2-3', '03-1234-5678'),
(2, '234-5678', '大阪府', '難波', '難波4-5-6', '06-2345-6789'),
(3, '345-6789', '京都府', '祇園', '祇園7-8-9', '075-3456-7890');

-- PaymentMethodsテーブルにデータを挿入する
INSERT INTO PaymentMethods (method_name)
VALUES
('代引き'),
('クレジットカード')
;

-- OrderStatusesテーブルにデータを挿入する
INSERT INTO OrderStatuses (id, status_name)
VALUES
(0,'注文前'),
(1,'未入金'),
(2,'入金済'),
(3,'発送済'),
(4,'配送完了'),
(9,'キャンセル');

-- Ordersテーブルにデータを挿入
INSERT INTO Orders (user_id, status_id, total_price, order_date, payment_method_id, delivery_date, address_id)
VALUES
(1, 1, 2500, '2024-06-21 10:00:00', 1, '2024-06-25', 1),
(2, 2, 3000, '2024-06-22 12:30:00', 2, '2024-06-26', 2),
(3, 1, 1800, '2024-06-23 09:45:00', 1, '2024-06-27', 3),
(1, 3, 3500, '2024-06-24 14:15:00', 1, '2024-06-28', 2),
(2, 1, 4000, '2024-06-25 16:20:00', 1, '2024-06-29', 1);


-- Destinationsテーブルに5件の具体的なデータを挿入
INSERT INTO Destinations (order_id, destination_name, destination_email, address_id) VALUES
(1, '配送太郎', 'haisou@example.com', 1),
(2, '洋服次郎', 'youhuku@example.com', 2),
(3, 'サイト三郎', 'site@example.com', 3);



-- OrderItemsテーブルに具体的なデータを挿入
INSERT INTO OrderItems (order_id, item_id, quantity, size) VALUES
(1, 1, 2, 'M'),
(1, 2, 1, 'L'),
(1, 3, 1, 'S'),
(2, 4, 3, 'M'),
(2, 5, 1, 'S'),
(3, 1, 1, 'L'),
(3, 3, 2, 'M'),
(4, 2, 2, 'S'),
(4, 4, 1, 'M'),
(4, 5, 3, 'L'),
(5, 3, 2, 'S'),
(5, 5, 1, 'M'),
(5, 1, 3, 'L'),
(5, 2, 1, 'S'),
(5, 4, 2, 'M');



-- Itemsテーブルにトップスのデータを挿入する
INSERT INTO Items (name, description, price, item_type, image_path)
VALUES
('ベーシックオフィスシャツ', '上品なホワイトカラーのオフィスシャツ。清潔感溢れるデザインで、ビジネスシーンに最適です。', 1000, 'top', 'tshirt.jpg'),
('エレガントウールブレンドジャケット', '上質なウールブレンド素材を使用したエレガントなジャケット。落ち着いた色合いと洗練されたデザインで、ビジネスシーンにも華を添えます。', 3000, 'top', 'jacket.jpg'),
('フリースラグランスウェット', '機能的なフリース素材を使用したラグランスリーブのスウェット。快適な着心地とカジュアルなスタイルが特徴で、デイリーな活動に最適です。', 2500, 'top', 'sweater.jpg'),
('ソフトシルクブラウス', '柔らかなシルク素材のブラウス。軽やかで上品な印象を演出し、オフィスのデスクワークにも最適です。', 3500, 'top', 'blouse.jpg'),
('シンプルタンクトップ', 'シンプルでベーシックなデザインのタンクトップ。涼しげな生地とスリムフィットが体型を美しく見せ、暑い季節にピッタリです。', 1500, 'top', 'tank_top.jpg');


-- Itemsテーブルにボトムスのデータを挿入する
INSERT INTO Items (name, description, price, item_type, image_path)
VALUES
('フォーマルブラックトラウザーズ', 'ビジネスシーンにぴったりのフォーマルなブラックトラウザーズです。', 2500, 'bottom', 'trousers.jpg'),
('ネイビースカート', '華やかなフローラル柄が特徴のネイビースカート。オフィスでの装いを格上げします。', 1800, 'bottom', 'skirt.jpg'),
('グレーパンツ', 'オフィスカジュアルに最適なグレーパンツ。シンプルで使いやすいデザインです。', 2000, 'bottom', 'pants.jpg'),
('ベージュショートパンツ', '快適な夏のオフィススタイルにぴったりのベージュショートパンツ。涼しげなデザインです。', 1500, 'bottom', 'shorts.jpg'),
('オフィスカジュアルレギンス', 'オフィスで着用できるカジュアルなレギンス。快適な素材で長時間着用しても疲れにくい設計です。', 3000, 'bottom', 'leggings.jpg');


-- Itemsテーブルにセットのデータを挿入する
INSERT INTO Items (name, description, price, item_type, image_path)
VALUES
('モダンタックパンツセット', 'モダンなタックパンツとブラウスのセット。トレンド感のあるデザインと快適な着心地が魅力で、オフィスでの長時間の着用に最適です。', 2500, 'set', 'casual_set.jpg'),
('エレガントシャツ＆スカートセット', 'エレガントなシャツとフェミニンなスカートのセット。女性らしいスタイルと上品な印象が特徴で、重要なビジネスミーティングや会議に適しています。', 2500, 'set', 'summer_set.jpg'),
('クラシックブレンドスーツセット', 'クラシックなブレンド素材を使用したスーツセット。シンプルで洗練されたデザインが特徴で、ビジネスの場でも自信を持って着用できます。', 5000, 'set', 'formal_set.jpg');

-- Setテーブルにセットの値を挿入する
INSERT INTO Sets (item_id, top_id, bottom_id)
VALUES
(11, 1, 6),
(12, 5, 7),
(13, 4, 9);

-- Favoriteテーブルにサンプルデータを挿入する
INSERT INTO Favorite (user_id, item_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5);



-- OrderItemsテーブルの全データを表示
SELECT * FROM OrderItems;

-- Ordersテーブルの全データを表示
SELECT * FROM Orders;

-- Setsテーブルの全データを表示
SELECT * FROM Sets;

-- Itemsテーブルの全データを表示
SELECT * FROM Items;

-- OrderStatusesテーブルの全データを表示
SELECT * FROM OrderStatuses;

-- PaymentMethodsテーブルの全データを表示
SELECT * FROM PaymentMethods;

-- Addressesテーブルの全データを表示
SELECT * FROM Addresses;

-- Usersテーブルの全データを表示
SELECT * FROM Users;

-- Destinationsテーブルの全データを表示
SELECT * FROM Destinations;