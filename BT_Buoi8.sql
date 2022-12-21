USE [hocsql]
GO

--BT1

--- Subquery
SELECT
	[product_category]
	,[product_name]
	,[total_profit]
	,[row_num]
FROM
(
	SELECT
		[product_category]
		,[product_name]
		,SUM([profit]) AS [total_profit]
		,ROW_NUMBER() OVER (PARTITION BY [product_category] ORDER BY SUM([profit])) AS [row_num]
	FROM [dbo].[Orders]
	GROUP BY [product_category]
		,[product_name]
) a
WHERE [row_num] <= 3
ORDER BY [product_category],[total_profit]

--- CTE
WITH a 
AS
(
	SELECT
		[product_category]
		,[product_name]
		,SUM([profit]) AS [total_profit]
		,ROW_NUMBER() OVER (PARTITION BY [product_category] ORDER BY SUM([profit])) AS [row_num]
	FROM [dbo].[Orders]
	GROUP BY [product_category]
		,[product_name]
)
SELECT
	[product_category]
	,[product_name]
	,[total_profit]
	,[row_num]
FROM a 
WHERE [row_num] <= 3
ORDER BY [product_category],[total_profit]

--BT2
SELECT
	[province]
	,[product_name]
	,[total_profit]
	,[denseRank]
FROM
(
SELECT
	[province]
	,[product_name]
	,SUM([profit]) AS [total_profit]
	,DENSE_RANK() OVER (PARTITION BY [province] ORDER BY SUM([profit]) DESC) AS [denseRank]
FROM [dbo].[Orders]
GROUP BY [province]
	,[product_name]
) a
WHERE [denseRank] = 3
ORDER BY [province],[total_profit] DESC

--BT3
SELECT
	[province]
	,[product_name]
	,[total_profit]
	,[Rank]
FROM
(
SELECT
	[province]
	,[product_name]
	,SUM([profit]) AS [total_profit]
	,RANK() OVER (PARTITION BY [province] ORDER BY SUM([profit])) AS [Rank]
FROM [dbo].[Orders]
GROUP BY [province]
	,[product_name]
) a
WHERE [Rank] = 3
ORDER BY [province],[total_profit]
GO


-- BT4
USE [BikeStores]
GO

-- ALTER TABLE production.categories
-- ALTER COLUMN category_id INT NOT NULL

ALTER TABLE production.categories
ADD PRIMARY KEY (category_id);

ALTER TABLE production.brands
ADD PRIMARY KEY (brand_id);

ALTER TABLE production.products
ADD PRIMARY KEY (product_id),
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE sales.customers
ADD PRIMARY KEY (customer_id)

ALTER TABLE sales.stores
ADD PRIMARY KEY (store_id)

ALTER TABLE sales.staffs
ADD PRIMARY KEY (staff_id),
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION

ALTER TABLE sales.orders
ADD PRIMARY KEY (order_id),
	FOREIGN KEY (customer_id) REFERENCES sales.customers (customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES sales.staffs (staff_id) ON DELETE NO ACTION ON UPDATE NO ACTION

ALTER TABLE sales.orders
ADD PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE production.stocks
ADD PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE