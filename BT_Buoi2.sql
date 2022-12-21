USE BikeStores
GO

-- BT1: Truy vấn lấy thông tin order_date trong bảng sales.orders (kết quả trả về là duy nhất), sắp xếp theo thứ tự tăng dần.
SELECT DISTINCT
	[order_date]
FROM [sales].[orders]
ORDER BY [order_date]
GO

-- BT2: Truy vấn lấy thông tin brand_id và category_id trong bảng production.products (kết quả trả về là duy nhất).
SELECT DISTINCT
	[brand_id]
	,[category_id]
FROM [production].[products]
ORDER BY [brand_id]
	,[category_id]
GO

-- BT3: Viết truy vấn lấy toàn bộ thông tin nhân viên (bảng sales.staffs) với store_id bằng 1 và manager_id bằng 2, sắp xếp theo thứ tự tăng dần theo first_name.
SELECT
	[staff_id]
	,[first_name]
	,[last_name]
	,[email]
	,[phone]
	,[active]
	,[store_id]
	,[manager_id]
FROM [sales].[staffs]
WHERE [store_id] = 1
	AND [manager_id] = 2
ORDER BY [first_name]

-- BT4: Viết truy vấn lấy toàn bộ thông tin sản phẩm (bảng production.products) với brand_id bằng 1 hoặc 9, và có giá (list_price) trong khoảng từ 199.99 đến 499.99.
SELECT
	[product_id]
	,[product_name]
	,[brand_id]
	,[category_id]
	,[model_year]
	,[list_price]
FROM [production].[products]
WHERE ([brand_id] = 1 OR [brand_id] = 9)
	AND ([list_price] >= 199.99 AND [list_price] <= 499.99)

-- BT5: Viết truy vấn liệt kê tên 5 sản phẩm (bảng production.products) có giá (list_price) cao nhất với điều kiện là sản phẩm có model_year bằng 2018.
SELECT TOP 5
	[product_name]
FROM [production].[products]
WHERE [model_year] = 2018
ORDER BY [list_price] DESC