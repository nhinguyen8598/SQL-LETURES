/*
--------------------------------------------------------------------
DEMO BUỔI 2 - Tạo DB, Schema và tạo bảng
--------------------------------------------------------------------
*/
CREATE DATABASE [BikeStores]
GO

USE [BikeStores]
GO

-- Khởi tạo Schemas
CREATE SCHEMA [production]
GO

CREATE SCHEMA [sales]
GO

-- Khởi tạo các bảng
CREATE TABLE [production].[categories] (
	[category_id] INT IDENTITY (1, 1),
	[category_name] VARCHAR (255) NOT NULL
)
GO

CREATE TABLE [production].[brands] (
	[brand_id] INT IDENTITY (1, 1),
	[brand_name] VARCHAR (255) NOT NULL
)
GO

CREATE TABLE [production].[products] (
	[product_id] INT IDENTITY (1, 1),
	[product_name] VARCHAR (255) NOT NULL,
	[brand_id] INT NOT NULL,
	[category_id] INT NOT NULL,
	[model_year] SMALLINT NOT NULL,
	[list_price] DECIMAL (10, 2) NOT NULL
)
GO

CREATE TABLE [production].[stocks] (
	[store_id] INT,
	[product_id] INT,
	[quantity] INT
)
GO

CREATE TABLE [sales].[customers] (
	[customer_id] INT IDENTITY (1, 1),
	[first_name] VARCHAR (255) NOT NULL,
	[last_name] VARCHAR (255) NOT NULL,
	[phone] VARCHAR (25),
	[email] VARCHAR (255) NOT NULL,
	[street] VARCHAR (255),
	[city] VARCHAR (50),
	[state] VARCHAR (25),
	[zip_code] VARCHAR (5)
)
GO

CREATE TABLE [sales].[stores] (
	[store_id] INT IDENTITY (1, 1),
	[store_name] VARCHAR (255) NOT NULL,
	[phone] VARCHAR (25),
	[email] VARCHAR (255),
	[street] VARCHAR (255),
	[city] VARCHAR (255),
	[state] VARCHAR (10),
	[zip_code] VARCHAR (5)
)
GO

CREATE TABLE [sales].[staffs] (
	[staff_id] INT IDENTITY (1, 1),
	[first_name] VARCHAR (50) NOT NULL,
	[last_name] VARCHAR (50) NOT NULL,
	[email] VARCHAR (255) NOT NULL,
	[phone] VARCHAR (25),
	[active] TINYINT NOT NULL,
	[store_id] INT NOT NULL,
	[manager_id] INT
)
GO

CREATE TABLE [sales].[orders] (
	[order_id] INT IDENTITY (1, 1),
	[customer_id] INT,
	[order_status] TINYINT NOT NULL,
	[order_date] DATE NOT NULL,
	[required_date] DATE NOT NULL,
	[shipped_date] DATE,
	[store_id] INT NOT NULL,
	[staff_id] INT NOT NULL
)
GO

CREATE TABLE [sales].[order_items] (
	[order_id] INT,
	[item_id] INT,
	[product_id] INT NOT NULL,
	[quantity] INT NOT NULL,
	[list_price] DECIMAL (10, 2) NOT NULL,
	[discount] DECIMAL (4, 2) NOT NULL DEFAULT 0
)
GO

CREATE TABLE [sales].[feedback]
(
	[feedback_id] int
	,[comment] varchar(100)
)
GO