USE [master]
GO
/****** Object:  Database [ProductsCatalog]    Script Date: 8/10/2015 11:17:05 AM ******/
CREATE DATABASE [ProductsCatalog]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ProductsCatalog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\ProductsCatalog.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ProductsCatalog_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\ProductsCatalog_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ProductsCatalog] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ProductsCatalog].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ProductsCatalog] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ProductsCatalog] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ProductsCatalog] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ProductsCatalog] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ProductsCatalog] SET ARITHABORT OFF 
GO
ALTER DATABASE [ProductsCatalog] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ProductsCatalog] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ProductsCatalog] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ProductsCatalog] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ProductsCatalog] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ProductsCatalog] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ProductsCatalog] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ProductsCatalog] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ProductsCatalog] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ProductsCatalog] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ProductsCatalog] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ProductsCatalog] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ProductsCatalog] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ProductsCatalog] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ProductsCatalog] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ProductsCatalog] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ProductsCatalog] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ProductsCatalog] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ProductsCatalog] SET  MULTI_USER 
GO
ALTER DATABASE [ProductsCatalog] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ProductsCatalog] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ProductsCatalog] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ProductsCatalog] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [ProductsCatalog] SET DELAYED_DURABILITY = DISABLED 
GO
USE [ProductsCatalog]
GO
/****** Object:  Table [dbo].[tblCategories]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CatName] [nvarchar](100) NULL,
	[ParentCategoryId] [int] NOT NULL,
 CONSTRAINT [PK_tblCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblProducts]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProducts](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](100) NULL,
	[Description] [ntext] NULL,
	[Price] [decimal](7, 2) NULL CONSTRAINT [DF_tblProducts_Price]  DEFAULT ((0)),
	[CategoryIds] [nvarchar](2000) NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_tblProducts_DateCreated]  DEFAULT (getdate()),
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_tblProducts] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblCategories] ADD  CONSTRAINT [DF_tblCategory_ParentCategoryId]  DEFAULT ((0)) FOR [ParentCategoryId]
GO
/****** Object:  StoredProcedure [dbo].[deleteCategory]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[deleteCategory]
	@catid int	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cat_id int;

	DECLARE cat_cursor CURSOR LOCAL FOR 
	SELECT CategoryId FROM tblCategories WHERE ParentCategoryId = @catid;
	OPEN cat_cursor

	FETCH NEXT FROM cat_cursor 
	INTO @cat_id
	
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		EXECUTE deleteCategory @cat_id;		
		FETCH NEXT FROM cat_cursor 
		INTO @cat_id
	END 
	CLOSE cat_cursor;
	DEALLOCATE cat_cursor;
	DELETE FROM tblCategories WHERE CategoryId = @catid;
END

GO
/****** Object:  StoredProcedure [dbo].[getCategoryProducts]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getCategoryProducts]
	@catid int	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @cnt int = 1;
	DECLARE @cat_id int, @cat_name nvarchar(200);

	DECLARE cat_cursor CURSOR LOCAL FOR 
	SELECT CategoryId FROM tblCategories WHERE ParentCategoryId = @catid;
	OPEN cat_cursor

	FETCH NEXT FROM cat_cursor 
	INTO @cat_id
	
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		EXECUTE getCategoryProducts @cat_id;		
		FETCH NEXT FROM cat_cursor 
		INTO @cat_id
	END 
	CLOSE cat_cursor;
	DEALLOCATE cat_cursor;
	SELECT * FROM tblProducts WHERE CategoryIds LIKE ('%' + CAST(@catid AS VARCHAR) + ';%');
END

GO
/****** Object:  StoredProcedure [dbo].[getNestedCategories]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kanchana Pradhan>
-- Create date: <2015-08-09>
-- Description:	<Create a nested tree of categories>
-- =============================================
CREATE PROCEDURE [dbo].[getNestedCategories]
	@ParentId int,
	@NestedLevel int,
	@excludeCatid int = null
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @cnt int = 1;
	DECLARE @cat_id int, @cat_name nvarchar(200);

	DECLARE cat_cursor CURSOR LOCAL FOR 
	SELECT CategoryId, CatName FROM tblCategories WHERE ParentCategoryId = @ParentId AND (@excludeCatid IS NULL OR (CategoryId <> @excludeCatid))
	ORDER BY CatName;
	OPEN cat_cursor

	FETCH NEXT FROM cat_cursor 
	INTO @cat_id, @cat_name

	SET @NestedLevel = @NestedLevel + 1;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		WHILE @cnt < @NestedLevel
		BEGIN
			SET @cat_name = '......' + @cat_name;
			SET @cnt = @cnt + 1;
		END;

		SET @cnt = 1;

		INSERT INTO #LocalTempTable VALUES (@cat_id, @cat_name);
		
		EXECUTE getNestedCategories @cat_id, @NestedLevel, @excludeCatid;

		FETCH NEXT FROM cat_cursor 
		INTO @cat_id, @cat_name
	END 
	CLOSE cat_cursor;
	DEALLOCATE cat_cursor;
	
END

GO
/****** Object:  StoredProcedure [dbo].[getNestedProducts]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getNestedProducts]
	@catid int	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @cat_id int;

	DECLARE cat_cursor CURSOR LOCAL FOR 
	SELECT CategoryId FROM tblCategories WHERE ParentCategoryId = @catid;
	OPEN cat_cursor

	FETCH NEXT FROM cat_cursor 
	INTO @cat_id
	
	WHILE @@FETCH_STATUS = 0
	BEGIN		
		EXECUTE getNestedProducts @cat_id;		
		FETCH NEXT FROM cat_cursor 
		INTO @cat_id
	END 
	CLOSE cat_cursor;
	DEALLOCATE cat_cursor;

	INSERT INTO #LocalTempTable 
	SELECT ProductId,ProductName,Price FROM tblProducts WHERE CategoryIds LIKE ('%' + CAST(@catid AS VARCHAR) + ';%')
	AND NOT EXISTS (SELECT * FROM #LocalTempTable  WHERE ProductId = tblProducts.ProductId);

END

GO
/****** Object:  StoredProcedure [dbo].[getOrderedCategoryList]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getOrderedCategoryList]	
	@catid int = null
AS
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #LocalTempTable(
		CategoryId int,
		CatName nvarchar(200))	

	EXECUTE getNestedCategories 0,0,@catid;

	SELECT * FROM #LocalTempTable;
END

GO
/****** Object:  StoredProcedure [dbo].[getProductsbyCategory]    Script Date: 8/10/2015 11:17:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getProductsbyCategory]
	@catid int	
AS
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #LocalTempTable(
		ProductId int,
		ProductName nvarchar(100),
		Price decimal)	

	EXECUTE getNestedProducts @catid;

	SELECT * FROM #LocalTempTable;
END

GO
USE [master]
GO
ALTER DATABASE [ProductsCatalog] SET  READ_WRITE 
GO

--------------------------------------------------------------------------------------------------------
USE [ProductsCatalog]

INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Electronics',0);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Computers',1);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Tablets',2);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Laptops',2);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Ipads',3);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Android',3);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Desktop Computers',2);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Monitors',1);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Printers & Ink',0);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Printers',9);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Inkjet Printers',10);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Laser Printers',10);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Printer Ink',9);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Cell Phones',0);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Android Phones',14);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Apple Phones',14);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Unlocked Phones',14);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Locked Phones',14);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Gaming Computers',7);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Musical Instruments',0);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Guitars',20);
INSERT INTO tblCategories (CatName, ParentCategoryId) VALUES ('Keyboards',20);

INSERT INTO tblProducts (ProductName, Price) VALUES ('ASUS X Series 15.6" Laptop',399.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Apple iPad mini 3 16GB With Wi-Fi - Space',379.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Apple iPad mini 2 - 16GB - Wi-Fi - Silver',329.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Brother Wireless All-In-One Laser Printer',129.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Epson Inkjet Printer Ink',33.95);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Fender Limited Edition American Standard Telecaster Electric Guitar - Olympic White',1999.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Casio 61-Key Electric Keyboard',129.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Acer 23.6" Widescreen LED Monitor',149.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('HP 15.6" Laptop - Silver',599.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Dell XPS PC (Intel Core i7-4790 / 2TB SATA HDD / 16GB RAM / Windows 8.1)',1199.99);
INSERT INTO tblProducts (ProductName, Price) VALUES ('Lenovo H50 PC',549.99);

