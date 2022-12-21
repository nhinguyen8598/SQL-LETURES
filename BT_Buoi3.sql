USE [BikeStores]
GO

-- BT1: Viết truy vấn lấy toàn bộ thông tin khách hàng (customers) với first_name 
--		có ký tự kế cuối trong khoảng từ 't' đến 'z' và zip_code bắt đầu bằng '11', 
--		sắp xếp theo first_name.
SELECT 
	[customer_id]
	,[first_name]
	,[last_name]
	,[phone]
	,[email]
	,[street]
	,[city]
	,[state]
	,[zip_code]
FROM [BikeStores].[sales].[customers]
WHERE [first_name] LIKE '%[T-Z]_'
	AND [zip_code] LIKE '11%'
ORDER BY [first_name]

-- BT2: Viết truy vấn lấy toàn bộ thông tin sản phẩm (products) 
--		có giá (list_price) bằng 999.99 hoặc 1999.99 hoặc 2999.99.
-- Cách 1
SELECT 
	[product_id]
    ,[product_name]
    ,[brand_id]
    ,[category_id]
    ,[model_year]
    ,[list_price]
FROM [BikeStores].[production].[products]
WHERE [list_price] = 999.99
	OR [list_price] = 1999.99
	OR [list_price] = 2999.99

-- Cách 2
SELECT 
	[product_id]
    ,[product_name]
    ,[brand_id]
    ,[category_id]
    ,[model_year]
    ,[list_price]
FROM [BikeStores].[production].[products]
WHERE [list_price] IN (999.99, 1999.99, 2999.99)

-- BT3: Viết truy vấn trả về tổng số lượng sản phẩm có tên bắt đầu bằng 'Trek' 
--		và có giá trong khoảng từ 199.99 đến 999.99.
SELECT 
      COUNT(product_name) AS [Tổng số lượng sản phẩm]
FROM [BikeStores].[production].[products]
WHERE [product_name] LIKE 'Trek%'
	AND ([list_price] BETWEEN 199.99 AND 999.99)

-- BT4: Viết truy vấn trả về tên sản phẩm, tổng giá và tổng số lượng sản phẩm 
--		với những sản phẩm có từ khóa 'Ladies' bên trong tên sản phẩm.
SELECT
    [product_name]
	,SUM([list_price]) AS [Tổng giá]
    ,COUNT([product_name]) AS [Tổng số lượng]
FROM [BikeStores].[production].[products]
WHERE [product_name] LIKE '%Ladies%'
GROUP BY [product_name]
ORDER BY [Tổng giá], [Tổng số lượng]

-- BT5: Viết truy vấn xuất thông tin các đơn hàng (order_id) 
--		có tổng giá trị ròng (net_value) lớn hơn 20.000 trên bảng sales.order_items, 
--		biết giá trị ròng được tính theo công thức quantity * list_price * (1 - discount)
SELECT 
	[order_id]
    ,SUM([quantity] * [list_price] * (1 - [discount])) AS [Tổng giá trị ròng]
FROM [BikeStores].[sales].[order_items]
GROUP BY [order_id]
HAVING SUM([quantity] * [list_price] * (1 - [discount])) > 20000
ORDER BY [Tổng giá trị ròng]