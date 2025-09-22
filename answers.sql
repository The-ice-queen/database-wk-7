-- Assignment: Database Design and Normalization
-- Full Script: 1NF -> 2NF -> 3NF

USE salesdb;

-- ---------------------------
-- Clean up old tables (in correct order)
-- ---------------------------
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS OrderProducts_3NF;
DROP TABLE IF EXISTS OrderProducts;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS ProductDetail_1NF;
SET FOREIGN_KEY_CHECKS = 1;

------------------------------------------------------------
-- QUESTION 1: 1NF (First Normal Form)
------------------------------------------------------------
CREATE TABLE ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
) ENGINE=InnoDB;

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

------------------------------------------------------------
-- QUESTION 2: 2NF (Second Normal Form)
------------------------------------------------------------
-- Parent table: Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
) ENGINE=InnoDB;

INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Child table: OrderProducts
CREATE TABLE OrderProducts (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product),
    CONSTRAINT fk_order FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO OrderProducts (OrderID, Product) VALUES
(101, 'Laptop'),
(101, 'Mouse'),
(102, 'Tablet'),
(102, 'Keyboard'),
(102, 'Mouse'),
(103, 'Phone');

------------------------------------------------------------
-- QUESTION 3: 3NF (Third Normal Form)
------------------------------------------------------------
-- Parent table: Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO Products (ProductID, ProductName) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Tablet'),
(4, 'Keyboard'),
(5, 'Phone');

-- Junction table: OrderProducts_3NF
CREATE TABLE OrderProducts_3NF (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    CONSTRAINT fk_op3_orders FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_op3_products FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO OrderProducts_3NF (OrderID, ProductID) VALUES
(101, 1), -- Laptop
(101, 2), -- Mouse
(102, 3), -- Tablet
(102, 4), -- Keyboard
(102, 2), -- Mouse
(103, 5); -- Phone

------------------------------------------------------------
-- Check results
------------------------------------------------------------
SELECT * FROM ProductDetail_1NF;
SELECT * FROM Orders;
SELECT * FROM OrderProducts;
SELECT * FROM Products;
SELECT * FROM OrderProducts_3NF;
