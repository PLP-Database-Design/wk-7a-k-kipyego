-- Question 1: Achieving 1NF (First Normal Form)
-- Transform ProductDetail table to ensure each row has a single product per order
-- Assuming original table named ProductDetail(OrderID, CustomerName, Products)
-- Use a sequence table to split the Products string into individual rows

CREATE TABLE ProductDetail_1NF AS
SELECT
  OrderID,
  CustomerName,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', seq.num), ',', -1)) AS Product
FROM ProductDetail
JOIN (
  SELECT 1 AS num UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
) AS seq
  ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= seq.num - 1;

-- Note: Adjust the seq subquery for the maximum number of comma-separated products in Products.

-- Question 2: Achieving 2NF (Second Normal Form)
-- Remove the partial dependency of CustomerName on OrderID by splitting into Orders and OrderItems

-- Create Orders table with OrderID as primary key
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(100)
);

-- Populate Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create OrderItems table with full dependency on composite key (OrderID, Product)
CREATE TABLE OrderItems (
  OrderID INT,
  Product VARCHAR(100),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Populate OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
