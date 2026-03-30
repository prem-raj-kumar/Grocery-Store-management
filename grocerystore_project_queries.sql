
-- 1. CUSTOMER INSIGHTS

-- A. How many unique customers have placed orders?
SELECT COUNT(DISTINCT CustomerID) AS UniqueCustomers FROM orders;

-- B. Which customers have placed the highest number of orders?
SELECT o.CustomerID, c.Name, COUNT(o.OrderID) AS OrderCount
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
GROUP BY o.CustomerID, c.Name
ORDER BY OrderCount DESC;

-- C. What is the total and average purchase value per customer?
SELECT o.CustomerID, c.Name,
       SUM(od.TotalPrice) AS TotalPurchase,
       AVG(od.TotalPrice) AS AveragePurchase
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID, c.Name
ORDER BY TotalPurchase DESC;

-- 2. PRODUCT PERFORMANCE

-- A. How many products exist in each category?
SELECT p.CategoryID, cat.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM products p
JOIN categories cat ON p.CategoryID = cat.CategoryID
GROUP BY p.CategoryID, cat.CategoryName
ORDER BY ProductCount DESC;

-- B. What is the average price of products by category?
SELECT p.CategoryID, cat.CategoryName, AVG(p.Price) AS AvgPrice
FROM products p
JOIN categories cat ON p.CategoryID = cat.CategoryID
GROUP BY p.CategoryID, cat.CategoryName
ORDER BY AvgPrice DESC;

-- C. Which products have the highest total sales volume by quantity?
SELECT od.ProductID, p.Name, SUM(od.Quantity) AS TotalQuantity
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.Name
ORDER BY TotalQuantity DESC;

-- 3. SALES AND ORDER TRENDS

-- A. How many orders have been placed in total?
SELECT COUNT(OrderID) AS TotalOrders FROM orders;

-- B. What is the average value per order?
SELECT AVG(total_order.OrderValue) AS AvgOrderValue
FROM (
    SELECT o.OrderID, SUM(od.TotalPrice) AS OrderValue
    FROM orders o
    JOIN orderdetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID
) AS total_order;

-- C. On which dates were the most orders placed?
SELECT OrderDate, COUNT(OrderID) AS OrdersPlaced
FROM orders
GROUP BY OrderDate
ORDER BY OrdersPlaced DESC
LIMIT 10;

-- 4. SUPPLIER CONTRIBUTION

-- A. How many suppliers are there in the database?
SELECT COUNT(SupplierID) AS TotalSuppliers FROM suppliers;

-- B. Which supplier provides the most products?
SELECT p.SupplierID, s.SupplierName, COUNT(p.ProductID) AS ProductCount
FROM products p
JOIN suppliers s ON p.SupplierID = s.SupplierID
GROUP BY p.SupplierID, s.SupplierName
ORDER BY ProductCount DESC;

-- C. What is the average price of products from each supplier?
SELECT p.SupplierID, s.SupplierName, AVG(p.Price) AS AvgProductPrice
FROM products p
JOIN suppliers s ON p.SupplierID = s.SupplierID
GROUP BY p.SupplierID, s.SupplierName
ORDER BY AvgProductPrice DESC;

-- D. Which suppliers contribute the most to total product sales by revenue?
SELECT p.SupplierID, s.SupplierName, SUM(od.TotalPrice) AS TotalRevenue
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
JOIN suppliers s ON p.SupplierID = s.SupplierID
GROUP BY p.SupplierID, s.SupplierName
ORDER BY TotalRevenue DESC;

-- 5. EMPLOYEE PERFORMANCE

-- A. How many employees have processed orders?
SELECT COUNT(DISTINCT EmployeeID) AS ActiveEmployees FROM orders;

-- B. Which employees have handled the most orders?
SELECT o.EmployeeID, e.Name, COUNT(o.OrderID) AS OrdersHandled
FROM orders o
JOIN store_employees e ON o.EmployeeID = e.EmployeeID
GROUP BY o.EmployeeID, e.Name
ORDER BY OrdersHandled DESC;

-- C. What is the total sales value processed by each employee?
SELECT o.EmployeeID, e.Name, SUM(od.TotalPrice) AS TotalSales
FROM orders o
JOIN store_employees e ON o.EmployeeID = e.EmployeeID
JOIN orderdetails od ON o.OrderID = od.OrderID
GROUP BY o.EmployeeID, e.Name
ORDER BY TotalSales DESC;

-- D. What is the average order value handled per employee?
SELECT o.EmployeeID, e.Name, AVG(order_totals.TotalValue) AS AvgOrderValue
FROM orders o
JOIN store_employees e ON o.EmployeeID = e.EmployeeID
JOIN (
    SELECT OrderID, SUM(TotalPrice) AS TotalValue
    FROM orderdetails
    GROUP BY OrderID
) AS order_totals ON o.OrderID = order_totals.OrderID
GROUP BY o.EmployeeID, e.Name
ORDER BY AvgOrderValue DESC;

-- 6. ORDER DETAILS DEEP DIVE

-- A. What is the relationship between quantity ordered and total price?
SELECT Quantity, AVG(TotalPrice) AS AvgTotalPrice
FROM orderdetails
GROUP BY Quantity
ORDER BY Quantity;

-- B. What is the average quantity ordered per product?
SELECT od.ProductID, p.Name, AVG(od.Quantity) AS AvgQuantity
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.Name
ORDER BY AvgQuantity DESC;

-- C. How does the unit price vary across products and orders?
SELECT od.ProductID, p.Name, AVG(od.PriceEach) AS AvgUnitPrice, MIN(od.PriceEach) AS MinUnitPrice, MAX(od.PriceEach) AS MaxUnitPrice
FROM orderdetails od
JOIN products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.Name
ORDER BY AvgUnitPrice DESC;
