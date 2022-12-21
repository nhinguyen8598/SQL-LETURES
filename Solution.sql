-- Câu 1
SELECT
	cy.[CountryName]
FROM
	[dbo].[tblCountry] cy
LEFT JOIN [dbo].[tblEvent] e
	ON cy.[CountryID] = e.[CountryID]
WHERE
	e.[EventID] IS NULL

-- Câu 2
SELECT
	UPPER(LEFT(c.[CategoryName], 1)) AS [Category initial]
	,COUNT(*) AS [Number of events]
	,FORMAT(AVG(CAST(LEN(e.[EventName]) AS float)),'0.00') AS [Average event name length]
FROM
	[dbo].[tblCategory] c
INNER JOIN [dbo].[tblEvent] e
	ON c.[CategoryID] = e.[CategoryID]
GROUP BY
	UPPER(LEFT(c.[CategoryName], 1))
ORDER BY
	[Category initial]

-- Câu 3:
SELECT
	e.[EventName]
	,e.[EventDetails]
FROM [dbo].[tblEvent] e
WHERE
	e.CountryID NOT IN (
		SELECT TOP 30 
			c.[CountryID]
		FROM [dbo].[tblCountry] c
		ORDER BY c.[CountryName] DESC
	) 
	AND e.[CategoryID] NOT IN (
		SELECT TOP 15 
			c.[CategoryID]
		FROM [dbo].[tblCategory] c
		ORDER BY c.[CategoryName] DESC
	)
ORDER BY
	e.[EventDate]