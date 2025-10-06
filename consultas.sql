CREATE DATABASE AmazonSales;

USE AmazonSales;

-- LIMPIEZA DE DATOS

-- Agregar las nuevas columnas
ALTER TABLE AmazonSales ADD Country VARCHAR(50), State VARCHAR(50), City VARCHAR(50);

-- Agregar los datos a las nuevas columnas
UPDATE AmazonSales
SET 
    Country = PARSENAME(REPLACE(Geography, ',', '.'), 3),
	State = PARSENAME(REPLACE(Geography, ',', '.'), 1),
	City = PARSENAME(REPLACE(Geography, ',', '.'), 2);

-- Redondear valores a dos decimales
UPDATE AmazonSales SET Sales = ROUND(Sales, 2);

UPDATE AmazonSales SET Profit = ROUND(Profit, 2);

-- Cambiar el tipo de dato de la columna Quantity
ALTER TABLE AmazonSales ALTER COLUMN Quantity FLOAT;
ALTER TABLE AmazonSales ALTER COLUMN Quantity INT;


-- CONSULTAS A KPIS CLAVES DEL NEGOCIO

-- 1. Total de Ventas (Total Sales)
SELECT ROUND(SUM(Sales), 2) AS Total_Sales FROM AmazonSales;

-- 2. Utilidad Total (Total Profit)
SELECT SUM(Profit) AS Total_Profit FROM AmazonSales;

-- 3. Total de Costos (Total Cost)
SELECT
	(SELECT ROUND(SUM(Sales), 2) AS Total_Sales FROM AmazonSales) -
	(SELECT SUM(Profit) AS Total_Profit FROM AmazonSales) AS Total_Cost;

-- 4. Margen de Utilidad (Profit Margin_Porcentage)
SELECT
	ROUND(
		(SELECT SUM(Profit) AS Total_Profit FROM AmazonSales) /
		(SELECT ROUND(SUM(Sales), 2) AS Total_Sales FROM AmazonSales) * 100, 2
	) AS Profit_Margin_Porcentage;

-- 5. Cantidad de Productos Vendidos (Number of Products Sold)
SELECT SUM(Quantity) AS Products_Sold FROM AmazonSales;

-- 6. Tiempo Promedio de Envío (Average Shipping Time)
SELECT 
    AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Avg_Shipping_Time_Days
FROM AmazonSales;

-- 7. Ventas por Categoría (Sales by Category)
SELECT 
    Category, 
    SUM(Sales) AS Total_Sales_By_Category
FROM AmazonSales
GROUP BY Category;

-- 8. Ventas por Estado (Sales by State)
SELECT 
    State,
	COUNT(State) AS Number_Sales_State,
    SUM(Sales) AS Total_Sales_By_State
FROM AmazonSales
GROUP BY State
ORDER BY Total_Sales_By_State DESC;

-- 9. Ventas por Ciudad (Sales by City)
SELECT 
    City,
	COUNT(City) AS Number_Sales_City,
    SUM(Sales) AS Total_Sales_By_City
FROM AmazonSales
GROUP BY City
ORDER BY Total_Sales_By_City DESC;

-- 10. Top 10 Productos Más Vendidos (Top 10 Best-Selling Products)
SELECT 
	TOP(10)
	Product_Name,
	SUM(Quantity) AS Top_Best_Selling_Products
FROM AmazonSales
GROUP BY Product_Name
ORDER BY Top_Best_Selling_Products DESC;
