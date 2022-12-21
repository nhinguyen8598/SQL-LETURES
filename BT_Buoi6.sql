USE [hocsql]
GO

-- BT1:
-- INNER JOIN
SELECT 
	o.[order_id] AS [order_id_return]
	,​o.[order_date]
	,SUM(o.[order_quantity]) AS [total_order_quantity]
	,​SUM(o.[value]) AS [total_value]
	,SUM(o.[profit]) AS [total_profit]
	,r.[returned_date]
FROM [dbo].[Orders] AS o 
INNER JOIN [dbo].[Returns] AS r​
	ON o.[order_id] = r.[order_id]
GROUP BY 
	o.[order_id]
	,o.[order_date]
	,r.[returned_date]
ORDER BY o.[order_date] DESC

-- LEFT JOIN
SELECT 
	o.[order_id] AS [order_id_return]
	,​o.[order_date]
	,SUM(o.[order_quantity]) AS [total_order_quantity]
	,​SUM(o.[value]) AS [total_value]
	,SUM(o.[profit]) AS [total_profit]
	,r.[returned_date]
FROM [dbo].[Returns] AS r
LEFT JOIN ​[dbo].[Orders] AS o 
	ON o.[order_id] = r.[order_id]
GROUP BY 
	o.[order_id]
	,o.[order_date]
	,r.[returned_date]
ORDER BY o.[order_date] DESC

-- RIGHT JOIN
SELECT 
	o.[order_id] AS [order_id_return]
	,​o.[order_date]
	,SUM(o.[order_quantity]) AS [total_order_quantity]
	,​SUM(o.[value]) AS [total_value]
	,SUM(o.[profit]) AS [total_profit]
	,r.[returned_date]
FROM [dbo].[Orders] AS o 
RIGHT JOIN [dbo].[Returns] AS r​
	ON o.[order_id] = r.[order_id]
GROUP BY 
	o.[order_id]
	,o.[order_date]
	,r.[returned_date]
ORDER BY o.[order_date] DESC

-- BT2
SELECT 
	p.[manager]
	,​SUM([order_quantity]) AS [total_order_quantity]
	,SUM([value]) AS [total_value]
	,​SUM([profit]) AS [total_profit​]
FROM [dbo].[Orders] AS o 
LEFT JOIN [dbo].[Profiles] AS p​
	ON o.[province] = p.[province]​
GROUP BY p.[manager]

--BT3
SELECT 
	[order_priority]
	,SUM([profit]) AS [total_profit]
FROM [dbo].[Orders]​
WHERE [order_priority] = 'Not Specified' 
GROUP BY [order_priority]​

UNION ALL

SELECT 
	[order_priority]
	,SUM([profit]) AS [total_profit]
FROM [dbo].[Orders]​
WHERE [order_priority] = 'Low' 
GROUP BY [order_priority]​

UNION ALL

SELECT 
	[order_priority]
	,SUM([profit]) AS [total_profit]
FROM [dbo].[Orders]​
WHERE [order_priority] = 'Medium' 
GROUP BY [order_priority]​

UNION ALL

SELECT 
	[order_priority]
	,SUM([profit]) AS [total_profit]
FROM [dbo].[Orders]​
WHERE [order_priority] = 'High' 
GROUP BY [order_priority]​

UNION ALL

SELECT 
	[order_priority]
	,SUM([profit]) AS [total_profit]
FROM [dbo].[Orders]​
WHERE [order_priority] = 'Critical' 
GROUP BY [order_priority]​

--BT4
SELECT 
	[order_priority]
	,SUM([profit]) AS [total_profit]
FROM [dbo].[Orders]​
GROUP BY [order_priority]​

UNION ALL

SELECT 
	'Total' AS [order_priority]
	,SUM([profit]) AS total_profit​
FROM [dbo].[Orders]​

-- BT5
SELECT 
	[order_id]
	,[customer_name]
	,​[product_category]
	,​[product_subcategory]
	,[product_name]
	,​CONCAT(RIGHT([product_name], 3), ' ', 'mm') AS [THICKNESS] 
FROM [dbo].[Orders]​
WHERE [product_subcategory] = 'Pens & Art Supplies'​
	AND [product_name] LIKE '%Newell%'​

-- BT6
SELECT 
	[manager_name]
	,[manager_level]
	,[manager_phone]
	,CASE
		WHEN [manager_level] = 1 THEN 'Fresher'​
		WHEN [manager_level] IN (2,3) THEN 'Junior' 
		WHEN [manager_level] = 4 THEN 'Senior'​
		END AS [level​]
FROM [dbo].[Managers] m​

--BT7
--Phương pháp CTE
WITH orders
AS 
(
	SELECT 
		YEAR([order_date]) AS [year]
		,MONTH([order_date]) AS [month]
		,[product_category]
		,SUM([value]) AS [total_orders]
	FROM [dbo].[Orders]
	GROUP BY
		YEAR([order_date])
		,MONTH([order_date])
		,[product_category]
)
,returns
AS 
(
	SELECT 
		YEAR([returned_date]) AS [year]
		,MONTH([returned_date]) AS [month]
		,O.[product_category]
		,SUM([value]) AS [total_returns]
	FROM [dbo].[Returns] R
	JOIN [dbo].[Orders] O
		ON R.[order_id] = O.[order_id]
	GROUP BY
		YEAR([returned_date])
		,MONTH([returned_date])
		,O.[product_category]
)
SELECT 
	ISNULL(a.[year], b.[year]) AS [year]
	,ISNULL(a.[month], b.[month]) AS [month]
	,ISNULL(a.[product_category], b.[product_category]) AS [product_category]
	,ISNULL(a.[total_orders], 0) AS [total_orders]
	,ISNULL(b.[total_returns], 0) AS [total_returns]
FROM orders AS a
RIGHT JOIN returns AS b
ON a.[year] = b.[year]
	AND a.[month] = b.[month]
	AND a.[product_category] = b.[product_category]
ORDER BY [year], [month]


--Phương pháp Subquery
SELECT
	ISNULL(a.[year], b.[year]) AS [year]
	,ISNULL(a.[month], b.[month]) AS [month]
	,ISNULL(a.[product_category], b.[product_category]) AS [product_category]
	,ISNULL(a.[total_orders], 0) AS [total_orders]
	,ISNULL(b.[total_returns], 0) AS [total_returns]
FROM
(
	SELECT
		YEAR([order_date]) AS [year]
		,MONTH([order_date]) AS [month]
		,[product_category]
		,SUM([value]) AS [total_orders]
	FROM [dbo].[Orders]
	GROUP BY 
		YEAR([order_date])
		,MONTH([order_date])
		,[product_category]
) a
RIGHT JOIN (
	SELECT 
		YEAR([returned_date]) AS [year]
		,MONTH([returned_date]) AS [month]
		,O.[product_category]
		,SUM([value]) AS [total_returns]
	FROM [dbo].[Returns] R
	JOIN [dbo].[Orders] O
		ON R.[order_id] = O.[order_id]
	GROUP BY
		YEAR([returned_date])
		,MONTH([returned_date])
		,O.[product_category]
) b
ON a.[year] = b.[year] 
	AND a.[month] = b.[month]
	AND a.[product_category] = b.[product_category]
ORDER BY [year], [month]

--BT8
--Phương pháp CTE 
;WITH a 
AS
(
	SELECT
		o.[order_id]
		,o.[order_quantity]
		,o.[value]
		,o.[profit]
		,m.[manager_name]
		,m.[manager_id]
		,m.[manager_level]
	FROM [dbo].[Orders] AS o
	LEFT JOIN [dbo].[Returns] AS r
		ON o.[order_id] = r.[order_id]
	LEFT JOIN [dbo].[Profiles] AS p
		ON o.[province] = p.[province]
	LEFT JOIN [dbo].[Managers] AS m
		ON p.[manager] = m.[manager_name]
	WHERE YEAR(o.[order_date]) = 2012
		AND r.[status] IS NULL
)
SELECT 
	a.[manager_name]
	,a.[manager_level]
	,a.[manager_id]
	,COUNT(a.[order_id]) AS [number_items]
	,SUM(a.[order_quantity]) AS [total_quantity]
	,SUM([value]) AS [total_value]
	,SUM([profit]) AS [total_profit]
FROM a
GROUP BY 
	a.[manager_name]
	,a.[manager_id]
	,a.[manager_level]

--Phương pháp Subquery 
SELECT 
	a.[manager_name]
	,a.[manager_level]
	,a.[manager_id]
	,COUNT(a.[order_id]) AS [number_items]
	,SUM(a.[order_quantity]) AS [total_quantity]
	,SUM([value]) AS [total_value]
	,SUM([profit]) AS [total_profit]
FROM
(
	SELECT
		o.[order_id]
		,o.[order_quantity]
		,o.[value]
		,o.[profit]
		,m.[manager_name]
		,m.[manager_id]
		,m.[manager_level]
	FROM [dbo].[Orders] AS o
	LEFT JOIN [dbo].[Returns] AS r
		ON o.[order_id] = r.[order_id]
	LEFT JOIN [dbo].[Profiles] AS p
		ON o.[province] = p.[province]
	LEFT JOIN [dbo].[Managers] AS m
		ON p.[manager] = m.[manager_name]
	WHERE YEAR(o.[order_date]) = 2012
		AND [status] IS NULL
) a
GROUP BY 
	a.[manager_name]
	,a.[manager_id]
	,a.[manager_level]