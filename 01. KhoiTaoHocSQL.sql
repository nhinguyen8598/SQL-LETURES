--Sử dụng database [master]
USE [master]
GO

--Xóa hết các hoạt động đang xảy ra trên database [hocsql]
ALTER DATABASE [hocsql] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

--Xóa database [hocsql]
DROP DATABASE [hocsql]
GO

--Khởi tạo database [hocsql]
CREATE DATABASE [hocsql]
GO

--Sử dụng database [hocsql]
USE [hocsql]
GO

--Kiểm tra sự tồn tại, nếu có thì xóa các bảng và schema
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Managers]') AND type in (N'U'))
DROP TABLE [dbo].[Managers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
DROP TABLE [dbo].[Orders]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profiles]') AND type in (N'U'))
DROP TABLE [dbo].[Profiles]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Returns]') AND type in (N'U'))
DROP TABLE [dbo].[Returns]
GO

-- Khởi tạo các bảng
CREATE TABLE [dbo].[Managers](
	[manager_id] [float] NULL,
	[manager_name] [nvarchar](255) NULL,
	[manager_level] [float] NULL,
	[manager_phone] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Orders](
	[ID] [float] NULL,
	[order_id] [float] NULL,
	[order_date] [datetime] NULL,
	[order_priority] [nvarchar](255) NULL,
	[order_quantity] [float] NULL,
	[value] [float] NULL,
	[discount] [float] NULL,
	[shipping_mode] [nvarchar](255) NULL,
	[profit] [float] NULL,
	[unit_price] [float] NULL,
	[shipping_cost] [float] NULL,
	[customer_name] [nvarchar](255) NULL,
	[province] [nvarchar](255) NULL,
	[region] [nvarchar](255) NULL,
	[customer_segment] [nvarchar](255) NULL,
	[product_category] [nvarchar](255) NULL,
	[product_subcategory] [nvarchar](255) NULL,
	[product_name] [nvarchar](255) NULL,
	[product_container] [nvarchar](255) NULL,
	[product_base_margin] [float] NULL,
	[shipping_date] [datetime] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Profiles](
	[province] [nvarchar](255) NULL,
	[region] [nvarchar](255) NULL,
	[manager] [nvarchar](255) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Returns](
	[order_id] [float] NULL,
	[status] [nvarchar](255) NULL,
	[returned_date] [datetime] NULL
) ON [PRIMARY]
GO