USE [BikeStores]
GO

-- BT1: Viết truy vấn để lấy thông tin sản phẩm (product_name), mã đơn hàng (order_id) có sản phẩm đó (nếu có), 
--		số lượng sản phẩm (quantity) và ngày đơn hàng đó được giao dịch (order_date)
-- Cách 1
SELECT 
	p.[product_name]
	,i.[order_id]
	,i.[quantity]
	,o.[order_date]
FROM [production].[products] p
LEFT JOIN [sales].[order_items] i 
	ON p.[product_id] = i.[product_id]
LEFT JOIN [sales].[orders] o 
	ON i.[order_id] = o.[order_id]

-- Cách 2
SELECT 
	p.[product_name]
	,i.[order_id]
	,i.[quantity]
	,o.[order_date]
FROM [sales].[orders] o
INNER JOIN [sales].[order_items] i 
	ON o.[order_id] = i.[order_id]
RIGHT JOIN [production].[products] p
	ON p.[product_id] = i.[product_id]

-- Cách 3
SELECT 
	p.[product_name]
	,i.[order_id]
	,i.[quantity]
	,o.[order_date]
FROM [sales].[order_items] i
RIGHT JOIN [production].[products] p
	ON p.[product_id] = i.[product_id]
LEFT JOIN [sales].[orders] o 
	ON i.[order_id] = o.[order_id]

-- BT2: Viết truy vấn để lấy thông tin nhãn hàng (brand_name) và giá trung bình (average_list_price) 
--		cho tất cả các sản phẩm có model_year là 2018.
SELECT 
	b.[brand_name]
    ,AVG(p.[list_price]) as [average_list_price]
FROM [production].[products] p
INNER JOIN [production].[brands] b 
	ON p.[brand_id] = b.[brand_id]
WHERE p.[model_year] = 2018
GROUP BY b.[brand_name]

-- BT3: Viết truy vấn lấy thông tin mã đơn hàng (order_id), tên khách hàng (customer_name), tên cửa hàng (store_name), 
--		tổng lượng sản phẩm (total_quantity) và tổng giá trị đơn hàng (total_net_value) biết giá trị đơn hàng (net_value) 
--		được tính theo công thức quantity * list_price * (1 - discount)
SELECT
	O.[order_id]
	,C.[first_name] + ' ' + C.[last_name] AS [customer_name]
	,S.[store_name]
	,SUM(OI.[quantity]) AS [total_quantity]
	,SUM(OI.[quantity] * OI.[list_price] * (1 - OI.[discount])) AS [total_net_value]
FROM [sales].[orders] O
JOIN [sales].[customers] C
	ON O.[customer_id] = C.[customer_id]
JOIN [sales].[stores] S
	ON O.[store_id] = S.[store_id]
JOIN [sales].[order_items] OI
	ON O.[order_id] = OI.[order_id]
GROUP BY 
	O.[order_id]
	,C.[first_name] + ' ' + C.[last_name]
	,S.[store_name]


-- BT5: Viết truy vấn lấy thông tin những sản phẩm chưa được bày bán ở cửa hàng nào hoặc hết hàng (quantity = 0), 
--		kết quả cần trả về tên cửa hàng và tên sản phẩm.
SELECT
	st.[store_name]
	,p.[product_name]
FROM [production].[stocks] stk
RIGHT JOIN [production].[products] p
	ON p.[product_id] = stk.[product_id]
LEFT JOIN [sales].[stores] st
	ON stk.[store_id] = st.store_id
WHERE stk.quantity = 0 OR stk.store_id IS NULL

SELECT 
	st.[store_name]
	,p.[product_name]
FROM [production].[stocks] stk
LEFT JOIN [sales].[stores] st
	ON stk.[store_id] = st.store_id
RIGHT JOIN [production].[products] p
	ON p.[product_id] = stk.[product_id]
WHERE stk.quantity = 0 OR stk.store_id IS NULL

SELECT 
	st.[store_name]
	,p.[product_name]
FROM [production].[products] p
LEFT JOIN [production].[stocks] stk
	ON p.[product_id] = stk.[product_id]
LEFT JOIN [sales].[stores] st
	ON stk.[store_id] = st.store_id
WHERE stk.quantity = 0 OR stk.store_id IS NULL

SELECT 
	st.[store_name]
	,p.[product_name]
FROM[sales].[stores] st
JOIN [production].[stocks] stk
	ON stk.[store_id] = st.store_id 
RIGHT JOIN [production].[products] p
	ON p.[product_id] = stk.[product_id]
WHERE stk.quantity = 0 OR stk.store_id IS NULL