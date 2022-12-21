USE [BikeStores]
GO

-- BT1: Viết truy vấn thông kê số lượng mỗi domain (vd: @gmail.com) từ email của bảng customers.
-- Cách 1
SELECT 
	SUBSTRING([email], CHARINDEX('@', [email]), LEN([email])) AS [domain]
	,COUNT(*) AS [count]
FROM [sales].[customers]
GROUP BY SUBSTRING([email], CHARINDEX('@', [email]), LEN([email]))

-- Cách 2
SELECT 
	RIGHT([email], LEN([email]) - CHARINDEX('@', [email]) + 1) AS [domain]
	,COUNT(*) AS [count]
FROM [sales].[customers]
GROUP BY RIGHT([email], LEN([email]) - CHARINDEX('@', [email])+ 1)


--BT2: Viết truy vấn để thống kê kết quả kinh doanh theo tháng và theo năm theo mẫu dưới đây:
--Year (dựa theo order_date), Month (dựa theo order_date), Output (tổng quantity), Revenue (tổng net value với net value được tính bằng công thức quantity * list_price * (1 - discount))
SELECT
	YEAR(o.[order_date]) AS [Year]
	,MONTH(o.[order_date]) AS [Month]
	,SUM(oi.[quantity]) AS [Output]
	,SUM(oi.[quantity] * oi.[list_price] * (1 - oi.[discount])) AS [Revenue]
FROM [sales].[order_items] oi
LEFT JOIN [sales].[orders] o
	ON oi.[order_id] = o.[order_id]
GROUP BY 
	YEAR(o.[order_date])
	,MONTH(o.[order_date])
ORDER BY [Year], [Month]

-- BT3: Viết truy vấn để thống kê những sản phẩm giao trễ hạn (shipped_date > required_date) theo mẫu dưới đây:
--product_name, order_id, customer_name (first_name và last_name), email, address (street, city, state), number of days overdue (shipped_date - required_date), store_name, staff_name (first_name và last_name)
SELECT
	p.[product_name]
	,o.[order_id]
	,CONCAT_WS(' ', c.[first_name], c.last_name) AS [customer_name]
	,c.[email]
	,CONCAT_WS(', ', c.[street], c.[city], c.[state]) AS [address]
	,DATEDIFF(DAY, o.[shipped_date], o.[required_date]) AS [number_of_days_overdue]
	,st.[store_name]
	,CONCAT_WS(' ', stf.[first_name], stf.last_name) AS [staff_name]
FROM [sales].[orders] o
LEFT JOIN [sales].[order_items] oi
	ON o.[order_id] = oi.[order_id]
LEFT JOIN [production].[products] p
	ON oi.[product_id] = p.[product_id]
LEFT JOIN [sales].[customers] c
	ON o.[customer_id] = c.[customer_id]
LEFT JOIN [sales].[staffs] stf
	ON o.[staff_id] = stf.[staff_id]
LEFT JOIN [sales].[stores] st
	ON o.[store_id] = st.[store_id]
WHERE DATEDIFF(DAY, o.[shipped_date], o.[required_date]) < 0

--BT4: Từ cột order_date trong bảng orders, viết truy vấn để trả ra kết quả theo mẫu dưới đây:
	--Date = order_date
	--,Year
	--,Quarter
	--,Month (vd: 1, 2, ...)
	--,MonthName (vd: January, February,...)
	--,MonthShortName
	--,WeekDay (vd: 1, 2,...)
	--,WeekDayName (vd: Monday, ...)
	--,WeekDayShortName (vd: Mon, Tue,...)
	--,WeekOfYear
	--,DayOfYear
	--,Day
	--,FirstDateofMonth (vd: 2022-01-01, ...)
	--,LastDateofMonth (vd: 2022-01-31, ...)
	--,FirstDateofWeek (vd: 2022-01-01, ...)
	--,LastDateofWeek (vd: 2022-01-07, ...)
SELECT 
	[Date] = [order_date]
	,[Year] = YEAR([order_date])
	,[Quarter] = DATEPART(QUARTER, [order_date])
	,[Month] = MONTH([order_date])
	,[MonthName] = DATENAME(MONTH, [order_date])
	,[MonthShortName] = LEFT(DATENAME(MONTH, [order_date]), 3)
	,[WeekDay] = DATEPART(WEEKDAY, [order_date])
	,[WeekDayName] = DATENAME(WEEKDAY, [order_date])
	,[WeekDayShortName] = LEFT(DATENAME(WEEKDAY, [order_date]), 3)
	,[WeekOfYear] = DATEPART(WEEK, [order_date])
	,[DayOfYear] = DATEPART(DAYOFYEAR, [order_date])
	,[Day] = DAY([order_date])
	,[FirstDateofMonth] = DATEFROMPARTS(YEAR([order_date]), MONTH([order_date]), 1)
	,[LastDateofMonth] = EOMONTH([order_date])
	,[FirstDateofWeek] = DATEADD(DAY, -1 * DATEPART(WEEKDAY, [order_date]) + 1, [order_date])
	,[LastDateofWeek] = DATEADD(DAY, (7 - DATEPART(WEEKDAY, [order_date])), [order_date])
FROM [sales].[orders]