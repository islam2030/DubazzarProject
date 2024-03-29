USE [master]
GO
/****** Object:  Database [pavillion_v4]    Script Date: 7/4/2019 4:54:34 PM ******/
CREATE DATABASE [pavillion_v4]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'pavillion_v4', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\pavillion_v4.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'pavillion_v4_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\pavillion_v4_log.ldf' , SIZE = 832KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [pavillion_v4] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [pavillion_v4].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [pavillion_v4] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [pavillion_v4] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [pavillion_v4] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [pavillion_v4] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [pavillion_v4] SET ARITHABORT OFF 
GO
ALTER DATABASE [pavillion_v4] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [pavillion_v4] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [pavillion_v4] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [pavillion_v4] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [pavillion_v4] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [pavillion_v4] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [pavillion_v4] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [pavillion_v4] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [pavillion_v4] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [pavillion_v4] SET  ENABLE_BROKER 
GO
ALTER DATABASE [pavillion_v4] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [pavillion_v4] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [pavillion_v4] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [pavillion_v4] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [pavillion_v4] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [pavillion_v4] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [pavillion_v4] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [pavillion_v4] SET RECOVERY FULL 
GO
ALTER DATABASE [pavillion_v4] SET  MULTI_USER 
GO
ALTER DATABASE [pavillion_v4] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [pavillion_v4] SET DB_CHAINING OFF 
GO
ALTER DATABASE [pavillion_v4] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [pavillion_v4] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [pavillion_v4] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'pavillion_v4', N'ON'
GO
USE [pavillion_v4]
GO
/****** Object:  UserDefinedFunction [dbo].[nop_getnotnullnotempty]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[nop_getnotnullnotempty]
(
    @p1 nvarchar(max) = null, 
    @p2 nvarchar(max) = null
)
RETURNS nvarchar(max)
AS
BEGIN
    IF @p1 IS NULL
        return @p2
    IF @p1 =''
        return @p2

    return @p1
END



GO
/****** Object:  UserDefinedFunction [dbo].[nop_getprimarykey_indexname]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[nop_getprimarykey_indexname]
(
    @table_name nvarchar(1000) = null
)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @index_name nvarchar(1000)

    SELECT @index_name = i.name
	FROM sys.tables AS tbl
	INNER JOIN sys.indexes AS i ON (i.index_id > 0 and i.is_hypothetical = 0) AND (i.object_id=tbl.object_id)
	WHERE (i.is_unique=1 and i.is_disabled=0) and (tbl.name=@table_name)

    RETURN @index_name
END



GO
/****** Object:  UserDefinedFunction [dbo].[nop_padright]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[nop_padright]
(
    @source INT, 
    @symbol NVARCHAR(MAX), 
    @length INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN RIGHT(REPLICATE(@symbol, @length)+ RTRIM(CAST(@source AS NVARCHAR(MAX))), @length)
END


GO
/****** Object:  UserDefinedFunction [dbo].[nop_splitstring_to_table]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[nop_splitstring_to_table]
(
    @string NVARCHAR(MAX),
    @delimiter CHAR(1)
)
RETURNS @output TABLE(
    data NVARCHAR(MAX)
)
BEGIN
    DECLARE @start INT, @end INT
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string)

    WHILE @start < LEN(@string) + 1 BEGIN
        IF @end = 0 
            SET @end = LEN(@string) + 1

        INSERT INTO @output (data) 
        VALUES(SUBSTRING(@string, @start, @end - @start))
        SET @start = @end + 1
        SET @end = CHARINDEX(@delimiter, @string, @start)
    END
    RETURN
END



GO
/****** Object:  UserDefinedFunction [dbo].[seven_spikes_ajax_filters_product_sorting]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[seven_spikes_ajax_filters_product_sorting] (@OrderBy  INT, @CategoryIdsCount INT, @ManufacturerId INT, @ParentGroupedProductId INT)  RETURNS VARCHAR(250)  AS BEGIN      DECLARE @sql_orderby VARCHAR(250) = ''  	  	 IF @OrderBy = 5   		SET @sql_orderby = ' p.[Name] ASC'  	ELSE IF @OrderBy = 6   		SET @sql_orderby = ' p.[Name] DESC'  	ELSE IF @OrderBy = 10   		SET @sql_orderby = ' p.[Price] ASC'  	ELSE IF @OrderBy = 11   		SET @sql_orderby = ' p.[Price] DESC'  	ELSE IF @OrderBy = 15   		SET @sql_orderby = ' p.[CreatedOnUtc] DESC'  	ELSE   	BEGIN  		 		IF @CategoryIdsCount > 0 SET @sql_orderby = ' pcm.DisplayOrder ASC'  		  		 		IF @ManufacturerId > 0  		BEGIN  			IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '  			SET @sql_orderby = @sql_orderby + ' pmm.DisplayOrder ASC'  		END  		  		 		IF @ParentGroupedProductId > 0  		BEGIN  			IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '  			SET @sql_orderby = @sql_orderby + ' p.[DisplayOrder] ASC'  		END  		  		 		IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '  		SET @sql_orderby = @sql_orderby + ' p.[Name] ASC'  	END    	RETURN @sql_orderby  END

GO
/****** Object:  Table [dbo].[AclRecord]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AclRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityName] [nvarchar](400) NOT NULL,
	[CustomerRoleId] [int] NOT NULL,
 CONSTRAINT [PK__AclRecor__3214EC0709DE7BCC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ActivityLog]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ActivityLogTypeId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[IpAddress] [nvarchar](200) NULL,
 CONSTRAINT [PK__Activity__3214EC070DAF0CB0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ActivityLogType]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityLogType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemKeyword] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK__Activity__3214EC07117F9D94] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Address]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Company] [nvarchar](max) NULL,
	[CountryId] [int] NULL,
	[StateProvinceId] [int] NULL,
	[City] [nvarchar](max) NULL,
	[Address1] [nvarchar](max) NULL,
	[Address2] [nvarchar](max) NULL,
	[ZipPostalCode] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[FaxNumber] [nvarchar](max) NULL,
	[CustomAttributes] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Address__3214EC0715502E78] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AddressAttribute]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AddressAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__AddressA__3214EC071920BF5C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AddressAttributeValue]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AddressAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AddressAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__AddressA__3214EC071CF15040] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Affiliate]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Affiliate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AddressId] [int] NOT NULL,
	[AdminComment] [nvarchar](max) NULL,
	[FriendlyUrlName] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK__Affiliat__3214EC0720C1E124] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BackInStockSubscription]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackInStockSubscription](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__BackInSt__3214EC0724927208] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BlogComment]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CommentText] [nvarchar](max) NULL,
	[BlogPostId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK__BlogComm__3214EC07286302EC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BlogPost]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogPost](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[BodyOverview] [nvarchar](max) NULL,
	[AllowComments] [bit] NOT NULL,
	[Tags] [nvarchar](max) NULL,
	[StartDateUtc] [datetime] NULL,
	[EndDateUtc] [datetime] NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[LimitedToStores] [bit] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__BlogPost__3214EC072C3393D0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Campaign]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Campaign](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Subject] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[StoreId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[DontSendBeforeDateUtc] [datetime] NULL,
	[CustomerRoleId] [int] NOT NULL,
 CONSTRAINT [PK__Campaign__3214EC07300424B4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CategoryTemplateId] [int] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[ParentCategoryId] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
	[PageSize] [int] NOT NULL,
	[AllowCustomersToSelectPageSize] [bit] NOT NULL,
	[PageSizeOptions] [nvarchar](200) NULL,
	[PriceRanges] [nvarchar](400) NULL,
	[ShowOnHomePage] [bit] NOT NULL,
	[IncludeInTopMenu] [bit] NOT NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
	[MobilePicture] [nvarchar](4000) NULL,
 CONSTRAINT [PK__Category__3214EC0733D4B598] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CategoryTemplate]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Category__3214EC0737A5467C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CheckoutAttribute]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckoutAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[TextPrompt] [nvarchar](max) NULL,
	[IsRequired] [bit] NOT NULL,
	[ShippableProductRequired] [bit] NOT NULL,
	[IsTaxExempt] [bit] NOT NULL,
	[TaxCategoryId] [int] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[ValidationMinLength] [int] NULL,
	[ValidationMaxLength] [int] NULL,
	[ValidationFileAllowedExtensions] [nvarchar](max) NULL,
	[ValidationFileMaximumSize] [int] NULL,
	[DefaultValue] [nvarchar](max) NULL,
	[ConditionAttributeXml] [nvarchar](max) NULL,
 CONSTRAINT [PK__Checkout__3214EC073B75D760] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CheckoutAttributeValue]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckoutAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CheckoutAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ColorSquaresRgb] [nvarchar](100) NULL,
	[PriceAdjustment] [decimal](18, 4) NOT NULL,
	[WeightAdjustment] [decimal](18, 4) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Checkout__3214EC073F466844] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[AllowsBilling] [bit] NOT NULL,
	[AllowsShipping] [bit] NOT NULL,
	[TwoLetterIsoCode] [nvarchar](2) NULL,
	[ThreeLetterIsoCode] [nvarchar](3) NULL,
	[NumericIsoCode] [int] NOT NULL,
	[SubjectToVat] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK__Country__3214EC074316F928] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CrossSellProduct]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CrossSellProduct](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId1] [int] NOT NULL,
	[ProductId2] [int] NOT NULL,
 CONSTRAINT [PK__CrossSel__3214EC0746E78A0C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Currency]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CurrencyCode] [nvarchar](5) NOT NULL,
	[Rate] [decimal](18, 4) NOT NULL,
	[DisplayLocale] [nvarchar](50) NULL,
	[CustomFormatting] [nvarchar](50) NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
	[RoundingTypeId] [int] NOT NULL,
 CONSTRAINT [PK__Currency__3214EC074AB81AF0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerGuid] [uniqueidentifier] NOT NULL,
	[Username] [nvarchar](1000) NULL,
	[Email] [nvarchar](1000) NULL,
	[AdminComment] [nvarchar](max) NULL,
	[IsTaxExempt] [bit] NOT NULL,
	[AffiliateId] [int] NOT NULL,
	[VendorId] [int] NOT NULL,
	[HasShoppingCartItems] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[IsSystemAccount] [bit] NOT NULL,
	[SystemName] [nvarchar](400) NULL,
	[LastIpAddress] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[LastLoginDateUtc] [datetime] NULL,
	[LastActivityDateUtc] [datetime] NOT NULL,
	[BillingAddress_Id] [int] NULL,
	[ShippingAddress_Id] [int] NULL,
	[RequireReLogin] [bit] NOT NULL,
	[EmailToRevalidate] [nvarchar](1000) NULL,
	[FailedLoginAttempts] [int] NOT NULL,
	[CannotLoginUntilDateUtc] [datetime] NULL,
	[RegisteredInStoreId] [int] NOT NULL,
 CONSTRAINT [PK__Customer__3214EC074E88ABD4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer_CustomerRole_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_CustomerRole_Mapping](
	[Customer_Id] [int] NOT NULL,
	[CustomerRole_Id] [int] NOT NULL,
 CONSTRAINT [PK__Customer__ABACF0F752593CB8] PRIMARY KEY CLUSTERED 
(
	[Customer_Id] ASC,
	[CustomerRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerAddresses]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAddresses](
	[Customer_Id] [int] NOT NULL,
	[Address_Id] [int] NOT NULL,
 CONSTRAINT [PK__Customer__3C8958225629CD9C] PRIMARY KEY CLUSTERED 
(
	[Customer_Id] ASC,
	[Address_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerAttribute]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Customer__3214EC0759FA5E80] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerAttributeValue]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Customer__3214EC075DCAEF64] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerPassword]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerPassword](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Password] [nvarchar](max) NULL,
	[PasswordFormatId] [int] NOT NULL,
	[PasswordSalt] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Customer__3214EC0720ACD28B] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerRole]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerRole](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[FreeShipping] [bit] NOT NULL,
	[TaxExempt] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[IsSystemRole] [bit] NOT NULL,
	[SystemName] [nvarchar](255) NULL,
	[PurchasedWithProductId] [int] NOT NULL,
	[EnablePasswordLifetime] [bit] NOT NULL,
	[OverrideTaxDisplayType] [bit] NOT NULL,
	[DefaultTaxDisplayTypeId] [int] NOT NULL,
 CONSTRAINT [PK__Customer__3214EC07619B8048] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeletdPicture]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeletdPicture](
	[id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DeletdPictureAll]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DeletdPictureAll](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PictureBinary] [varbinary](max) NULL,
	[MimeType] [nvarchar](40) NOT NULL,
	[SeoFilename] [nvarchar](300) NULL,
	[AltAttribute] [nvarchar](max) NULL,
	[TitleAttribute] [nvarchar](max) NULL,
	[IsNew] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DeliveryDate]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryDate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Delivery__3214EC07656C112C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Discount]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[DiscountTypeId] [int] NOT NULL,
	[UsePercentage] [bit] NOT NULL,
	[DiscountPercentage] [decimal](18, 4) NOT NULL,
	[DiscountAmount] [decimal](18, 4) NOT NULL,
	[MaximumDiscountAmount] [decimal](18, 4) NULL,
	[StartDateUtc] [datetime] NULL,
	[EndDateUtc] [datetime] NULL,
	[RequiresCouponCode] [bit] NOT NULL,
	[CouponCode] [nvarchar](100) NULL,
	[DiscountLimitationId] [int] NOT NULL,
	[LimitationTimes] [int] NOT NULL,
	[MaximumDiscountedQuantity] [int] NULL,
	[AppliedToSubCategories] [bit] NOT NULL,
	[IsCumulative] [bit] NOT NULL,
 CONSTRAINT [PK__Discount__3214EC07693CA210] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Discount_AppliedToCategories]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount_AppliedToCategories](
	[Discount_Id] [int] NOT NULL,
	[Category_Id] [int] NOT NULL,
 CONSTRAINT [PK__Discount__9AC84AD26D0D32F4] PRIMARY KEY CLUSTERED 
(
	[Discount_Id] ASC,
	[Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Discount_AppliedToManufacturers]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount_AppliedToManufacturers](
	[Discount_Id] [int] NOT NULL,
	[Manufacturer_Id] [int] NOT NULL,
 CONSTRAINT [PK__Discount__74137B2270DDC3D8] PRIMARY KEY CLUSTERED 
(
	[Discount_Id] ASC,
	[Manufacturer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Discount_AppliedToProducts]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount_AppliedToProducts](
	[Discount_Id] [int] NOT NULL,
	[Product_Id] [int] NOT NULL,
 CONSTRAINT [PK__Discount__D5903DBF74AE54BC] PRIMARY KEY CLUSTERED 
(
	[Discount_Id] ASC,
	[Product_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DiscountRequirement]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountRequirement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DiscountId] [int] NOT NULL,
	[DiscountRequirementRuleSystemName] [nvarchar](max) NULL,
	[InteractionTypeId] [int] NULL,
	[ParentId] [int] NULL,
	[IsGroup] [bit] NOT NULL,
 CONSTRAINT [PK__Discount__3214EC07787EE5A0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DiscountUsageHistory]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountUsageHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DiscountId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Discount__3214EC077C4F7684] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Download]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Download](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DownloadGuid] [uniqueidentifier] NOT NULL,
	[UseDownloadUrl] [bit] NOT NULL,
	[DownloadUrl] [nvarchar](max) NULL,
	[DownloadBinary] [varbinary](max) NULL,
	[ContentType] [nvarchar](max) NULL,
	[Filename] [nvarchar](max) NULL,
	[Extension] [nvarchar](max) NULL,
	[IsNew] [bit] NOT NULL,
 CONSTRAINT [PK__Download__3214EC0700200768] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailAccount]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Host] [nvarchar](255) NOT NULL,
	[Port] [int] NOT NULL,
	[Username] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[EnableSsl] [bit] NOT NULL,
	[UseDefaultCredentials] [bit] NOT NULL,
 CONSTRAINT [PK__EmailAcc__3214EC0703F0984C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExternalAuthenticationRecord]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalAuthenticationRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Email] [nvarchar](max) NULL,
	[ExternalIdentifier] [nvarchar](max) NULL,
	[ExternalDisplayIdentifier] [nvarchar](max) NULL,
	[OAuthToken] [nvarchar](max) NULL,
	[OAuthAccessToken] [nvarchar](max) NULL,
	[ProviderSystemName] [nvarchar](max) NULL,
 CONSTRAINT [PK__External__3214EC0707C12930] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forums_Forum]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Forum](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ForumGroupId] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[NumTopics] [int] NOT NULL,
	[NumPosts] [int] NOT NULL,
	[LastTopicId] [int] NOT NULL,
	[LastPostId] [int] NOT NULL,
	[LastPostCustomerId] [int] NOT NULL,
	[LastPostTime] [datetime] NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Forums_F__3214EC070B91BA14] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forums_Group]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Group](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Forums_G__3214EC070F624AF8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forums_Post]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Post](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TopicId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[IPAddress] [nvarchar](100) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
	[VoteCount] [int] NOT NULL,
 CONSTRAINT [PK__Forums_P__3214EC071332DBDC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forums_PostVote]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_PostVote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ForumPostId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[IsUp] [bit] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Forums_P__3214EC0707E124C1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forums_PrivateMessage]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_PrivateMessage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[FromCustomerId] [int] NOT NULL,
	[ToCustomerId] [int] NOT NULL,
	[Subject] [nvarchar](450) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[IsRead] [bit] NOT NULL,
	[IsDeletedByAuthor] [bit] NOT NULL,
	[IsDeletedByRecipient] [bit] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Forums_P__3214EC0717036CC0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forums_Subscription]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Subscription](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionGuid] [uniqueidentifier] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ForumId] [int] NOT NULL,
	[TopicId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Forums_S__3214EC071AD3FDA4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forums_Topic]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Topic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ForumId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[TopicTypeId] [int] NOT NULL,
	[Subject] [nvarchar](450) NOT NULL,
	[NumPosts] [int] NOT NULL,
	[Views] [int] NOT NULL,
	[LastPostId] [int] NOT NULL,
	[LastPostCustomerId] [int] NOT NULL,
	[LastPostTime] [datetime] NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Forums_T__3214EC071EA48E88] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GenericAttribute]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GenericAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[KeyGroup] [nvarchar](400) NOT NULL,
	[Key] [nvarchar](400) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK__GenericA__3214EC0722751F6C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GiftCard]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftCard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PurchasedWithOrderItemId] [int] NULL,
	[GiftCardTypeId] [int] NOT NULL,
	[Amount] [decimal](18, 4) NOT NULL,
	[IsGiftCardActivated] [bit] NOT NULL,
	[GiftCardCouponCode] [nvarchar](max) NULL,
	[RecipientName] [nvarchar](max) NULL,
	[RecipientEmail] [nvarchar](max) NULL,
	[SenderName] [nvarchar](max) NULL,
	[SenderEmail] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
	[IsRecipientNotified] [bit] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__GiftCard__3214EC072645B050] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GiftCardUsageHistory]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftCardUsageHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GiftCardId] [int] NOT NULL,
	[UsedWithOrderId] [int] NOT NULL,
	[UsedValue] [decimal](18, 4) NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__GiftCard__3214EC072A164134] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GoogleProduct]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GoogleProduct](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Taxonomy] [nvarchar](max) NULL,
	[CustomGoods] [bit] NOT NULL,
	[Gender] [nvarchar](max) NULL,
	[AgeGroup] [nvarchar](max) NULL,
	[Color] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Material] [nvarchar](max) NULL,
	[Pattern] [nvarchar](max) NULL,
	[ItemGroupId] [nvarchar](max) NULL,
 CONSTRAINT [PK__GooglePr__3214EC072DE6D218] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Language]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[LanguageCulture] [nvarchar](20) NOT NULL,
	[UniqueSeoCode] [nvarchar](2) NULL,
	[FlagImageFileName] [nvarchar](50) NULL,
	[Rtl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[DefaultCurrencyId] [int] NOT NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Language__3214EC0731B762FC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LocaleStringResource]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocaleStringResource](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[ResourceName] [nvarchar](200) NOT NULL,
	[ResourceValue] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK__LocaleSt__3214EC073587F3E0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LocalizedProperty]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocalizedProperty](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[LocaleKeyGroup] [nvarchar](400) NOT NULL,
	[LocaleKey] [nvarchar](400) NOT NULL,
	[LocaleValue] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK__Localize__3214EC07395884C4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Log]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LogLevelId] [int] NOT NULL,
	[ShortMessage] [nvarchar](max) NOT NULL,
	[FullMessage] [nvarchar](max) NULL,
	[IpAddress] [nvarchar](200) NULL,
	[CustomerId] [int] NULL,
	[PageUrl] [nvarchar](max) NULL,
	[ReferrerUrl] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Log__3214EC073D2915A8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manufacturer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ManufacturerTemplateId] [int] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[PictureId] [int] NOT NULL,
	[PageSize] [int] NOT NULL,
	[AllowCustomersToSelectPageSize] [bit] NOT NULL,
	[PageSizeOptions] [nvarchar](200) NULL,
	[PriceRanges] [nvarchar](400) NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Manufact__3214EC0740F9A68C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ManufacturerTemplate]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManufacturerTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Manufact__3214EC0744CA3770] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MeasureDimension]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeasureDimension](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[SystemKeyword] [nvarchar](100) NOT NULL,
	[Ratio] [decimal](18, 8) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__MeasureD__3214EC07489AC854] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MeasureWeight]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeasureWeight](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[SystemKeyword] [nvarchar](100) NOT NULL,
	[Ratio] [decimal](18, 8) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__MeasureW__3214EC074C6B5938] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MessageTemplate]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MessageTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[BccEmailAddresses] [nvarchar](200) NULL,
	[Subject] [nvarchar](1000) NULL,
	[Body] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[AttachedDownloadId] [int] NOT NULL,
	[EmailAccountId] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[DelayBeforeSend] [int] NULL,
	[DelayPeriodId] [int] NOT NULL,
 CONSTRAINT [PK__MessageT__3214EC07503BEA1C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[News]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Short] [nvarchar](max) NOT NULL,
	[Full] [nvarchar](max) NOT NULL,
	[Published] [bit] NOT NULL,
	[StartDateUtc] [datetime] NULL,
	[EndDateUtc] [datetime] NULL,
	[AllowComments] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__News__3214EC07540C7B00] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsComment]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CommentTitle] [nvarchar](max) NULL,
	[CommentText] [nvarchar](max) NULL,
	[NewsItemId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK__NewsComm__3214EC0757DD0BE4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NewsLetterSubscription]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsLetterSubscription](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NewsLetterSubscriptionGuid] [uniqueidentifier] NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[StoreId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__NewsLett__3214EC075BAD9CC8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Order]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderGuid] [uniqueidentifier] NOT NULL,
	[StoreId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[BillingAddressId] [int] NOT NULL,
	[ShippingAddressId] [int] NULL,
	[PickUpInStore] [bit] NOT NULL,
	[OrderStatusId] [int] NOT NULL,
	[ShippingStatusId] [int] NOT NULL,
	[PaymentStatusId] [int] NOT NULL,
	[PaymentMethodSystemName] [nvarchar](max) NULL,
	[CustomerCurrencyCode] [nvarchar](max) NULL,
	[CurrencyRate] [decimal](18, 8) NOT NULL,
	[CustomerTaxDisplayTypeId] [int] NOT NULL,
	[VatNumber] [nvarchar](max) NULL,
	[OrderSubtotalInclTax] [decimal](18, 4) NOT NULL,
	[OrderSubtotalExclTax] [decimal](18, 4) NOT NULL,
	[OrderSubTotalDiscountInclTax] [decimal](18, 4) NOT NULL,
	[OrderSubTotalDiscountExclTax] [decimal](18, 4) NOT NULL,
	[OrderShippingInclTax] [decimal](18, 4) NOT NULL,
	[OrderShippingExclTax] [decimal](18, 4) NOT NULL,
	[PaymentMethodAdditionalFeeInclTax] [decimal](18, 4) NOT NULL,
	[PaymentMethodAdditionalFeeExclTax] [decimal](18, 4) NOT NULL,
	[TaxRates] [nvarchar](max) NULL,
	[OrderTax] [decimal](18, 4) NOT NULL,
	[OrderDiscount] [decimal](18, 4) NOT NULL,
	[OrderTotal] [decimal](18, 4) NOT NULL,
	[RefundedAmount] [decimal](18, 4) NOT NULL,
	[CheckoutAttributeDescription] [nvarchar](max) NULL,
	[CheckoutAttributesXml] [nvarchar](max) NULL,
	[CustomerLanguageId] [int] NOT NULL,
	[AffiliateId] [int] NOT NULL,
	[CustomerIp] [nvarchar](max) NULL,
	[AllowStoringCreditCardNumber] [bit] NOT NULL,
	[CardType] [nvarchar](max) NULL,
	[CardName] [nvarchar](max) NULL,
	[CardNumber] [nvarchar](max) NULL,
	[MaskedCreditCardNumber] [nvarchar](max) NULL,
	[CardCvv2] [nvarchar](max) NULL,
	[CardExpirationMonth] [nvarchar](max) NULL,
	[CardExpirationYear] [nvarchar](max) NULL,
	[AuthorizationTransactionId] [nvarchar](max) NULL,
	[AuthorizationTransactionCode] [nvarchar](max) NULL,
	[AuthorizationTransactionResult] [nvarchar](max) NULL,
	[CaptureTransactionId] [nvarchar](max) NULL,
	[CaptureTransactionResult] [nvarchar](max) NULL,
	[SubscriptionTransactionId] [nvarchar](max) NULL,
	[PaidDateUtc] [datetime] NULL,
	[ShippingMethod] [nvarchar](max) NULL,
	[ShippingRateComputationMethodSystemName] [nvarchar](max) NULL,
	[CustomValuesXml] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[PickupAddressId] [int] NULL,
	[RewardPointsHistoryEntryId] [int] NULL,
	[CustomOrderNumber] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK__Order__3214EC075F7E2DAC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderItem]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderItemGuid] [uniqueidentifier] NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPriceInclTax] [decimal](18, 4) NOT NULL,
	[UnitPriceExclTax] [decimal](18, 4) NOT NULL,
	[PriceInclTax] [decimal](18, 4) NOT NULL,
	[PriceExclTax] [decimal](18, 4) NOT NULL,
	[DiscountAmountInclTax] [decimal](18, 4) NOT NULL,
	[DiscountAmountExclTax] [decimal](18, 4) NOT NULL,
	[OriginalProductCost] [decimal](18, 4) NOT NULL,
	[AttributeDescription] [nvarchar](max) NULL,
	[AttributesXml] [nvarchar](max) NULL,
	[DownloadCount] [int] NOT NULL,
	[IsDownloadActivated] [bit] NOT NULL,
	[LicenseDownloadId] [int] NULL,
	[ItemWeight] [decimal](18, 4) NULL,
	[RentalStartDateUtc] [datetime] NULL,
	[RentalEndDateUtc] [datetime] NULL,
	[OrderPay] [bit] NULL,
	[Penalities] [decimal](18, 4) NULL,
	[ReturnPay] [bit] NULL,
	[ItemPrice] [decimal](18, 4) NULL,
	[ItemCost] [decimal](18, 4) NULL,
 CONSTRAINT [PK__OrderIte__3214EC07634EBE90] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderNote]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderNote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[DownloadId] [int] NOT NULL,
	[DisplayToCustomer] [bit] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__OrderNot__3214EC07671F4F74] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PermissionRecord]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[SystemName] [nvarchar](255) NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__Permissi__3214EC076AEFE058] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PermissionRecord_Role_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionRecord_Role_Mapping](
	[PermissionRecord_Id] [int] NOT NULL,
	[CustomerRole_Id] [int] NOT NULL,
 CONSTRAINT [PK__Permissi__4804FB266EC0713C] PRIMARY KEY CLUSTERED 
(
	[PermissionRecord_Id] ASC,
	[CustomerRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Picture]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Picture](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PictureBinary] [varbinary](max) NULL,
	[MimeType] [nvarchar](40) NOT NULL,
	[SeoFilename] [nvarchar](300) NULL,
	[AltAttribute] [nvarchar](max) NULL,
	[TitleAttribute] [nvarchar](max) NULL,
	[IsNew] [bit] NOT NULL,
 CONSTRAINT [PK__Picture__3214EC0772910220] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Poll]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Poll](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[SystemKeyword] [nvarchar](max) NULL,
	[Published] [bit] NOT NULL,
	[ShowOnHomePage] [bit] NOT NULL,
	[AllowGuestsToVote] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[StartDateUtc] [datetime] NULL,
	[EndDateUtc] [datetime] NULL,
 CONSTRAINT [PK__Poll__3214EC0776619304] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PollAnswer]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PollAnswer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PollId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[NumberOfVotes] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__PollAnsw__3214EC077A3223E8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PollVotingRecord]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PollVotingRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PollAnswerId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__PollVoti__3214EC077E02B4CC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PredefinedProductAttributeValue]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PredefinedProductAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[PriceAdjustment] [decimal](18, 4) NOT NULL,
	[WeightAdjustment] [decimal](18, 4) NOT NULL,
	[Cost] [decimal](18, 4) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Predefin__3214EC0701D345B0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductTypeId] [int] NOT NULL,
	[ParentGroupedProductId] [int] NOT NULL,
	[VisibleIndividually] [bit] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ShortDescription] [nvarchar](max) NULL,
	[FullDescription] [nvarchar](max) NULL,
	[AdminComment] [nvarchar](max) NULL,
	[ProductTemplateId] [int] NOT NULL,
	[VendorId] [int] NOT NULL,
	[ShowOnHomePage] [bit] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[AllowCustomerReviews] [bit] NOT NULL,
	[ApprovedRatingSum] [int] NOT NULL,
	[NotApprovedRatingSum] [int] NOT NULL,
	[ApprovedTotalReviews] [int] NOT NULL,
	[NotApprovedTotalReviews] [int] NOT NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Sku] [nvarchar](400) NULL,
	[ManufacturerPartNumber] [nvarchar](400) NULL,
	[Gtin] [nvarchar](400) NULL,
	[IsGiftCard] [bit] NOT NULL,
	[GiftCardTypeId] [int] NOT NULL,
	[RequireOtherProducts] [bit] NOT NULL,
	[RequiredProductIds] [nvarchar](1000) NULL,
	[AutomaticallyAddRequiredProducts] [bit] NOT NULL,
	[IsDownload] [bit] NOT NULL,
	[DownloadId] [int] NOT NULL,
	[UnlimitedDownloads] [bit] NOT NULL,
	[MaxNumberOfDownloads] [int] NOT NULL,
	[DownloadExpirationDays] [int] NULL,
	[DownloadActivationTypeId] [int] NOT NULL,
	[HasSampleDownload] [bit] NOT NULL,
	[SampleDownloadId] [int] NOT NULL,
	[HasUserAgreement] [bit] NOT NULL,
	[UserAgreementText] [nvarchar](max) NULL,
	[IsRecurring] [bit] NOT NULL,
	[RecurringCycleLength] [int] NOT NULL,
	[RecurringCyclePeriodId] [int] NOT NULL,
	[RecurringTotalCycles] [int] NOT NULL,
	[IsRental] [bit] NOT NULL,
	[RentalPriceLength] [int] NOT NULL,
	[RentalPricePeriodId] [int] NOT NULL,
	[IsShipEnabled] [bit] NOT NULL,
	[IsFreeShipping] [bit] NOT NULL,
	[ShipSeparately] [bit] NOT NULL,
	[AdditionalShippingCharge] [decimal](18, 4) NOT NULL,
	[DeliveryDateId] [int] NOT NULL,
	[IsTaxExempt] [bit] NOT NULL,
	[TaxCategoryId] [int] NOT NULL,
	[IsTelecommunicationsOrBroadcastingOrElectronicServices] [bit] NOT NULL,
	[ManageInventoryMethodId] [int] NOT NULL,
	[UseMultipleWarehouses] [bit] NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[DisplayStockAvailability] [bit] NOT NULL,
	[DisplayStockQuantity] [bit] NOT NULL,
	[MinStockQuantity] [int] NOT NULL,
	[LowStockActivityId] [int] NOT NULL,
	[NotifyAdminForQuantityBelow] [int] NOT NULL,
	[BackorderModeId] [int] NOT NULL,
	[AllowBackInStockSubscriptions] [bit] NOT NULL,
	[OrderMinimumQuantity] [int] NOT NULL,
	[OrderMaximumQuantity] [int] NOT NULL,
	[AllowedQuantities] [nvarchar](1000) NULL,
	[AllowAddingOnlyExistingAttributeCombinations] [bit] NOT NULL,
	[DisableBuyButton] [bit] NOT NULL,
	[DisableWishlistButton] [bit] NOT NULL,
	[AvailableForPreOrder] [bit] NOT NULL,
	[PreOrderAvailabilityStartDateTimeUtc] [datetime] NULL,
	[CallForPrice] [bit] NOT NULL,
	[Price] [decimal](18, 4) NOT NULL,
	[OldPrice] [decimal](18, 4) NOT NULL,
	[ProductCost] [decimal](18, 4) NOT NULL,
	[CustomerEntersPrice] [bit] NOT NULL,
	[MinimumCustomerEnteredPrice] [decimal](18, 4) NOT NULL,
	[MaximumCustomerEnteredPrice] [decimal](18, 4) NOT NULL,
	[BasepriceEnabled] [bit] NOT NULL,
	[BasepriceAmount] [decimal](18, 4) NOT NULL,
	[BasepriceUnitId] [int] NOT NULL,
	[BasepriceBaseAmount] [decimal](18, 4) NOT NULL,
	[BasepriceBaseUnitId] [int] NOT NULL,
	[HasTierPrices] [bit] NOT NULL,
	[HasDiscountsApplied] [bit] NOT NULL,
	[Weight] [decimal](18, 4) NOT NULL,
	[Length] [decimal](18, 4) NOT NULL,
	[Width] [decimal](18, 4) NOT NULL,
	[Height] [decimal](18, 4) NOT NULL,
	[AvailableStartDateTimeUtc] [datetime] NULL,
	[AvailableEndDateTimeUtc] [datetime] NULL,
	[DisplayOrder] [int] NOT NULL,
	[Published] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
	[OverriddenGiftCardAmount] [decimal](18, 0) NULL,
	[MarkAsNew] [bit] NOT NULL,
	[MarkAsNewStartDateTimeUtc] [datetime] NULL,
	[MarkAsNewEndDateTimeUtc] [datetime] NULL,
	[NotReturnable] [bit] NOT NULL,
	[ProductAvailabilityRangeId] [int] NOT NULL,
 CONSTRAINT [PK__Product__3214EC0705A3D694] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product_Category_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Category_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[IsFeaturedProduct] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Product___3214EC0709746778] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product_Manufacturer_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Manufacturer_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ManufacturerId] [int] NOT NULL,
	[IsFeaturedProduct] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Product___3214EC070D44F85C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product_Picture_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Picture_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Product___3214EC0711158940] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product_ProductAttribute_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_ProductAttribute_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductAttributeId] [int] NOT NULL,
	[TextPrompt] [nvarchar](max) NULL,
	[IsRequired] [bit] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[ValidationMinLength] [int] NULL,
	[ValidationMaxLength] [int] NULL,
	[ValidationFileAllowedExtensions] [nvarchar](max) NULL,
	[ValidationFileMaximumSize] [int] NULL,
	[DefaultValue] [nvarchar](max) NULL,
	[ConditionAttributeXml] [nvarchar](max) NULL,
 CONSTRAINT [PK__Product___3214EC0714E61A24] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product_ProductTag_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_ProductTag_Mapping](
	[Product_Id] [int] NOT NULL,
	[ProductTag_Id] [int] NOT NULL,
 CONSTRAINT [PK__Product___F62CEB0918B6AB08] PRIMARY KEY CLUSTERED 
(
	[Product_Id] ASC,
	[ProductTag_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product_SpecificationAttribute_Mapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_SpecificationAttribute_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[AttributeTypeId] [int] NOT NULL,
	[SpecificationAttributeOptionId] [int] NOT NULL,
	[CustomValue] [nvarchar](4000) NULL,
	[AllowFiltering] [bit] NOT NULL,
	[ShowOnProductPage] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Product___3214EC071C873BEC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductAttribute]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK__ProductA__3214EC072057CCD0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductAttributeCombination]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAttributeCombination](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[AttributesXml] [nvarchar](max) NULL,
	[StockQuantity] [int] NOT NULL,
	[AllowOutOfStockOrders] [bit] NOT NULL,
	[Sku] [nvarchar](400) NULL,
	[ManufacturerPartNumber] [nvarchar](400) NULL,
	[Gtin] [nvarchar](400) NULL,
	[OverriddenPrice] [decimal](18, 4) NULL,
	[NotifyAdminForQuantityBelow] [int] NOT NULL,
 CONSTRAINT [PK__ProductA__3214EC0724285DB4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductAttributeValue]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductAttributeMappingId] [int] NOT NULL,
	[AttributeValueTypeId] [int] NOT NULL,
	[AssociatedProductId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ColorSquaresRgb] [nvarchar](100) NULL,
	[PriceAdjustment] [decimal](18, 4) NOT NULL,
	[WeightAdjustment] [decimal](18, 4) NOT NULL,
	[Cost] [decimal](18, 4) NOT NULL,
	[Quantity] [int] NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
	[ImageSquaresPictureId] [int] NOT NULL,
	[CustomerEntersQty] [bit] NOT NULL,
 CONSTRAINT [PK__ProductA__3214EC0727F8EE98] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductAvailabilityRange]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAvailabilityRange](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__ProductA__3214EC070F824689] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductReview]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductReview](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[ReviewText] [nvarchar](max) NULL,
	[Rating] [int] NOT NULL,
	[HelpfulYesTotal] [int] NOT NULL,
	[HelpfulNoTotal] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[StoreId] [int] NOT NULL,
	[ReplyText] [nvarchar](max) NULL,
 CONSTRAINT [PK__ProductR__3214EC072BC97F7C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductReviewHelpfulness]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductReviewHelpfulness](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductReviewId] [int] NOT NULL,
	[WasHelpful] [bit] NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK__ProductR__3214EC072F9A1060] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductTag]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTag](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
 CONSTRAINT [PK__ProductT__3214EC07336AA144] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductTemplate]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[IgnoredProductTypes] [nvarchar](max) NULL,
 CONSTRAINT [PK__ProductT__3214EC07373B3228] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductWarehouseInventory]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductWarehouseInventory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[ReservedQuantity] [int] NOT NULL,
 CONSTRAINT [PK__ProductW__3214EC073B0BC30C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QueuedEmail]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueuedEmail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PriorityId] [int] NOT NULL,
	[From] [nvarchar](500) NOT NULL,
	[FromName] [nvarchar](500) NULL,
	[To] [nvarchar](500) NOT NULL,
	[ToName] [nvarchar](500) NULL,
	[ReplyTo] [nvarchar](500) NULL,
	[ReplyToName] [nvarchar](500) NULL,
	[CC] [nvarchar](500) NULL,
	[Bcc] [nvarchar](500) NULL,
	[Subject] [nvarchar](1000) NULL,
	[Body] [nvarchar](max) NULL,
	[AttachmentFilePath] [nvarchar](max) NULL,
	[AttachmentFileName] [nvarchar](max) NULL,
	[AttachedDownloadId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[SentTries] [int] NOT NULL,
	[SentOnUtc] [datetime] NULL,
	[EmailAccountId] [int] NOT NULL,
	[DontSendBeforeDateUtc] [datetime] NULL,
 CONSTRAINT [PK__QueuedEm__3214EC073EDC53F0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RecurringPayment]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecurringPayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CycleLength] [int] NOT NULL,
	[CyclePeriodId] [int] NOT NULL,
	[TotalCycles] [int] NOT NULL,
	[StartDateUtc] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[InitialOrderId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[LastPaymentFailed] [bit] NOT NULL,
 CONSTRAINT [PK__Recurrin__3214EC0742ACE4D4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RecurringPaymentHistory]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecurringPaymentHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RecurringPaymentId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Recurrin__3214EC07467D75B8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RelatedProduct]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelatedProduct](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId1] [int] NOT NULL,
	[ProductId2] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__RelatedP__3214EC074A4E069C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReturnRequest]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[OrderItemId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[ReasonForReturn] [nvarchar](max) NOT NULL,
	[RequestedAction] [nvarchar](max) NOT NULL,
	[CustomerComments] [nvarchar](max) NULL,
	[StaffNotes] [nvarchar](max) NULL,
	[ReturnRequestStatusId] [int] NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
	[CustomNumber] [nvarchar](max) NOT NULL,
	[UploadedFileId] [int] NOT NULL,
 CONSTRAINT [PK__ReturnRe__3214EC074E1E9780] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReturnRequestAction]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnRequestAction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__ReturnRe__3214EC0751EF2864] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReturnRequestReason]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnRequestReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__ReturnRe__3214EC0755BFB948] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RewardPointsHistory]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RewardPointsHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Points] [int] NOT NULL,
	[PointsBalance] [int] NULL,
	[UsedAmount] [decimal](18, 4) NOT NULL,
	[Message] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UsedWithOrder_Id] [int] NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK__RewardPo__3214EC0759904A2C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ScheduleTask]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleTask](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Seconds] [int] NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[StopOnError] [bit] NOT NULL,
	[LastStartUtc] [datetime] NULL,
	[LastEndUtc] [datetime] NULL,
	[LastSuccessUtc] [datetime] NULL,
 CONSTRAINT [PK__Schedule__3214EC075D60DB10] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SearchTerm]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchTerm](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Keyword] [nvarchar](max) NULL,
	[StoreId] [int] NOT NULL,
	[Count] [int] NOT NULL,
 CONSTRAINT [PK__SearchTe__3214EC0761316BF4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Setting]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Setting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Value] [nvarchar](2000) NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK__Setting__3214EC076501FCD8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Shipment]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[TrackingNumber] [nvarchar](max) NULL,
	[TotalWeight] [decimal](18, 4) NULL,
	[ShippedDateUtc] [datetime] NULL,
	[DeliveryDateUtc] [datetime] NULL,
	[AdminComment] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[ReadyShippedDateUtc] [datetime] NULL,
 CONSTRAINT [PK__Shipment__3214EC0768D28DBC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShipmentItem]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentId] [int] NOT NULL,
	[OrderItemId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[WarehouseId] [int] NOT NULL,
 CONSTRAINT [PK__Shipment__3214EC076CA31EA0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShippingByWeight]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingByWeight](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[StateProvinceId] [int] NOT NULL,
	[Zip] [nvarchar](400) NULL,
	[ShippingMethodId] [int] NOT NULL,
	[From] [decimal](18, 2) NOT NULL,
	[To] [decimal](18, 2) NOT NULL,
	[AdditionalFixedCost] [decimal](18, 2) NOT NULL,
	[PercentageRateOfSubtotal] [decimal](18, 2) NOT NULL,
	[RatePerWeightUnit] [decimal](18, 2) NOT NULL,
	[LowerWeightLimit] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK__Shipping__3214EC077073AF84] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShippingMethod]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingMethod](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Shipping__3214EC0774444068] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShippingMethodRestrictions]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingMethodRestrictions](
	[ShippingMethod_Id] [int] NOT NULL,
	[Country_Id] [int] NOT NULL,
 CONSTRAINT [PK__Shipping__9CE6B8E17814D14C] PRIMARY KEY CLUSTERED 
(
	[ShippingMethod_Id] ASC,
	[Country_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShoppingCartItem]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[ShoppingCartTypeId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[AttributesXml] [nvarchar](max) NULL,
	[CustomerEnteredPrice] [decimal](18, 4) NOT NULL,
	[Quantity] [int] NOT NULL,
	[RentalStartDateUtc] [datetime] NULL,
	[RentalEndDateUtc] [datetime] NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[UpdatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__Shopping__3214EC077BE56230] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SpecificationAttribute]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpecificationAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__Specific__3214EC077FB5F314] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SpecificationAttributeOption]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpecificationAttributeOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SpecificationAttributeId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[ColorSquaresRgb] [nvarchar](100) NULL,
 CONSTRAINT [PK__Specific__3214EC07038683F8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_AS_AnywhereSlider]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_AS_AnywhereSlider](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [nvarchar](400) NOT NULL,
	[SliderType] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK__SS_AS_An__3214EC07075714DC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_AS_SliderImage]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_AS_SliderImage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DisplayText] [nvarchar](max) NULL,
	[Url] [nvarchar](max) NULL,
	[Alt] [nvarchar](max) NULL,
	[Visible] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
	[SliderId] [int] NOT NULL,
 CONSTRAINT [PK__SS_AS_Sl__3214EC070B27A5C0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_C_Condition]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_C_Condition](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK__SS_C_Con__3214EC070EF836A4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_C_ConditionGroup]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_C_ConditionGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConditionId] [int] NOT NULL,
 CONSTRAINT [PK__SS_C_Con__3214EC0712C8C788] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_C_ConditionStatement]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_C_ConditionStatement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConditionType] [int] NOT NULL,
	[ConditionProperty] [int] NOT NULL,
	[OperatorType] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ConditionGroupId] [int] NOT NULL,
 CONSTRAINT [PK__SS_C_Con__3214EC071699586C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_C_CustomerOverride]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_C_CustomerOverride](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConditionId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[OverrideState] [int] NOT NULL,
 CONSTRAINT [PK__SS_C_Cus__3214EC071A69E950] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_C_EntityCondition]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_C_EntityCondition](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConditionId] [int] NOT NULL,
	[EntityType] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK__SS_C_Ent__3214EC071E3A7A34] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_C_ProductOverride]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_C_ProductOverride](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConditionId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductState] [int] NOT NULL,
 CONSTRAINT [PK__SS_C_Pro__3214EC07220B0B18] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_ES_EntitySetting]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_ES_EntitySetting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[Key] [nvarchar](max) NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK__SS_ES_En__3214EC0725DB9BFC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_JC_JCarousel]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_JC_JCarousel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Title] [nvarchar](250) NULL,
	[DataSourceType] [nvarchar](max) NULL,
	[LimitedToStores] [bit] NOT NULL,
	[CarouselType] [int] NOT NULL,
	[DataSourceEntityId] [int] NOT NULL,
 CONSTRAINT [PK__SS_JC_JC__3214EC07314D4EA8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_MAP_EntityMapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_MAP_EntityMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[MappedEntityId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[MappingType] [int] NOT NULL,
 CONSTRAINT [PK__SS_MAP_E__3214EC07351DDF8C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_MAP_EntityWidgetMapping]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_MAP_EntityWidgetMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[WidgetZone] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__SS_MAP_E__3214EC0738EE7070] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_MM_Menu]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_MM_Menu](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CssClass] [nvarchar](max) NULL,
	[ShowDropdownsOnClick] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK__SS_MM_Me__3214EC077D63964E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_MM_MenuItem]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_MM_MenuItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [int] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Url] [nvarchar](max) NULL,
	[OpenInNewWindow] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CssClass] [nvarchar](max) NULL,
	[MaximumNumberOfEntities] [int] NOT NULL,
	[NumberOfBoxesPerRow] [int] NOT NULL,
	[CatalogTemplate] [int] NOT NULL,
	[ImageSize] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[WidgetZone] [nvarchar](max) NULL,
	[Width] [decimal](18, 2) NOT NULL,
	[ParentMenuItemId] [int] NOT NULL,
	[MenuId] [int] NULL,
	[SubjectToAcl] [bit] NOT NULL,
 CONSTRAINT [PK__SS_MM_Me__3214EC0701342732] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_PR_CategoryPageRibbon]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_PR_CategoryPageRibbon](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductRibbonId] [int] NOT NULL,
	[PictureId] [int] NULL,
	[Enabled] [bit] NOT NULL,
	[Text] [nvarchar](max) NULL,
	[Position] [nvarchar](max) NULL,
	[TextStyle] [nvarchar](max) NULL,
	[ImageStyle] [nvarchar](max) NULL,
	[ContainerStyle] [nvarchar](max) NULL,
 CONSTRAINT [PK__SS_PR_Ca__3214EC073CBF0154] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_PR_ProductPageRibbon]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_PR_ProductPageRibbon](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductRibbonId] [int] NOT NULL,
	[PictureId] [int] NULL,
	[Enabled] [bit] NOT NULL,
	[Text] [nvarchar](max) NULL,
	[Position] [nvarchar](max) NULL,
	[TextStyle] [nvarchar](max) NULL,
	[ImageStyle] [nvarchar](max) NULL,
	[ContainerStyle] [nvarchar](max) NULL,
 CONSTRAINT [PK__SS_PR_Pr__3214EC07408F9238] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_PR_ProductRibbon]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_PR_ProductRibbon](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[StopAddingRibbonsAftherThisOneIsAdded] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK__SS_PR_Pr__3214EC074460231C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_PR_RibbonPicture]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_PR_RibbonPicture](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PictureId] [int] NOT NULL,
 CONSTRAINT [PK__SS_PR_Ri__3214EC074830B400] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_QT_Tab]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_QT_Tab](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [nvarchar](400) NOT NULL,
	[DisplayName] [nvarchar](400) NULL,
	[Description] [nvarchar](max) NULL,
	[LimitedToStores] [bit] NOT NULL,
	[TabMode] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__SS_QT_Ta__3214EC074C0144E4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_RB_Category]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_RB_Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[Published] [bit] NOT NULL,
	[SEOTitle] [nvarchar](max) NULL,
	[SEODescription] [nvarchar](max) NULL,
	[SEOKeywords] [nvarchar](max) NULL,
	[SEName] [nvarchar](max) NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK__SS_RB_Ca__3214EC074FD1D5C8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_RB_Post]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_RB_Post](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HomePagePictureId] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
	[BlogPostId] [int] NOT NULL,
 CONSTRAINT [PK__SS_RB_Po__3214EC0753A266AC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_RB_RelatedBlog]    Script Date: 7/4/2019 4:54:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_RB_RelatedBlog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BlogPostId] [int] NOT NULL,
	[RelatedBlogPostId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__SS_RB_Re__3214EC075772F790] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_RB_RichBlogPostCategoryMapping]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_RB_RichBlogPostCategoryMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BlogPostId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK__SS_RB_Ri__3214EC075B438874] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_S_Schedule]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_S_Schedule](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityType] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityFromDate] [datetime] NULL,
	[EntityToDate] [datetime] NULL,
	[SchedulePatternType] [int] NOT NULL,
	[SchedulePatternFromTime] [time](7) NULL,
	[SchedulePatternToTime] [time](7) NULL,
	[ExactDayValue] [int] NULL,
	[EveryMonthFromDayValue] [int] NULL,
	[EveryMonthToDayValue] [int] NULL,
 CONSTRAINT [PK__SS_S_Sch__3214EC075F141958] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_SPC_ProductsGroup]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_SPC_ProductsGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Published] [bit] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[WidgetZone] [nvarchar](max) NULL,
	[Store] [int] NOT NULL,
	[NumberOfProductsPerItem] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__SS_HPP_P__3214EC0729AC2CE0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SS_SPC_ProductsGroupItem]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SS_SPC_ProductsGroupItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Active] [bit] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[SourceType] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[SortMethod] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
 CONSTRAINT [PK__SS_HPP_P__3214EC072D7CBDC4] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StateProvince]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateProvince](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Abbreviation] [nvarchar](100) NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__StatePro__3214EC0762E4AA3C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockQuantityHistory]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockQuantityHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[CombinationId] [int] NULL,
	[WarehouseId] [int] NULL,
	[QuantityAdjustment] [int] NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[Message] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__StockQua__3214EC0718178C8A] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Store]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Store](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Url] [nvarchar](400) NOT NULL,
	[SslEnabled] [bit] NOT NULL,
	[SecureUrl] [nvarchar](400) NULL,
	[Hosts] [nvarchar](1000) NULL,
	[DisplayOrder] [int] NOT NULL,
	[CompanyName] [nvarchar](1000) NULL,
	[CompanyAddress] [nvarchar](1000) NULL,
	[CompanyPhoneNumber] [nvarchar](1000) NULL,
	[CompanyVat] [nvarchar](1000) NULL,
	[DefaultLanguageId] [int] NOT NULL,
 CONSTRAINT [PK__Store__3214EC0766B53B20] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StoreMapping]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityName] [nvarchar](400) NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK__StoreMap__3214EC076A85CC04] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaxCategory]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__TaxCateg__3214EC076E565CE8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaxRate]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxRate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[TaxCategoryId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[StateProvinceId] [int] NOT NULL,
	[Zip] [nvarchar](max) NULL,
	[Percentage] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK__TaxRate__3214EC077226EDCC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TierPrice]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TierPrice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[StoreId] [int] NOT NULL,
	[CustomerRoleId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](18, 4) NOT NULL,
	[StartDateTimeUtc] [datetime] NULL,
	[EndDateTimeUtc] [datetime] NULL,
 CONSTRAINT [PK__TierPric__3214EC0775F77EB0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Topic]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [nvarchar](max) NULL,
	[IncludeInSitemap] [bit] NOT NULL,
	[IncludeInTopMenu] [bit] NOT NULL,
	[IncludeInFooterColumn1] [bit] NOT NULL,
	[IncludeInFooterColumn2] [bit] NOT NULL,
	[IncludeInFooterColumn3] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[AccessibleWhenStoreClosed] [bit] NOT NULL,
	[IsPasswordProtected] [bit] NOT NULL,
	[Password] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[Body] [nvarchar](max) NULL,
	[TopicTemplateId] [int] NOT NULL,
	[MetaKeywords] [nvarchar](max) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](max) NULL,
	[LimitedToStores] [bit] NOT NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
 CONSTRAINT [PK__Topic__3214EC0779C80F94] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TopicTemplate]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopicTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK__TopicTem__3214EC077D98A078] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UrlRecord]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UrlRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityName] [nvarchar](400) NOT NULL,
	[Slug] [nvarchar](400) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LanguageId] [int] NOT NULL,
 CONSTRAINT [PK__UrlRecor__3214EC070169315C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vendor]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Email] [nvarchar](400) NULL,
	[Description] [nvarchar](max) NULL,
	[AdminComment] [nvarchar](max) NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[PageSize] [int] NOT NULL,
	[AllowCustomersToSelectPageSize] [bit] NOT NULL,
	[PageSizeOptions] [nvarchar](200) NULL,
	[PictureId] [int] NOT NULL,
	[AddressId] [int] NOT NULL,
	[PickFee] [decimal](18, 4) NULL,
	[IBAN] [nvarchar](400) NULL,
	[SwftCode] [nvarchar](400) NULL,
	[BankName] [nvarchar](400) NULL,
	[Currancy] [nvarchar](400) NULL,
	[Branch] [nvarchar](400) NULL,
	[Country] [nvarchar](400) NULL,
	[AccountNumber] [nvarchar](400) NULL,
 CONSTRAINT [PK__Vendor__3214EC070539C240] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VendorNote]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorNote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
 CONSTRAINT [PK__VendorNo__3214EC07090A5324] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[AdminComment] [nvarchar](max) NULL,
	[AddressId] [int] NOT NULL,
 CONSTRAINT [PK__Warehous__3214EC070CDAE408] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[udf-Str-Parse]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[udf-Str-Parse] (@arrayKeys varchar(max),@Delimiter varchar(10))
Returns Table 
As
Return (  
    Select RetSeq = Row_Number() over (Order By (Select null))
          ,RetVal = LTrim(RTrim(B.i.value('(./text())[1]', 'varchar(max)')))
    From (Select x = Cast('<x>'+ Replace(@arrayKeys,@Delimiter,'</x><x>')+'</x>' as xml).query('.')) as A 
    Cross Apply x.nodes('x') AS B(i)
);



GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AclRecord_EntityId_EntityName]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_AclRecord_EntityId_EntityName] ON [dbo].[AclRecord]
(
	[EntityId] ASC,
	[EntityName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ActivityLog_CreatedOnUtc]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_ActivityLog_CreatedOnUtc] ON [dbo].[ActivityLog]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [nci_wi_ActivityLog_919D6E4B7C9EEC86C0529E3C05012466]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_ActivityLog_919D6E4B7C9EEC86C0529E3C05012466] ON [dbo].[ActivityLog]
(
	[CustomerId] ASC
)
INCLUDE ( 	[ActivityLogTypeId],
	[Comment],
	[CreatedOnUtc],
	[IpAddress]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BlogComment_BlogPostId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_BlogComment_BlogPostId] ON [dbo].[BlogComment]
(
	[BlogPostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BlogPost_LanguageId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_BlogPost_LanguageId] ON [dbo].[BlogPost]
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Category_DisplayOrder] ON [dbo].[Category]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_LimitedToStores]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Category_LimitedToStores] ON [dbo].[Category]
(
	[LimitedToStores] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_ParentCategoryId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Category_ParentCategoryId] ON [dbo].[Category]
(
	[ParentCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_SubjectToAcl]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Category_SubjectToAcl] ON [dbo].[Category]
(
	[SubjectToAcl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Country_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Country_DisplayOrder] ON [dbo].[Country]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Currency_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Currency_DisplayOrder] ON [dbo].[Currency]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_CreatedOnUtc]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_CreatedOnUtc] ON [dbo].[Customer]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_CustomerGuid]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_CustomerGuid] ON [dbo].[Customer]
(
	[CustomerGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Customer_Email]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_Email] ON [dbo].[Customer]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Customer_SystemName]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_SystemName] ON [dbo].[Customer]
(
	[SystemName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Customer_Username]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_Username] ON [dbo].[Customer]
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_CustomerRole_Mapping_Customer_Id]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_CustomerRole_Mapping_Customer_Id] ON [dbo].[Customer_CustomerRole_Mapping]
(
	[Customer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Forum_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Forum_DisplayOrder] ON [dbo].[Forums_Forum]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Forum_ForumGroupId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Forum_ForumGroupId] ON [dbo].[Forums_Forum]
(
	[ForumGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Group_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Group_DisplayOrder] ON [dbo].[Forums_Group]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Post_CustomerId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Post_CustomerId] ON [dbo].[Forums_Post]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Post_TopicId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Post_TopicId] ON [dbo].[Forums_Post]
(
	[TopicId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Subscription_ForumId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Subscription_ForumId] ON [dbo].[Forums_Subscription]
(
	[ForumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Subscription_TopicId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Subscription_TopicId] ON [dbo].[Forums_Subscription]
(
	[TopicId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Topic_ForumId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Topic_ForumId] ON [dbo].[Forums_Topic]
(
	[ForumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GenericAttribute_EntityId_and_KeyGroup]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_GenericAttribute_EntityId_and_KeyGroup] ON [dbo].[GenericAttribute]
(
	[EntityId] ASC,
	[KeyGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Language_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Language_DisplayOrder] ON [dbo].[Language]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_LocaleStringResource]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_LocaleStringResource] ON [dbo].[LocaleStringResource]
(
	[ResourceName] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [NonClusteredIndex-20180530-220305]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180530-220305] ON [dbo].[LocaleStringResource]
(
	[ResourceName] ASC
)
INCLUDE ( 	[Id],
	[LanguageId],
	[ResourceValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [NonClusteredIndex-20180906-195428]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180906-195428] ON [dbo].[LocalizedProperty]
(
	[EntityId] ASC,
	[LanguageId] ASC,
	[LocaleKeyGroup] ASC,
	[LocaleKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Log_CreatedOnUtc]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Log_CreatedOnUtc] ON [dbo].[Log]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Manufacturer_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Manufacturer_DisplayOrder] ON [dbo].[Manufacturer]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Manufacturer_LimitedToStores]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Manufacturer_LimitedToStores] ON [dbo].[Manufacturer]
(
	[LimitedToStores] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Manufacturer_SubjectToAcl]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Manufacturer_SubjectToAcl] ON [dbo].[Manufacturer]
(
	[SubjectToAcl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_News_LanguageId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_News_LanguageId] ON [dbo].[News]
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_NewsComment_NewsItemId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_NewsComment_NewsItemId] ON [dbo].[NewsComment]
(
	[NewsItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_NewsletterSubscription_Email_StoreId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_NewsletterSubscription_Email_StoreId] ON [dbo].[NewsLetterSubscription]
(
	[Email] ASC,
	[StoreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_CreatedOnUtc]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Order_CreatedOnUtc] ON [dbo].[Order]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_CustomerId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Order_CustomerId] ON [dbo].[Order]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderItem_OrderId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrderItem_OrderId] ON [dbo].[OrderItem]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderNote_OrderId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrderNote_OrderId] ON [dbo].[OrderNote]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Mix_IDX]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [Mix_IDX] ON [dbo].[Picture]
(
	[MimeType] ASC,
	[SeoFilename] ASC,
	[IsNew] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [SeoFileName_IDX]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [SeoFileName_IDX] ON [dbo].[Picture]
(
	[SeoFilename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PollAnswer_PollId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PollAnswer_PollId] ON [dbo].[PollAnswer]
(
	[PollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Delete_Id]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Delete_Id] ON [dbo].[Product]
(
	[Deleted] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Deleted_and_Published]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Deleted_and_Published] ON [dbo].[Product]
(
	[Published] ASC,
	[Deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_LimitedToStores]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_LimitedToStores] ON [dbo].[Product]
(
	[LimitedToStores] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ParentGroupedProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ParentGroupedProductId] ON [dbo].[Product]
(
	[ParentGroupedProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_PriceDatesEtc]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_PriceDatesEtc] ON [dbo].[Product]
(
	[Price] ASC,
	[AvailableStartDateTimeUtc] ASC,
	[AvailableEndDateTimeUtc] ASC,
	[Published] ASC,
	[Deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Published]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Published] ON [dbo].[Product]
(
	[Published] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ShowOnHomepage]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ShowOnHomepage] ON [dbo].[Product]
(
	[ShowOnHomePage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_SubjectToAcl]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_SubjectToAcl] ON [dbo].[Product]
(
	[SubjectToAcl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_VisibleIndividually]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_VisibleIndividually] ON [dbo].[Product]
(
	[VisibleIndividually] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [nci_wi_Product_059E43425AD1A6889F7786FE4AD3C988]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_Product_059E43425AD1A6889F7786FE4AD3C988] ON [dbo].[Product]
(
	[Published] ASC,
	[Deleted] ASC,
	[VendorId] ASC
)
INCLUDE ( 	[AvailableEndDateTimeUtc],
	[AvailableStartDateTimeUtc],
	[LimitedToStores],
	[Name],
	[Price],
	[ProductTypeId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [nci_wi_Product_AC74A2C2CC117092DD4A2C06B919E93D]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_Product_AC74A2C2CC117092DD4A2C06B919E93D] ON [dbo].[Product]
(
	[Published] ASC,
	[VisibleIndividually] ASC,
	[Deleted] ASC
)
INCLUDE ( 	[AvailableEndDateTimeUtc],
	[AvailableStartDateTimeUtc],
	[CreatedOnUtc],
	[Name],
	[Price],
	[SubjectToAcl]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [nci_wi_Product_D58AD442CF34B7B46ECB47A3C5187670]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_Product_D58AD442CF34B7B46ECB47A3C5187670] ON [dbo].[Product]
(
	[Published] ASC,
	[ProductTypeId] ASC,
	[Deleted] ASC
)
INCLUDE ( 	[AvailableEndDateTimeUtc],
	[AvailableStartDateTimeUtc],
	[Price]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [nci_wi_Product_DEE78F20E4088223BDE779953A7C3994]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_Product_DEE78F20E4088223BDE779953A7C3994] ON [dbo].[Product]
(
	[Published] ASC,
	[VisibleIndividually] ASC,
	[Deleted] ASC,
	[LimitedToStores] ASC
)
INCLUDE ( 	[AvailableEndDateTimeUtc],
	[AvailableStartDateTimeUtc],
	[CreatedOnUtc],
	[Name],
	[Price],
	[SubjectToAcl]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Idx_CategoryId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [Idx_CategoryId] ON [dbo].[Product_Category_Mapping]
(
	[CategoryId] ASC
)
INCLUDE ( 	[IsFeaturedProduct],
	[DisplayOrder],
	[ProductId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Idx_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [Idx_ProductId] ON [dbo].[Product_Category_Mapping]
(
	[ProductId] ASC
)
INCLUDE ( 	[CategoryId],
	[IsFeaturedProduct],
	[DisplayOrder]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PCM_Product_and_Category]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PCM_Product_and_Category] ON [dbo].[Product_Category_Mapping]
(
	[CategoryId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PCM_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PCM_ProductId] ON [dbo].[Product_Category_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PCM_ProductId_Extended]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PCM_ProductId_Extended] ON [dbo].[Product_Category_Mapping]
(
	[ProductId] ASC,
	[IsFeaturedProduct] ASC
)
INCLUDE ( 	[CategoryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Category_Mapping_CategoryId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Category_Mapping_CategoryId] ON [dbo].[Product_Category_Mapping]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Category_Mapping_IsFeaturedProduct]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Category_Mapping_IsFeaturedProduct] ON [dbo].[Product_Category_Mapping]
(
	[IsFeaturedProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Category_Mapping_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Category_Mapping_ProductId] ON [dbo].[Product_Category_Mapping]
(
	[ProductId] ASC
)
INCLUDE ( 	[CategoryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [nci_wi_Product_Category_Mapping_93C948007C073782E15DF7D12A8C2CBE]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_Product_Category_Mapping_93C948007C073782E15DF7D12A8C2CBE] ON [dbo].[Product_Category_Mapping]
(
	[IsFeaturedProduct] ASC
)
INCLUDE ( 	[CategoryId],
	[DisplayOrder],
	[ProductId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [nci_wi_Product_Category_Mapping_A77BAA76EA3464FD414F41221DE393E1]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [nci_wi_Product_Category_Mapping_A77BAA76EA3464FD414F41221DE393E1] ON [dbo].[Product_Category_Mapping]
(
	[CategoryId] ASC,
	[IsFeaturedProduct] ASC
)
INCLUDE ( 	[DisplayOrder],
	[ProductId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PMM_Product_and_Manufacturer]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PMM_Product_and_Manufacturer] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ManufacturerId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PMM_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PMM_ProductId] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PMM_ProductId_Extended]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PMM_ProductId_Extended] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ProductId] ASC,
	[IsFeaturedProduct] ASC
)
INCLUDE ( 	[ManufacturerId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Manufacturer_Mapping_IsFeaturedProduct]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Manufacturer_Mapping_IsFeaturedProduct] ON [dbo].[Product_Manufacturer_Mapping]
(
	[IsFeaturedProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Manufacturer_Mapping_ManufacturerId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Manufacturer_Mapping_ManufacturerId] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ManufacturerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Picture_Mapping_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Picture_Mapping_ProductId] ON [dbo].[Product_Picture_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20180530-212347]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20180530-212347] ON [dbo].[Product_Picture_Mapping]
(
	[ProductId] ASC
)
INCLUDE ( 	[Id],
	[PictureId],
	[DisplayOrder]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ProductAttribute_Mapping_ProductId_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ProductAttribute_Mapping_ProductId_DisplayOrder] ON [dbo].[Product_ProductAttribute_Mapping]
(
	[ProductId] ASC,
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_SpecificationAttribute_Mapping_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Product_SpecificationAttribute_Mapping_ProductId] ON [dbo].[Product_SpecificationAttribute_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PSAM_AllowFiltering]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_PSAM_AllowFiltering] ON [dbo].[Product_SpecificationAttribute_Mapping]
(
	[AllowFiltering] ASC
)
INCLUDE ( 	[ProductId],
	[SpecificationAttributeOptionId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductAttributeValue_ProductAttributeMappingId_DisplayOrder]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProductAttributeValue_ProductAttributeMappingId_DisplayOrder] ON [dbo].[ProductAttributeValue]
(
	[ProductAttributeMappingId] ASC,
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductReview_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProductReview_ProductId] ON [dbo].[ProductReview]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProductTag_Name]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProductTag_Name] ON [dbo].[ProductTag]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_QueuedEmail_CreatedOnUtc]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_QueuedEmail_CreatedOnUtc] ON [dbo].[QueuedEmail]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RelatedProduct_ProductId1]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_RelatedProduct_ProductId1] ON [dbo].[RelatedProduct]
(
	[ProductId1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Shipment_OrderId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_Shipment_OrderId] ON [dbo].[Shipment]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShoppingCartItem_CustomerId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_ShoppingCartItem_CustomerId] ON [dbo].[ShoppingCartItem]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShoppingCartItem_ShoppingCartTypeId_CustomerId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_ShoppingCartItem_ShoppingCartTypeId_CustomerId] ON [dbo].[ShoppingCartItem]
(
	[ShoppingCartTypeId] ASC,
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StateProvince_CountryId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_StateProvince_CountryId] ON [dbo].[StateProvince]
(
	[CountryId] ASC
)
INCLUDE ( 	[DisplayOrder]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_StoreMapping_EntityId_EntityName]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_StoreMapping_EntityId_EntityName] ON [dbo].[StoreMapping]
(
	[EntityId] ASC,
	[EntityName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TierPrice_ProductId]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_TierPrice_ProductId] ON [dbo].[TierPrice]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UrlRecord_Custom_1]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_UrlRecord_Custom_1] ON [dbo].[UrlRecord]
(
	[EntityId] ASC,
	[EntityName] ASC,
	[LanguageId] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UrlRecord_Slug]    Script Date: 7/4/2019 4:54:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_UrlRecord_Slug] ON [dbo].[UrlRecord]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderItem] ADD  CONSTRAINT [VendorOrderPay]  DEFAULT ((0)) FOR [OrderPay]
GO
ALTER TABLE [dbo].[OrderItem] ADD  CONSTRAINT [PenalitiesDefault]  DEFAULT ((0.0000)) FOR [Penalities]
GO
ALTER TABLE [dbo].[OrderItem] ADD  CONSTRAINT [VendorReturnPay]  DEFAULT ((0)) FOR [ReturnPay]
GO
ALTER TABLE [dbo].[OrderItem] ADD  CONSTRAINT [ItemPriceDefault]  DEFAULT ((0.0000)) FOR [ItemPrice]
GO
ALTER TABLE [dbo].[OrderItem] ADD  CONSTRAINT [ItemCostDefault]  DEFAULT ((0.0000)) FOR [ItemCost]
GO
ALTER TABLE [dbo].[SS_MM_MenuItem] ADD  CONSTRAINT [DF__SS_MM_Men__Subje__257187A8]  DEFAULT ((0)) FOR [SubjectToAcl]
GO
ALTER TABLE [dbo].[Vendor] ADD  CONSTRAINT [VendorPickCont]  DEFAULT ((0.0000)) FOR [PickFee]
GO
ALTER TABLE [dbo].[AclRecord]  WITH NOCHECK ADD  CONSTRAINT [AclRecord_CustomerRole] FOREIGN KEY([CustomerRoleId])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AclRecord] CHECK CONSTRAINT [AclRecord_CustomerRole]
GO
ALTER TABLE [dbo].[ActivityLog]  WITH NOCHECK ADD  CONSTRAINT [ActivityLog_ActivityLogType] FOREIGN KEY([ActivityLogTypeId])
REFERENCES [dbo].[ActivityLogType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ActivityLog] CHECK CONSTRAINT [ActivityLog_ActivityLogType]
GO
ALTER TABLE [dbo].[ActivityLog]  WITH NOCHECK ADD  CONSTRAINT [ActivityLog_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ActivityLog] CHECK CONSTRAINT [ActivityLog_Customer]
GO
ALTER TABLE [dbo].[Address]  WITH NOCHECK ADD  CONSTRAINT [Address_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [Address_Country]
GO
ALTER TABLE [dbo].[Address]  WITH NOCHECK ADD  CONSTRAINT [Address_StateProvince] FOREIGN KEY([StateProvinceId])
REFERENCES [dbo].[StateProvince] ([Id])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [Address_StateProvince]
GO
ALTER TABLE [dbo].[AddressAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [AddressAttributeValue_AddressAttribute] FOREIGN KEY([AddressAttributeId])
REFERENCES [dbo].[AddressAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AddressAttributeValue] CHECK CONSTRAINT [AddressAttributeValue_AddressAttribute]
GO
ALTER TABLE [dbo].[Affiliate]  WITH NOCHECK ADD  CONSTRAINT [Affiliate_Address] FOREIGN KEY([AddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Affiliate] CHECK CONSTRAINT [Affiliate_Address]
GO
ALTER TABLE [dbo].[BackInStockSubscription]  WITH NOCHECK ADD  CONSTRAINT [BackInStockSubscription_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BackInStockSubscription] CHECK CONSTRAINT [BackInStockSubscription_Customer]
GO
ALTER TABLE [dbo].[BackInStockSubscription]  WITH NOCHECK ADD  CONSTRAINT [BackInStockSubscription_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BackInStockSubscription] CHECK CONSTRAINT [BackInStockSubscription_Product]
GO
ALTER TABLE [dbo].[BlogComment]  WITH NOCHECK ADD  CONSTRAINT [BlogComment_BlogPost] FOREIGN KEY([BlogPostId])
REFERENCES [dbo].[BlogPost] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogComment] CHECK CONSTRAINT [BlogComment_BlogPost]
GO
ALTER TABLE [dbo].[BlogComment]  WITH NOCHECK ADD  CONSTRAINT [BlogComment_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogComment] CHECK CONSTRAINT [BlogComment_Customer]
GO
ALTER TABLE [dbo].[BlogComment]  WITH NOCHECK ADD  CONSTRAINT [BlogComment_Store] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogComment] CHECK CONSTRAINT [BlogComment_Store]
GO
ALTER TABLE [dbo].[BlogPost]  WITH NOCHECK ADD  CONSTRAINT [BlogPost_Language] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogPost] CHECK CONSTRAINT [BlogPost_Language]
GO
ALTER TABLE [dbo].[CheckoutAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [CheckoutAttributeValue_CheckoutAttribute] FOREIGN KEY([CheckoutAttributeId])
REFERENCES [dbo].[CheckoutAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CheckoutAttributeValue] CHECK CONSTRAINT [CheckoutAttributeValue_CheckoutAttribute]
GO
ALTER TABLE [dbo].[Customer]  WITH NOCHECK ADD  CONSTRAINT [Customer_BillingAddress] FOREIGN KEY([BillingAddress_Id])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [Customer_BillingAddress]
GO
ALTER TABLE [dbo].[Customer]  WITH NOCHECK ADD  CONSTRAINT [Customer_ShippingAddress] FOREIGN KEY([ShippingAddress_Id])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [Customer_ShippingAddress]
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping]  WITH NOCHECK ADD  CONSTRAINT [Customer_CustomerRoles_Source] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping] CHECK CONSTRAINT [Customer_CustomerRoles_Source]
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping]  WITH NOCHECK ADD  CONSTRAINT [Customer_CustomerRoles_Target] FOREIGN KEY([CustomerRole_Id])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping] CHECK CONSTRAINT [Customer_CustomerRoles_Target]
GO
ALTER TABLE [dbo].[CustomerAddresses]  WITH NOCHECK ADD  CONSTRAINT [Customer_Addresses_Source] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerAddresses] CHECK CONSTRAINT [Customer_Addresses_Source]
GO
ALTER TABLE [dbo].[CustomerAddresses]  WITH NOCHECK ADD  CONSTRAINT [Customer_Addresses_Target] FOREIGN KEY([Address_Id])
REFERENCES [dbo].[Address] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerAddresses] CHECK CONSTRAINT [Customer_Addresses_Target]
GO
ALTER TABLE [dbo].[CustomerAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [CustomerAttributeValue_CustomerAttribute] FOREIGN KEY([CustomerAttributeId])
REFERENCES [dbo].[CustomerAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerAttributeValue] CHECK CONSTRAINT [CustomerAttributeValue_CustomerAttribute]
GO
ALTER TABLE [dbo].[CustomerPassword]  WITH NOCHECK ADD  CONSTRAINT [CustomerPassword_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerPassword] CHECK CONSTRAINT [CustomerPassword_Customer]
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories]  WITH NOCHECK ADD  CONSTRAINT [Discount_AppliedToCategories_Source] FOREIGN KEY([Discount_Id])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories] CHECK CONSTRAINT [Discount_AppliedToCategories_Source]
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories]  WITH NOCHECK ADD  CONSTRAINT [Discount_AppliedToCategories_Target] FOREIGN KEY([Category_Id])
REFERENCES [dbo].[Category] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories] CHECK CONSTRAINT [Discount_AppliedToCategories_Target]
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers]  WITH NOCHECK ADD  CONSTRAINT [Discount_AppliedToManufacturers_Source] FOREIGN KEY([Discount_Id])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers] CHECK CONSTRAINT [Discount_AppliedToManufacturers_Source]
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers]  WITH NOCHECK ADD  CONSTRAINT [Discount_AppliedToManufacturers_Target] FOREIGN KEY([Manufacturer_Id])
REFERENCES [dbo].[Manufacturer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers] CHECK CONSTRAINT [Discount_AppliedToManufacturers_Target]
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts]  WITH NOCHECK ADD  CONSTRAINT [Discount_AppliedToProducts_Source] FOREIGN KEY([Discount_Id])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts] CHECK CONSTRAINT [Discount_AppliedToProducts_Source]
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts]  WITH NOCHECK ADD  CONSTRAINT [Discount_AppliedToProducts_Target] FOREIGN KEY([Product_Id])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts] CHECK CONSTRAINT [Discount_AppliedToProducts_Target]
GO
ALTER TABLE [dbo].[DiscountRequirement]  WITH NOCHECK ADD  CONSTRAINT [Discount_DiscountRequirements] FOREIGN KEY([DiscountId])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiscountRequirement] CHECK CONSTRAINT [Discount_DiscountRequirements]
GO
ALTER TABLE [dbo].[DiscountUsageHistory]  WITH NOCHECK ADD  CONSTRAINT [DiscountUsageHistory_Discount] FOREIGN KEY([DiscountId])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiscountUsageHistory] CHECK CONSTRAINT [DiscountUsageHistory_Discount]
GO
ALTER TABLE [dbo].[DiscountUsageHistory]  WITH NOCHECK ADD  CONSTRAINT [DiscountUsageHistory_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiscountUsageHistory] CHECK CONSTRAINT [DiscountUsageHistory_Order]
GO
ALTER TABLE [dbo].[ExternalAuthenticationRecord]  WITH NOCHECK ADD  CONSTRAINT [ExternalAuthenticationRecord_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ExternalAuthenticationRecord] CHECK CONSTRAINT [ExternalAuthenticationRecord_Customer]
GO
ALTER TABLE [dbo].[Forums_Forum]  WITH NOCHECK ADD  CONSTRAINT [Forum_ForumGroup] FOREIGN KEY([ForumGroupId])
REFERENCES [dbo].[Forums_Group] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_Forum] CHECK CONSTRAINT [Forum_ForumGroup]
GO
ALTER TABLE [dbo].[Forums_Post]  WITH NOCHECK ADD  CONSTRAINT [ForumPost_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_Post] CHECK CONSTRAINT [ForumPost_Customer]
GO
ALTER TABLE [dbo].[Forums_Post]  WITH NOCHECK ADD  CONSTRAINT [ForumPost_ForumTopic] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Forums_Topic] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_Post] CHECK CONSTRAINT [ForumPost_ForumTopic]
GO
ALTER TABLE [dbo].[Forums_PostVote]  WITH NOCHECK ADD  CONSTRAINT [Forums_PostVote_Forums_Post] FOREIGN KEY([ForumPostId])
REFERENCES [dbo].[Forums_Post] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_PostVote] CHECK CONSTRAINT [Forums_PostVote_Forums_Post]
GO
ALTER TABLE [dbo].[Forums_PrivateMessage]  WITH NOCHECK ADD  CONSTRAINT [PrivateMessage_FromCustomer] FOREIGN KEY([FromCustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_PrivateMessage] CHECK CONSTRAINT [PrivateMessage_FromCustomer]
GO
ALTER TABLE [dbo].[Forums_PrivateMessage]  WITH NOCHECK ADD  CONSTRAINT [PrivateMessage_ToCustomer] FOREIGN KEY([ToCustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_PrivateMessage] CHECK CONSTRAINT [PrivateMessage_ToCustomer]
GO
ALTER TABLE [dbo].[Forums_Subscription]  WITH NOCHECK ADD  CONSTRAINT [ForumSubscription_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_Subscription] CHECK CONSTRAINT [ForumSubscription_Customer]
GO
ALTER TABLE [dbo].[Forums_Topic]  WITH NOCHECK ADD  CONSTRAINT [ForumTopic_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_Topic] CHECK CONSTRAINT [ForumTopic_Customer]
GO
ALTER TABLE [dbo].[Forums_Topic]  WITH NOCHECK ADD  CONSTRAINT [ForumTopic_Forum] FOREIGN KEY([ForumId])
REFERENCES [dbo].[Forums_Forum] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_Topic] CHECK CONSTRAINT [ForumTopic_Forum]
GO
ALTER TABLE [dbo].[GiftCard]  WITH NOCHECK ADD  CONSTRAINT [GiftCard_PurchasedWithOrderItem] FOREIGN KEY([PurchasedWithOrderItemId])
REFERENCES [dbo].[OrderItem] ([Id])
GO
ALTER TABLE [dbo].[GiftCard] CHECK CONSTRAINT [GiftCard_PurchasedWithOrderItem]
GO
ALTER TABLE [dbo].[GiftCardUsageHistory]  WITH NOCHECK ADD  CONSTRAINT [GiftCardUsageHistory_GiftCard] FOREIGN KEY([GiftCardId])
REFERENCES [dbo].[GiftCard] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GiftCardUsageHistory] CHECK CONSTRAINT [GiftCardUsageHistory_GiftCard]
GO
ALTER TABLE [dbo].[GiftCardUsageHistory]  WITH NOCHECK ADD  CONSTRAINT [GiftCardUsageHistory_UsedWithOrder] FOREIGN KEY([UsedWithOrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GiftCardUsageHistory] CHECK CONSTRAINT [GiftCardUsageHistory_UsedWithOrder]
GO
ALTER TABLE [dbo].[LocaleStringResource]  WITH NOCHECK ADD  CONSTRAINT [LocaleStringResource_Language] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LocaleStringResource] CHECK CONSTRAINT [LocaleStringResource_Language]
GO
ALTER TABLE [dbo].[LocalizedProperty]  WITH NOCHECK ADD  CONSTRAINT [LocalizedProperty_Language] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LocalizedProperty] CHECK CONSTRAINT [LocalizedProperty_Language]
GO
ALTER TABLE [dbo].[Log]  WITH NOCHECK ADD  CONSTRAINT [Log_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Log] CHECK CONSTRAINT [Log_Customer]
GO
ALTER TABLE [dbo].[News]  WITH NOCHECK ADD  CONSTRAINT [NewsItem_Language] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [NewsItem_Language]
GO
ALTER TABLE [dbo].[NewsComment]  WITH NOCHECK ADD  CONSTRAINT [NewsComment_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsComment] CHECK CONSTRAINT [NewsComment_Customer]
GO
ALTER TABLE [dbo].[NewsComment]  WITH NOCHECK ADD  CONSTRAINT [NewsComment_NewsItem] FOREIGN KEY([NewsItemId])
REFERENCES [dbo].[News] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsComment] CHECK CONSTRAINT [NewsComment_NewsItem]
GO
ALTER TABLE [dbo].[NewsComment]  WITH NOCHECK ADD  CONSTRAINT [NewsComment_Store] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsComment] CHECK CONSTRAINT [NewsComment_Store]
GO
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [Order_BillingAddress] FOREIGN KEY([BillingAddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [Order_BillingAddress]
GO
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [Order_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [Order_Customer]
GO
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [Order_PickupAddress] FOREIGN KEY([PickupAddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [Order_PickupAddress]
GO
ALTER TABLE [dbo].[Order]  WITH NOCHECK ADD  CONSTRAINT [Order_ShippingAddress] FOREIGN KEY([ShippingAddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [Order_ShippingAddress]
GO
ALTER TABLE [dbo].[OrderItem]  WITH NOCHECK ADD  CONSTRAINT [OrderItem_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [OrderItem_Order]
GO
ALTER TABLE [dbo].[OrderItem]  WITH NOCHECK ADD  CONSTRAINT [OrderItem_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [OrderItem_Product]
GO
ALTER TABLE [dbo].[OrderNote]  WITH NOCHECK ADD  CONSTRAINT [OrderNote_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderNote] CHECK CONSTRAINT [OrderNote_Order]
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping]  WITH NOCHECK ADD  CONSTRAINT [PermissionRecord_CustomerRoles_Source] FOREIGN KEY([PermissionRecord_Id])
REFERENCES [dbo].[PermissionRecord] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping] CHECK CONSTRAINT [PermissionRecord_CustomerRoles_Source]
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping]  WITH NOCHECK ADD  CONSTRAINT [PermissionRecord_CustomerRoles_Target] FOREIGN KEY([CustomerRole_Id])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping] CHECK CONSTRAINT [PermissionRecord_CustomerRoles_Target]
GO
ALTER TABLE [dbo].[Poll]  WITH NOCHECK ADD  CONSTRAINT [Poll_Language] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Poll] CHECK CONSTRAINT [Poll_Language]
GO
ALTER TABLE [dbo].[PollAnswer]  WITH NOCHECK ADD  CONSTRAINT [PollAnswer_Poll] FOREIGN KEY([PollId])
REFERENCES [dbo].[Poll] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PollAnswer] CHECK CONSTRAINT [PollAnswer_Poll]
GO
ALTER TABLE [dbo].[PollVotingRecord]  WITH NOCHECK ADD  CONSTRAINT [PollVotingRecord_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PollVotingRecord] CHECK CONSTRAINT [PollVotingRecord_Customer]
GO
ALTER TABLE [dbo].[PollVotingRecord]  WITH NOCHECK ADD  CONSTRAINT [PollVotingRecord_PollAnswer] FOREIGN KEY([PollAnswerId])
REFERENCES [dbo].[PollAnswer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PollVotingRecord] CHECK CONSTRAINT [PollVotingRecord_PollAnswer]
GO
ALTER TABLE [dbo].[PredefinedProductAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [PredefinedProductAttributeValue_ProductAttribute] FOREIGN KEY([ProductAttributeId])
REFERENCES [dbo].[ProductAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PredefinedProductAttributeValue] CHECK CONSTRAINT [PredefinedProductAttributeValue_ProductAttribute]
GO
ALTER TABLE [dbo].[Product_Category_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductCategory_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Category_Mapping] CHECK CONSTRAINT [ProductCategory_Category]
GO
ALTER TABLE [dbo].[Product_Category_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductCategory_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Category_Mapping] CHECK CONSTRAINT [ProductCategory_Product]
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductManufacturer_Manufacturer] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[Manufacturer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping] CHECK CONSTRAINT [ProductManufacturer_Manufacturer]
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductManufacturer_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping] CHECK CONSTRAINT [ProductManufacturer_Product]
GO
ALTER TABLE [dbo].[Product_Picture_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductPicture_Picture] FOREIGN KEY([PictureId])
REFERENCES [dbo].[Picture] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Picture_Mapping] CHECK CONSTRAINT [ProductPicture_Picture]
GO
ALTER TABLE [dbo].[Product_Picture_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductPicture_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Picture_Mapping] CHECK CONSTRAINT [ProductPicture_Product]
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductAttributeMapping_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping] CHECK CONSTRAINT [ProductAttributeMapping_Product]
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductAttributeMapping_ProductAttribute] FOREIGN KEY([ProductAttributeId])
REFERENCES [dbo].[ProductAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping] CHECK CONSTRAINT [ProductAttributeMapping_ProductAttribute]
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping]  WITH NOCHECK ADD  CONSTRAINT [Product_ProductTags_Source] FOREIGN KEY([Product_Id])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping] CHECK CONSTRAINT [Product_ProductTags_Source]
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping]  WITH NOCHECK ADD  CONSTRAINT [Product_ProductTags_Target] FOREIGN KEY([ProductTag_Id])
REFERENCES [dbo].[ProductTag] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping] CHECK CONSTRAINT [Product_ProductTags_Target]
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductSpecificationAttribute_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping] CHECK CONSTRAINT [ProductSpecificationAttribute_Product]
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping]  WITH NOCHECK ADD  CONSTRAINT [ProductSpecificationAttribute_SpecificationAttributeOption] FOREIGN KEY([SpecificationAttributeOptionId])
REFERENCES [dbo].[SpecificationAttributeOption] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping] CHECK CONSTRAINT [ProductSpecificationAttribute_SpecificationAttributeOption]
GO
ALTER TABLE [dbo].[ProductAttributeCombination]  WITH NOCHECK ADD  CONSTRAINT [ProductAttributeCombination_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductAttributeCombination] CHECK CONSTRAINT [ProductAttributeCombination_Product]
GO
ALTER TABLE [dbo].[ProductAttributeValue]  WITH NOCHECK ADD  CONSTRAINT [ProductAttributeValue_ProductAttributeMapping] FOREIGN KEY([ProductAttributeMappingId])
REFERENCES [dbo].[Product_ProductAttribute_Mapping] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductAttributeValue] CHECK CONSTRAINT [ProductAttributeValue_ProductAttributeMapping]
GO
ALTER TABLE [dbo].[ProductReview]  WITH NOCHECK ADD  CONSTRAINT [ProductReview_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [ProductReview_Customer]
GO
ALTER TABLE [dbo].[ProductReview]  WITH NOCHECK ADD  CONSTRAINT [ProductReview_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [ProductReview_Product]
GO
ALTER TABLE [dbo].[ProductReview]  WITH NOCHECK ADD  CONSTRAINT [ProductReview_Store] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [ProductReview_Store]
GO
ALTER TABLE [dbo].[ProductReviewHelpfulness]  WITH NOCHECK ADD  CONSTRAINT [ProductReviewHelpfulness_ProductReview] FOREIGN KEY([ProductReviewId])
REFERENCES [dbo].[ProductReview] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReviewHelpfulness] CHECK CONSTRAINT [ProductReviewHelpfulness_ProductReview]
GO
ALTER TABLE [dbo].[ProductWarehouseInventory]  WITH NOCHECK ADD  CONSTRAINT [ProductWarehouseInventory_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductWarehouseInventory] CHECK CONSTRAINT [ProductWarehouseInventory_Product]
GO
ALTER TABLE [dbo].[ProductWarehouseInventory]  WITH NOCHECK ADD  CONSTRAINT [ProductWarehouseInventory_Warehouse] FOREIGN KEY([WarehouseId])
REFERENCES [dbo].[Warehouse] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductWarehouseInventory] CHECK CONSTRAINT [ProductWarehouseInventory_Warehouse]
GO
ALTER TABLE [dbo].[QueuedEmail]  WITH NOCHECK ADD  CONSTRAINT [QueuedEmail_EmailAccount] FOREIGN KEY([EmailAccountId])
REFERENCES [dbo].[EmailAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[QueuedEmail] CHECK CONSTRAINT [QueuedEmail_EmailAccount]
GO
ALTER TABLE [dbo].[RecurringPayment]  WITH NOCHECK ADD  CONSTRAINT [RecurringPayment_InitialOrder] FOREIGN KEY([InitialOrderId])
REFERENCES [dbo].[Order] ([Id])
GO
ALTER TABLE [dbo].[RecurringPayment] CHECK CONSTRAINT [RecurringPayment_InitialOrder]
GO
ALTER TABLE [dbo].[RecurringPaymentHistory]  WITH NOCHECK ADD  CONSTRAINT [RecurringPaymentHistory_RecurringPayment] FOREIGN KEY([RecurringPaymentId])
REFERENCES [dbo].[RecurringPayment] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RecurringPaymentHistory] CHECK CONSTRAINT [RecurringPaymentHistory_RecurringPayment]
GO
ALTER TABLE [dbo].[ReturnRequest]  WITH NOCHECK ADD  CONSTRAINT [ReturnRequest_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReturnRequest] CHECK CONSTRAINT [ReturnRequest_Customer]
GO
ALTER TABLE [dbo].[RewardPointsHistory]  WITH NOCHECK ADD  CONSTRAINT [RewardPointsHistory_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RewardPointsHistory] CHECK CONSTRAINT [RewardPointsHistory_Customer]
GO
ALTER TABLE [dbo].[RewardPointsHistory]  WITH NOCHECK ADD  CONSTRAINT [RewardPointsHistory_UsedWithOrder] FOREIGN KEY([UsedWithOrder_Id])
REFERENCES [dbo].[Order] ([Id])
GO
ALTER TABLE [dbo].[RewardPointsHistory] CHECK CONSTRAINT [RewardPointsHistory_UsedWithOrder]
GO
ALTER TABLE [dbo].[Shipment]  WITH NOCHECK ADD  CONSTRAINT [Shipment_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Shipment] CHECK CONSTRAINT [Shipment_Order]
GO
ALTER TABLE [dbo].[ShipmentItem]  WITH NOCHECK ADD  CONSTRAINT [ShipmentItem_Shipment] FOREIGN KEY([ShipmentId])
REFERENCES [dbo].[Shipment] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShipmentItem] CHECK CONSTRAINT [ShipmentItem_Shipment]
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions]  WITH NOCHECK ADD  CONSTRAINT [ShippingMethod_RestrictedCountries_Source] FOREIGN KEY([ShippingMethod_Id])
REFERENCES [dbo].[ShippingMethod] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions] CHECK CONSTRAINT [ShippingMethod_RestrictedCountries_Source]
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions]  WITH NOCHECK ADD  CONSTRAINT [ShippingMethod_RestrictedCountries_Target] FOREIGN KEY([Country_Id])
REFERENCES [dbo].[Country] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions] CHECK CONSTRAINT [ShippingMethod_RestrictedCountries_Target]
GO
ALTER TABLE [dbo].[ShoppingCartItem]  WITH NOCHECK ADD  CONSTRAINT [ShoppingCartItem_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShoppingCartItem] CHECK CONSTRAINT [ShoppingCartItem_Customer]
GO
ALTER TABLE [dbo].[ShoppingCartItem]  WITH NOCHECK ADD  CONSTRAINT [ShoppingCartItem_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShoppingCartItem] CHECK CONSTRAINT [ShoppingCartItem_Product]
GO
ALTER TABLE [dbo].[SpecificationAttributeOption]  WITH NOCHECK ADD  CONSTRAINT [SpecificationAttributeOption_SpecificationAttribute] FOREIGN KEY([SpecificationAttributeId])
REFERENCES [dbo].[SpecificationAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpecificationAttributeOption] CHECK CONSTRAINT [SpecificationAttributeOption_SpecificationAttribute]
GO
ALTER TABLE [dbo].[SS_AS_SliderImage]  WITH NOCHECK ADD  CONSTRAINT [SliderImage_Slider] FOREIGN KEY([SliderId])
REFERENCES [dbo].[SS_AS_AnywhereSlider] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_AS_SliderImage] CHECK CONSTRAINT [SliderImage_Slider]
GO
ALTER TABLE [dbo].[SS_C_ConditionGroup]  WITH NOCHECK ADD  CONSTRAINT [ConditionGroup_ConditionEntity] FOREIGN KEY([ConditionId])
REFERENCES [dbo].[SS_C_Condition] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_C_ConditionGroup] CHECK CONSTRAINT [ConditionGroup_ConditionEntity]
GO
ALTER TABLE [dbo].[SS_C_ConditionStatement]  WITH NOCHECK ADD  CONSTRAINT [ConditionStatement_ConditionGroupEntity] FOREIGN KEY([ConditionGroupId])
REFERENCES [dbo].[SS_C_ConditionGroup] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_C_ConditionStatement] CHECK CONSTRAINT [ConditionStatement_ConditionGroupEntity]
GO
ALTER TABLE [dbo].[SS_C_CustomerOverride]  WITH NOCHECK ADD  CONSTRAINT [CustomerOverride_ConditionEntity] FOREIGN KEY([ConditionId])
REFERENCES [dbo].[SS_C_Condition] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_C_CustomerOverride] CHECK CONSTRAINT [CustomerOverride_ConditionEntity]
GO
ALTER TABLE [dbo].[SS_C_EntityCondition]  WITH NOCHECK ADD  CONSTRAINT [EntityCondition_ConditionEntity] FOREIGN KEY([ConditionId])
REFERENCES [dbo].[SS_C_Condition] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_C_EntityCondition] CHECK CONSTRAINT [EntityCondition_ConditionEntity]
GO
ALTER TABLE [dbo].[SS_C_ProductOverride]  WITH NOCHECK ADD  CONSTRAINT [ProductOverride_ConditionEntity] FOREIGN KEY([ConditionId])
REFERENCES [dbo].[SS_C_Condition] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_C_ProductOverride] CHECK CONSTRAINT [ProductOverride_ConditionEntity]
GO
ALTER TABLE [dbo].[SS_PR_CategoryPageRibbon]  WITH NOCHECK ADD  CONSTRAINT [CategoryPageRibbon_ProductRibbon] FOREIGN KEY([ProductRibbonId])
REFERENCES [dbo].[SS_PR_ProductRibbon] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_PR_CategoryPageRibbon] CHECK CONSTRAINT [CategoryPageRibbon_ProductRibbon]
GO
ALTER TABLE [dbo].[SS_PR_CategoryPageRibbon]  WITH NOCHECK ADD  CONSTRAINT [CategoryPageRibbon_RibbonPicture] FOREIGN KEY([PictureId])
REFERENCES [dbo].[SS_PR_RibbonPicture] ([Id])
GO
ALTER TABLE [dbo].[SS_PR_CategoryPageRibbon] CHECK CONSTRAINT [CategoryPageRibbon_RibbonPicture]
GO
ALTER TABLE [dbo].[SS_PR_ProductPageRibbon]  WITH NOCHECK ADD  CONSTRAINT [ProductPageRibbon_ProductRibbon] FOREIGN KEY([ProductRibbonId])
REFERENCES [dbo].[SS_PR_ProductRibbon] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_PR_ProductPageRibbon] CHECK CONSTRAINT [ProductPageRibbon_ProductRibbon]
GO
ALTER TABLE [dbo].[SS_PR_ProductPageRibbon]  WITH NOCHECK ADD  CONSTRAINT [ProductPageRibbon_RibbonPicture] FOREIGN KEY([PictureId])
REFERENCES [dbo].[SS_PR_RibbonPicture] ([Id])
GO
ALTER TABLE [dbo].[SS_PR_ProductPageRibbon] CHECK CONSTRAINT [ProductPageRibbon_RibbonPicture]
GO
ALTER TABLE [dbo].[SS_SPC_ProductsGroupItem]  WITH NOCHECK ADD  CONSTRAINT [ProductsGroupItem_Group] FOREIGN KEY([GroupId])
REFERENCES [dbo].[SS_SPC_ProductsGroup] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SS_SPC_ProductsGroupItem] CHECK CONSTRAINT [ProductsGroupItem_Group]
GO
ALTER TABLE [dbo].[StateProvince]  WITH NOCHECK ADD  CONSTRAINT [StateProvince_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StateProvince] CHECK CONSTRAINT [StateProvince_Country]
GO
ALTER TABLE [dbo].[StockQuantityHistory]  WITH NOCHECK ADD  CONSTRAINT [StockQuantityHistory_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StockQuantityHistory] CHECK CONSTRAINT [StockQuantityHistory_Product]
GO
ALTER TABLE [dbo].[StoreMapping]  WITH NOCHECK ADD  CONSTRAINT [StoreMapping_Store] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StoreMapping] CHECK CONSTRAINT [StoreMapping_Store]
GO
ALTER TABLE [dbo].[TierPrice]  WITH NOCHECK ADD  CONSTRAINT [TierPrice_CustomerRole] FOREIGN KEY([CustomerRoleId])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TierPrice] CHECK CONSTRAINT [TierPrice_CustomerRole]
GO
ALTER TABLE [dbo].[TierPrice]  WITH NOCHECK ADD  CONSTRAINT [TierPrice_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TierPrice] CHECK CONSTRAINT [TierPrice_Product]
GO
ALTER TABLE [dbo].[VendorNote]  WITH NOCHECK ADD  CONSTRAINT [VendorNote_Vendor] FOREIGN KEY([VendorId])
REFERENCES [dbo].[Vendor] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendorNote] CHECK CONSTRAINT [VendorNote_Vendor]
GO
/****** Object:  StoredProcedure [dbo].[AddingAdrressAcount]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddingAdrressAcount]
	-- Add the parameters for the stored procedure here
	@CustomerId int,
	@Address_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT [dbo].[CustomerAddresses] ([Customer_Id], [Address_Id]) VALUES (@CustomerId ,@Address_Id) 
                        UPDATE customer set [BillingAddress_Id] =  @Address_Id  ,[ShippingAddress_Id] = @Address_Id   where customer.id = @CustomerId
END



GO
/****** Object:  StoredProcedure [dbo].[CartTest]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[CartTest]
	-- Add the parameters for the stored procedure here
	 
	 @arrayKeys varchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
    -- Insert statements for procedure here
	SELECT  npr.Id Id, npr.Name Name  ,npr.ShortDescription , npr.FullDescription , npr.Price ,npr.ProductCost as Cost , npr.OldPrice , npr.StockQuantity , npr.Weight , max ('https://www.dubazzar.com/Images/Thumbs/' + 
             RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' )as 'ImagePath' 
           FROM Product npr
             Left JOIN Product_Picture_Mapping npp ON (npr.Id = npp.ProductId) 
           Left JOIN Picture npi ON (npp.PictureID = npi.ID) 
           Left Join Product_Category_Mapping PCM on PCM.ProductId =  npp.ProductId
           left join Category C on C.Id = PCM.CategoryId 
            WHERE  npp.ProductId  IN  (Select RetVal from [dbo].[udf-Str-Parse](@arrayKeys,',')) group by npr.Name  , npr.Id , npr.ShortDescription , npr.FullDescription , npr.Price , npr.OldPrice , npr.ProductCost, npr.StockQuantity  , npr.Weight
END






GO
/****** Object:  StoredProcedure [dbo].[CategoryLoadAllPaged]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CategoryLoadAllPaged]
(
    @ShowHidden         BIT = 0,
    @Name               NVARCHAR(MAX) = NULL,
    @StoreId            INT = 0,
    @CustomerRoleIds	NVARCHAR(MAX) = NULL,
    @PageIndex			INT = 0,
	@PageSize			INT = 2147483644,
    @TotalRecords		INT = NULL OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

    --filter by customer role IDs (access control list)
	SET @CustomerRoleIds = ISNULL(@CustomerRoleIds, '')
	CREATE TABLE #FilteredCustomerRoleIds
	(
		CustomerRoleId INT NOT NULL
	)
	INSERT INTO #FilteredCustomerRoleIds (CustomerRoleId)
	SELECT CAST(data AS INT) FROM [nop_splitstring_to_table](@CustomerRoleIds, ',')
	DECLARE @FilteredCustomerRoleIdsCount INT = (SELECT COUNT(1) FROM #FilteredCustomerRoleIds)

    --ordered categories
    CREATE TABLE #OrderedCategoryIds
	(
		[Id] int IDENTITY (1, 1) NOT NULL,
		[CategoryId] int NOT NULL
	)
    
    --get max length of DisplayOrder and Id columns (used for padding Order column)
    DECLARE @lengthId INT = (SELECT LEN(MAX(Id)) FROM [Category])
    DECLARE @lengthOrder INT = (SELECT LEN(MAX(DisplayOrder)) FROM [Category])

    --get category tree
    ;WITH [CategoryTree]
    AS (SELECT [Category].[Id] AS [Id], dbo.[nop_padright] ([Category].[DisplayOrder], '0', @lengthOrder) + '-' + dbo.[nop_padright] ([Category].[Id], '0', @lengthId) AS [Order]
        FROM [Category] WHERE [Category].[ParentCategoryId] = 0
        UNION ALL
        SELECT [Category].[Id] AS [Id], [CategoryTree].[Order] + '|' + dbo.[nop_padright] ([Category].[DisplayOrder], '0', @lengthOrder) + '-' + dbo.[nop_padright] ([Category].[Id], '0', @lengthId) AS [Order]
        FROM [Category]
        INNER JOIN [CategoryTree] ON [CategoryTree].[Id] = [Category].[ParentCategoryId])
    INSERT INTO #OrderedCategoryIds ([CategoryId])
    SELECT [Category].[Id]
    FROM [CategoryTree]
    RIGHT JOIN [Category] ON [CategoryTree].[Id] = [Category].[Id]

    --filter results
    WHERE [Category].[Deleted] = 0
    AND (@ShowHidden = 1 OR [Category].[Published] = 1)
    AND (@Name IS NULL OR @Name = '' OR [Category].[Name] LIKE ('%' + @Name + '%'))
    AND (@ShowHidden = 1 OR @FilteredCustomerRoleIdsCount  = 0 OR [Category].[SubjectToAcl] = 0
        OR EXISTS (SELECT 1 FROM #FilteredCustomerRoleIds [roles] WHERE [roles].[CustomerRoleId] IN
            (SELECT [acl].[CustomerRoleId] FROM [AclRecord] acl WITH (NOLOCK) WHERE [acl].[EntityId] = [Category].[Id] AND [acl].[EntityName] = 'Category')
        )
    )
    AND (@StoreId = 0 OR [Category].[LimitedToStores] = 0
        OR EXISTS (SELECT 1 FROM [StoreMapping] sm WITH (NOLOCK)
			WHERE [sm].[EntityId] = [Category].[Id] AND [sm].[EntityName] = 'Category' AND [sm].[StoreId] = @StoreId
		)
    )
    ORDER BY ISNULL([CategoryTree].[Order], 1)

    --total records
    SET @TotalRecords = @@ROWCOUNT

    --paging
    SELECT [Category].* FROM #OrderedCategoryIds AS [Result] INNER JOIN [Category] ON [Result].[CategoryId] = [Category].[Id]
    WHERE ([Result].[Id] > @PageSize * @PageIndex AND [Result].[Id] <= @PageSize * (@PageIndex + 1))
    ORDER BY [Result].[Id]

    DROP TABLE #FilteredCustomerRoleIds
    DROP TABLE #OrderedCategoryIds
END

GO
/****** Object:  StoredProcedure [dbo].[checkOutProccessXML]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[checkOutProccessXML] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT AdditionalFixedCost FROM [dbo].[ShippingByWeight] where CountryId= 238 and stateProvinceId=0
END



GO
/****** Object:  StoredProcedure [dbo].[DeleteGuests]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteGuests]
(
	@OnlyWithoutShoppingCart bit = 1,
	@CreatedFromUtc datetime,
	@CreatedToUtc datetime,
	@TotalRecordsDeleted int = null OUTPUT
)
AS
BEGIN
	CREATE TABLE #tmp_guests (CustomerId int)
		
	INSERT #tmp_guests (CustomerId)
	SELECT [Id] FROM [Customer] c with (NOLOCK)
	WHERE
	--created from
	((@CreatedFromUtc is null) OR (c.[CreatedOnUtc] > @CreatedFromUtc))
	AND
	--created to
	((@CreatedToUtc is null) OR (c.[CreatedOnUtc] < @CreatedToUtc))
	AND
	--shopping cart items
	((@OnlyWithoutShoppingCart=0) OR (NOT EXISTS(SELECT 1 FROM [ShoppingCartItem] sci with (NOLOCK) inner join [Customer] with (NOLOCK) on sci.[CustomerId]=c.[Id])))
	AND
	--guests only
	(EXISTS(SELECT 1 FROM [Customer_CustomerRole_Mapping] ccrm with (NOLOCK) inner join [Customer] with (NOLOCK) on ccrm.[Customer_Id]=c.[Id] inner join [CustomerRole] cr with (NOLOCK) on cr.[Id]=ccrm.[CustomerRole_Id] WHERE cr.[SystemName] = N'Guests'))
	AND
	--no orders
	(NOT EXISTS(SELECT 1 FROM [Order] o with (NOLOCK) inner join [Customer] with (NOLOCK) on o.[CustomerId]=c.[Id]))
	AND
	--no blog comments
	(NOT EXISTS(SELECT 1 FROM [BlogComment] bc with (NOLOCK) inner join [Customer] with (NOLOCK) on bc.[CustomerId]=c.[Id]))
	AND
	--no news comments
	(NOT EXISTS(SELECT 1 FROM [NewsComment] nc  with (NOLOCK)inner join [Customer] with (NOLOCK) on nc.[CustomerId]=c.[Id]))
	AND
	--no product reviews
	(NOT EXISTS(SELECT 1 FROM [ProductReview] pr with (NOLOCK) inner join [Customer] with (NOLOCK) on pr.[CustomerId]=c.[Id]))
	AND
	--no product reviews helpfulness
	(NOT EXISTS(SELECT 1 FROM [ProductReviewHelpfulness] prh with (NOLOCK) inner join [Customer] with (NOLOCK) on prh.[CustomerId]=c.[Id]))
	AND
	--no poll voting
	(NOT EXISTS(SELECT 1 FROM [PollVotingRecord] pvr with (NOLOCK) inner join [Customer] with (NOLOCK) on pvr.[CustomerId]=c.[Id]))
	AND
	--no forum topics 
	(NOT EXISTS(SELECT 1 FROM [Forums_Topic] ft with (NOLOCK) inner join [Customer] with (NOLOCK) on ft.[CustomerId]=c.[Id]))
	AND
	--no forum posts 
	(NOT EXISTS(SELECT 1 FROM [Forums_Post] fp with (NOLOCK) inner join [Customer] with (NOLOCK) on fp.[CustomerId]=c.[Id]))
	AND
	--no system accounts
	(c.IsSystemAccount = 0)
	
	--delete guests
	DELETE [Customer]
	WHERE [Id] IN (SELECT [CustomerId] FROM #tmp_guests)
	
	--delete attributes
	DELETE [GenericAttribute]
	WHERE ([EntityId] IN (SELECT [CustomerId] FROM #tmp_guests))
	AND
	([KeyGroup] = N'Customer')
	
	--total records
	SELECT @TotalRecordsDeleted = COUNT(1) FROM #tmp_guests
	
	DROP TABLE #tmp_guests
END

GO
/****** Object:  StoredProcedure [dbo].[DiSPLAYSUBCATEGORY]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DiSPLAYSUBCATEGORY]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH categorycte AS (SELECT Id,  Name ,  ParentCategoryId,  0 AS Level,    CAST(Name AS nvarchar(max)) AS treepath 
                    FROM Category  WHERE ParentCategoryId =0  UNION ALL  SELECT d.Id, d.Name , 
                   d.ParentCategoryId, 
                      categorycte.Level+ 1,  
                      categorycte.treepath + ',' + CAST(d.Name AS nvarchar(1024))  FROM Category d  JOIN categorycte  
                           ON (categorycte.Id = d.ParentCategoryId ) ) SELECT * FROM categorycte 
                              where categorycte.ParentCategoryId in ( 153 ,154,783,848) 
END



GO
/****** Object:  StoredProcedure [dbo].[FullText_Disable]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FullText_Disable]
AS
BEGIN
	EXEC('
	--drop indexes
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[Product]''))
		DROP FULLTEXT INDEX ON [Product]
	')

	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[LocalizedProperty]''))
		DROP FULLTEXT INDEX ON [LocalizedProperty]
	')

	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[ProductTag]''))
		DROP FULLTEXT INDEX ON [ProductTag]
	')

	--drop catalog
	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE [name] = ''nopCommerceFullTextCatalog'')
		DROP FULLTEXT CATALOG [nopCommerceFullTextCatalog]
	')
END

GO
/****** Object:  StoredProcedure [dbo].[FullText_Enable]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FullText_Enable]
AS
BEGIN
	--create catalog
	EXEC('
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE [name] = ''nopCommerceFullTextCatalog'')
		CREATE FULLTEXT CATALOG [nopCommerceFullTextCatalog] AS DEFAULT')
	
	--create indexes
	DECLARE @create_index_text nvarchar(4000)
	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[Product]''))
		CREATE FULLTEXT INDEX ON [Product]([Name], [ShortDescription], [FullDescription])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('Product') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)
	
	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[LocalizedProperty]''))
		CREATE FULLTEXT INDEX ON [LocalizedProperty]([LocaleValue])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('LocalizedProperty') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)

	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[ProductTag]''))
		CREATE FULLTEXT INDEX ON [ProductTag]([Name])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('ProductTag') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)
END

GO
/****** Object:  StoredProcedure [dbo].[FullText_IsSupported]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FullText_IsSupported]
AS
BEGIN	
	EXEC('
	SELECT CASE SERVERPROPERTY(''IsFullTextInstalled'')
	WHEN 1 THEN 
		CASE DatabaseProperty (DB_NAME(DB_ID()), ''IsFulltextEnabled'')
		WHEN 1 THEN 1
		ELSE 0
		END
	ELSE 0
	END')
END

GO
/****** Object:  StoredProcedure [dbo].[GetBestSell]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBestSell] 
	-- Add the parameters for the stored procedure here
	@lastid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH AllSubCat AS (   SELECT Id  FROM Category  UNION ALL  SELECT c.Id 
           FROM Category c INNER JOIN AllSubCat a  ON c.ParentCategoryId = a.Id) 
           select  top 10 
            max( 'https://www.dubazzar.com/Images/Thumbs/'+  
            RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' ) 
             as 'ImagePath' ,           
             p.Price,p.Name as Name , c.Id CategoryId ,c.Name CategoryName ,p.Id Id from Product p 
            left join [Product_Category_Mapping] pcm on pcm.ProductId = p.Id 
            left join Category c on c.Id = pcm.CategoryId 
            join Product_Picture_Mapping npp ON (p.Id = npp.ProductId)  
           JOIN Picture npi ON (npp.PictureID = npi.ID) 
            where  pcm. [CategoryId] in 
            ( SELECT * FROM AllSubCat Union  SELECT Id FROM Category ) 
             and p.Id > @LastId  
             group by  p.Price , p.Name  , c.Id  ,c.Name  ,p.Id
END



GO
/****** Object:  StoredProcedure [dbo].[GetBrandX]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBrandX]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  top 11 'https://www.dubazzar.com/Images/Thumbs/' + 
        RIGHT('000000' + CONVERT(NVARCHAR(32),pic.ID),7) + '_' + SeoFilename + '.jpeg' as 'ImagePath',m.[Name] as BrandName ,m.Id as Id
       FROM [Manufacturer] m 
       join picture pic  on (pic.ID = m.PictureId) where m.published = 'true'  order by DisplayOrder ASC
END



GO
/****** Object:  StoredProcedure [dbo].[getOrderById]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getOrderById] 
	-- Add the parameters for the stored procedure here
	@orderId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select  * from OrderItem where OrderId=@orderId
END



GO
/****** Object:  StoredProcedure [dbo].[GetProductAttributeById]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductAttributeById]
	-- Add the parameters for the stored procedure here
	@ProductId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  npr.Name , npr.ShortDescription , npr.FullDescription , npr.Price , npr.OldPrice  , npr.ProductCost as Cost, npr.StockQuantity ,
               pa.Id as   ProductAttributeID , pa.Name as ProductAttributeName , ppm.Id as MappingId ,  ppv.Id as AttrID , ppm.TextPrompt as AttrTextPrompt , ppv.Quantity as AttrQty  ,ppv.Name as AttrName  FROM Product npr
                JOIN  [Product_ProductAttribute_Mapping] ppm on npr.id = ppm.productID 
                  JOIN  [dbo].[ProductAttribute] pa on (pa.id = ppm.[ProductAttributeId])
                  JOIN  [ProductAttributeValue] ppv on ppv.ProductAttributeMappingId  = ppm.Id
END



GO
/****** Object:  StoredProcedure [dbo].[GetProductByBrandId]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[GetProductByBrandId]
	-- Add the parameters for the stored procedure here
	@BrandId int,
	@LastId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 20  max( 'https://www.dubazzar.com/Images/Thumbs/'+ 
         RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' ) as 'ImagePath' , 
           p.Price ,p.Name as Name ,p.ProductCost as Cost  , p.Weight as Weight, p.ShortDescription ,p.FullDescription ,p.OldPrice ,p.StockQuantity ,m.Id CategoryId ,m.Name CategoryName , p.Id Id 
          from Product p 
         left join Product_Picture_Mapping npp ON (p.Id = npp.ProductId) 
         left JOIN Picture npi ON (npp.PictureID = npi.ID) 
       left join [dbo].[Product_Manufacturer_Mapping] pfm on (p.Id =pfm.ProductId) 
        join [dbo].[Manufacturer] m on (m.Id =pfm.ManufacturerId)  where m.Id = @BrandId and p.Id > @LastId
       
         group by   p.Price ,p.Name ,p.ProductCost  , p.Weight , p.ShortDescription ,p.FullDescription ,p.OldPrice ,p.StockQuantity  ,m.Id , m.Name , p.Id 
END



GO
/****** Object:  StoredProcedure [dbo].[GetProductByCategory]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProductByCategory]
	-- Add the parameters for the stored procedure here
	@CategoryId INT,
	 @LastId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH AllSubCat AS (   SELECT Id  FROM Category  WHERE ParentCategoryId = @CategoryId UNION ALL  SELECT c.Id 
            FROM Category c INNER JOIN AllSubCat a  ON c.ParentCategoryId = a.Id) 
            select  top 4 
            Replace((max( 'https://www.dubazzar.com/Images/Thumbs/'+  
            RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename  + '.' + MimeType )) ,'image/','' ) as 'ImagePath',          
             p.Price,p.Name as Name ,p.ProductCost as Cost  , p.Weight as Weight, p.Id as  ShortDescription ,p.Id as FullDescription ,p.OldPrice ,p.StockQuantity ,c.Id CategoryId ,c.Name CategoryName ,p.Id Id from Product p 
            left join [Product_Category_Mapping] pcm on pcm.ProductId = p.Id 
            left join Category c on c.Id = pcm.CategoryId 
            join Product_Picture_Mapping npp ON (p.Id = npp.ProductId)  
            JOIN Picture npi ON (npp.PictureID = npi.ID) 
           where  pcm. [CategoryId] in 
            ( SELECT * FROM AllSubCat Union  SELECT Id FROM Category WHERE Id = @CategoryId) 
             and p.Id > @LastId  
             group by  p.Price , p.Name  ,p.ProductCost   , p.Weight , p.OldPrice ,p.StockQuantity ,c.Id  ,c.Name  ,p.Id 
END



GO
/****** Object:  StoredProcedure [dbo].[getProductByCatHome]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getProductByCatHome]
	-- Add the parameters for the stored procedure here
	@arrayKeys VARCHAR(MAX),
	@id int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH AllSubCat AS( 
            SELECT  Id  FROM Category  WHERE ParentCategoryId  IN ( ( Select RetVal from [dbo].[udf-Str-Parse](@arrayKeys,',') ))
		    UNION ALL  SELECT  c.Id 
           FROM Category c INNER JOIN AllSubCat a  ON c.ParentCategoryId = a.Id) 
		     select * from( 
		     select    max( 'https://www.dubazzar.com/Images/Thumbs/' 
		     +RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' )  as 'ImagePath' ,          
             p.Price,p.Name as Name   , c.Id CategoryId ,c.Name CategoryName ,p.Id Id ,
			 ROW_NUMBER() OVER(PARTITION BY pcm. [CategoryId] ORDER BY p.Id  DESC)  RN  from Product p 
             left join [Product_Category_Mapping] pcm on pcm.ProductId = p.Id 
             left join Category c on c.Id = pcm.CategoryId 
             join Product_Picture_Mapping npp ON (p.Id = npp.ProductId)  
            JOIN Picture npi ON (npp.PictureID = npi.ID) where 
			  pcm. [CategoryId] in 
            (SELECT * FROM AllSubCat Union  SELECT  Id FROM Category WHERE Id IN ( 1,2)) 
            group by  p.Price , p.Name ,c.Id  ,c.Name  ,p.Id 	,pcm. [CategoryId] )s where CategoryId=@id
END

GO
/****** Object:  StoredProcedure [dbo].[getProductByCatHomeTEST]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getProductByCatHomeTEST]
	-- Add the parameters for the stored procedure here
	@LastId int ,
	@arrayKeys VARCHAR(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 10 @LastId+
                max( 'https://www.dubazzar.com/Images/Thumbs/'+ 
                RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' ) 
                as 'ImagePath' , 
               p.Price,p.Name as Name  , c.Id CategoryId ,c.Name CategoryName ,p.Id Id from Product p 
                left join [Product_Category_Mapping] pcm on pcm.ProductId = p.Id 
                 left join Category c on c.Id = pcm.CategoryId 
                  join Product_Picture_Mapping npp ON (p.Id = npp.ProductId) 
                  join Picture npi ON (npp.PictureID = npi.ID) 
                where  pcm. [CategoryId] in ( Select RetVal from [dbo].[udf-Str-Parse](@arrayKeys,','))
                 group by   p.Price,p.Name , c.Id ,c.Name ,p.Id  order by p.Id
END



GO
/****** Object:  StoredProcedure [dbo].[GetProductwithCategoryID]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE  [dbo].[GetProductwithCategoryID] 
@id int
AS
BEGIN
select  'https://www.dubazzar.com/Images/Thumbs/' + 
              RIGHT('0000000' + CONVERT(NVARCHAR(32),picture.ID),7) + '_' + picture.SeoFilename + '.jpeg' as 'ImagePath',pcm.ProductId as ProductId,pcm.CategoryId,p.Name as ProductName,
			  p.FullDescription as productFullDescription,p.ShortDescription as productShortDescription,p.Price as productprice,p.OldPrice as oldprice
			  ,[dbo].[Category].Name as categoryname
             from product p
left join [dbo].[Product_Category_Mapping] pcm on p.id= pcm.productId
left join category on category.id=pcm.categoryId
left join [dbo].[Product_Picture_Mapping] ppm on ppm.productId=p.id
left join picture on picture.id=ppm.pictureId
where categoryId=@id
END



GO
/****** Object:  StoredProcedure [dbo].[insertnewcustomer]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insertnewcustomer] 
	-- Add the parameters for the stored procedure here
	@email varchar(255),
	@username varchar(255),
	@customerguid uniqueidentifier,
	@lastip varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

    INSERT into Customer 
            VALUES (
           @customerguid ,@username ,@email , NULL , 0 , 0 , 0, 0,
          1, 0, 1, 'MobileDevices' , @lastip , GETUTCDATE()
            , GETUTCDATE() , GETUTCDATE() , NULL, NULL, 0,
             NULL, 0, NULL, 1) ; SELECT SCOPE_IDENTITY() as LastID
END



GO
/****** Object:  StoredProcedure [dbo].[LanguagePackImport]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LanguagePackImport]
(
	@LanguageId int,
	@XmlPackage xml,
	@UpdateExistingResources bit
)
AS
BEGIN
	IF EXISTS(SELECT * FROM [Language] WHERE [Id] = @LanguageId)
	BEGIN
		CREATE TABLE #LocaleStringResourceTmp
			(
				[LanguageId] [int] NOT NULL,
				[ResourceName] [nvarchar](200) NOT NULL,
				[ResourceValue] [nvarchar](MAX) NOT NULL
			)

		INSERT INTO #LocaleStringResourceTmp (LanguageId, ResourceName, ResourceValue)
		SELECT	@LanguageId, nref.value('@Name', 'nvarchar(200)'), nref.value('Value[1]', 'nvarchar(MAX)')
		FROM	@XmlPackage.nodes('//Language/LocaleResource') AS R(nref)

		DECLARE @ResourceName nvarchar(200)
		DECLARE @ResourceValue nvarchar(MAX)
		DECLARE cur_localeresource CURSOR FOR
		SELECT LanguageId, ResourceName, ResourceValue
		FROM #LocaleStringResourceTmp
		OPEN cur_localeresource
		FETCH NEXT FROM cur_localeresource INTO @LanguageId, @ResourceName, @ResourceValue
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (EXISTS (SELECT 1 FROM [LocaleStringResource] WHERE LanguageId=@LanguageId AND ResourceName=@ResourceName))
			BEGIN
				IF (@UpdateExistingResources = 1)
				BEGIN
					UPDATE [LocaleStringResource]
					SET [ResourceValue]=@ResourceValue
					WHERE LanguageId=@LanguageId AND ResourceName=@ResourceName
				END
			END
			ELSE 
			BEGIN
				INSERT INTO [LocaleStringResource]
				(
					[LanguageId],
					[ResourceName],
					[ResourceValue]
				)
				VALUES
				(
					@LanguageId,
					@ResourceName,
					@ResourceValue
				)
			END
			
			
			FETCH NEXT FROM cur_localeresource INTO @LanguageId, @ResourceName, @ResourceValue
			END
		CLOSE cur_localeresource
		DEALLOCATE cur_localeresource

		DROP TABLE #LocaleStringResourceTmp
	END
END

GO
/****** Object:  StoredProcedure [dbo].[ProductLoadAllPaged]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductLoadAllPaged]
(
    @CategoryIds        nvarchar(MAX) = null,    --a list of category IDs (comma-separated list). e.g. 1,2,3
    @ManufacturerId        int = 0,
    @StoreId            int = 0,
    @VendorId            int = 0,
    @WarehouseId        int = 0,
    @ProductTypeId        int = null, --product type identifier, null - load all products
    @VisibleIndividuallyOnly bit = 0,     --0 - load all products , 1 - "visible indivially" only
    @MarkedAsNewOnly    bit = 0,     --0 - load all products , 1 - "marked as new" only
    @ProductTagId        int = 0,
    @FeaturedProducts    bit = null,    --0 featured only , 1 not featured only, null - load all products
    @PriceMin            decimal(18, 4) = null,
    @PriceMax            decimal(18, 4) = null,

    @Keywords            nvarchar(4000) = null,

    @SearchDescriptions bit = 0, --a value indicating whether to search by a specified "keyword" in product descriptions
    @SearchManufacturerPartNumber bit = 0, -- a value indicating whether to search by a specified "keyword" in manufacturer part number
    @SearchSku            bit = 0, --a value indicating whether to search by a specified "keyword" in product SKU
    @SearchProductTags  bit = 0, --a value indicating whether to search by a specified "keyword" in product tags
    @UseFullTextSearch  bit = 0,
    @FullTextMode        int = 0, --0 - using CONTAINS with <prefix_term>, 5 - using CONTAINS and OR with <prefix_term>, 10 - using CONTAINS and AND with <prefix_term>
    @FilteredSpecs        nvarchar(MAX) = null,    --filter by specification attribute options (comma-separated list of IDs). e.g. 14,15,16
    @LanguageId            int = 0,
    @OrderBy            int = 0, --0 - position, 5 - Name: A to Z, 6 - Name: Z to A, 10 - Price: Low to High, 11 - Price: High to Low, 15 - creation date
    @AllowedCustomerRoleIds    nvarchar(MAX) = null,    --a list of customer role IDs (comma-separated list) for which a product should be shown (if a subjet to ACL)
    @PageIndex            int = 0, 
    @PageSize            int = 2147483644,
    @ShowHidden            bit = 0,
    @OverridePublished    bit = null, --null - process "Published" property according to "showHidden" parameter, true - load only "Published" products, false - load only "Unpublished" products
    @LoadFilterableSpecificationAttributeOptionIds bit = 0, --a value indicating whether we should load the specification attribute option identifiers applied to loaded products (all pages)
    @FilterableSpecificationAttributeOptionIds nvarchar(MAX) = null OUTPUT, --the specification attribute option identifiers applied to loaded products (all pages). returned as a comma separated list of identifiers
    @TotalRecords        int = null OUTPUT
)
AS
BEGIN
    
    /* Products that filtered by keywords */
    CREATE TABLE #KeywordProducts
    (
        [ProductId] int NOT NULL
    )

    DECLARE
        @SearchKeywords bit,
        @OriginalKeywords nvarchar(4000),
        @sql nvarchar(max),
        @sql_orderby nvarchar(max)

    SET NOCOUNT ON
    
    --filter by keywords
    SET @Keywords = isnull(@Keywords, '')
    SET @Keywords = rtrim(ltrim(@Keywords))
    SET @OriginalKeywords = @Keywords
    IF ISNULL(@Keywords, '') != ''
    BEGIN
        SET @SearchKeywords = 1
        
        IF @UseFullTextSearch = 1
        BEGIN
            --remove wrong chars (' ")
            SET @Keywords = REPLACE(@Keywords, '''', '')
            SET @Keywords = REPLACE(@Keywords, '"', '')
            
            --full-text search
            IF @FullTextMode = 0 
            BEGIN
                --0 - using CONTAINS with <prefix_term>
                SET @Keywords = ' "' + @Keywords + '*" '
            END
            ELSE
            BEGIN
                --5 - using CONTAINS and OR with <prefix_term>
                --10 - using CONTAINS and AND with <prefix_term>

                --clean multiple spaces
                WHILE CHARINDEX('  ', @Keywords) > 0 
                    SET @Keywords = REPLACE(@Keywords, '  ', ' ')

                DECLARE @concat_term nvarchar(100)                
                IF @FullTextMode = 5 --5 - using CONTAINS and OR with <prefix_term>
                BEGIN
                    SET @concat_term = 'OR'
                END 
                IF @FullTextMode = 10 --10 - using CONTAINS and AND with <prefix_term>
                BEGIN
                    SET @concat_term = 'AND'
                END

                --now let's build search string
                declare @fulltext_keywords nvarchar(4000)
                set @fulltext_keywords = N''
                declare @index int        
        
                set @index = CHARINDEX(' ', @Keywords, 0)

                -- if index = 0, then only one field was passed
                IF(@index = 0)
                    set @fulltext_keywords = ' "' + @Keywords + '*" '
                ELSE
                BEGIN        
                    DECLARE @first BIT
                    SET  @first = 1            
                    WHILE @index > 0
                    BEGIN
                        IF (@first = 0)
                            SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' '
                        ELSE
                            SET @first = 0

                        SET @fulltext_keywords = @fulltext_keywords + '"' + SUBSTRING(@Keywords, 1, @index - 1) + '*"'                    
                        SET @Keywords = SUBSTRING(@Keywords, @index + 1, LEN(@Keywords) - @index)                        
                        SET @index = CHARINDEX(' ', @Keywords, 0)
                    end
                    
                    -- add the last field
                    IF LEN(@fulltext_keywords) > 0
                        SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' ' + '"' + SUBSTRING(@Keywords, 1, LEN(@Keywords)) + '*"'    
                END
                SET @Keywords = @fulltext_keywords
            END
        END
        ELSE
        BEGIN
            --usual search by PATINDEX
            SET @Keywords = '%' + @Keywords + '%'
        END
        --PRINT @Keywords

        --product name
        SET @sql = '
        INSERT INTO #KeywordProducts ([ProductId])
        SELECT p.Id
        FROM Product p with (NOLOCK)
        WHERE '
        IF @UseFullTextSearch = 1
            SET @sql = @sql + 'CONTAINS(p.[Name], @Keywords) '
        ELSE
            SET @sql = @sql + 'PATINDEX(@Keywords, p.[Name]) > 0 '


        --localized product name
        SET @sql = @sql + '
        UNION
        SELECT lp.EntityId
        FROM LocalizedProperty lp with (NOLOCK)
        WHERE
            lp.LocaleKeyGroup = N''Product''
            AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
            AND lp.LocaleKey = N''Name'''
        IF @UseFullTextSearch = 1
            SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
        ELSE
            SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
    

        IF @SearchDescriptions = 1
        BEGIN
            --product short description
            SET @sql = @sql + '
            UNION
            SELECT p.Id
            FROM Product p with (NOLOCK)
            WHERE '
            IF @UseFullTextSearch = 1
                SET @sql = @sql + 'CONTAINS(p.[ShortDescription], @Keywords) '
            ELSE
                SET @sql = @sql + 'PATINDEX(@Keywords, p.[ShortDescription]) > 0 '


            --product full description
            SET @sql = @sql + '
            UNION
            SELECT p.Id
            FROM Product p with (NOLOCK)
            WHERE '
            IF @UseFullTextSearch = 1
                SET @sql = @sql + 'CONTAINS(p.[FullDescription], @Keywords) '
            ELSE
                SET @sql = @sql + 'PATINDEX(@Keywords, p.[FullDescription]) > 0 '



            --localized product short description
            SET @sql = @sql + '
            UNION
            SELECT lp.EntityId
            FROM LocalizedProperty lp with (NOLOCK)
            WHERE
                lp.LocaleKeyGroup = N''Product''
                AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
                AND lp.LocaleKey = N''ShortDescription'''
            IF @UseFullTextSearch = 1
                SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
            ELSE
                SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
                

            --localized product full description
            SET @sql = @sql + '
            UNION
            SELECT lp.EntityId
            FROM LocalizedProperty lp with (NOLOCK)
            WHERE
                lp.LocaleKeyGroup = N''Product''
                AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
                AND lp.LocaleKey = N''FullDescription'''
            IF @UseFullTextSearch = 1
                SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
            ELSE
                SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
        END

        --manufacturer part number (exact match)
        IF @SearchManufacturerPartNumber = 1
        BEGIN
            SET @sql = @sql + '
            UNION
            SELECT p.Id
            FROM Product p with (NOLOCK)
            WHERE p.[ManufacturerPartNumber] = @OriginalKeywords '
        END

        --SKU (exact match)

        --    SET @sql = @sql + '
        --    UNION
        --    SELECT p.Id
        --    FROM Product p with (NOLOCK)
        --    WHERE p.[Sku] = @OriginalKeywords'

        IF @SearchSku = 1
        BEGIN
        SET @sql =@sql+ '
        UNION
        SELECT p.Id
        FROM Product p with (NOLOCK)
        WHERE '
        IF @UseFullTextSearch = 1
            SET @sql = @sql + 'CONTAINS(p.[Sku], @Keywords) '
        ELSE
            SET @sql = @sql + 'PATINDEX(@Keywords, p.[Sku]) > 0 '
        END


        IF @SearchProductTags = 1
        BEGIN
            --product tags (exact match)
            SET @sql = @sql + '
            UNION
            SELECT pptm.Product_Id
            FROM Product_ProductTag_Mapping pptm with(NOLOCK) INNER JOIN ProductTag pt with(NOLOCK) ON pt.Id = pptm.ProductTag_Id
            WHERE pt.[Name] = @OriginalKeywords '

            --localized product tags
            SET @sql = @sql + '
            UNION
            SELECT pptm.Product_Id
            FROM LocalizedProperty lp with (NOLOCK) INNER JOIN Product_ProductTag_Mapping pptm with(NOLOCK) ON lp.EntityId = pptm.ProductTag_Id
            WHERE
                lp.LocaleKeyGroup = N''ProductTag''
                AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
                AND lp.LocaleKey = N''Name''
                AND lp.[LocaleValue] = @OriginalKeywords '
        END

        --PRINT (@sql)
        EXEC sp_executesql @sql, N'@Keywords nvarchar(4000), @OriginalKeywords nvarchar(4000)', @Keywords, @OriginalKeywords

    END
    ELSE
    BEGIN
        SET @SearchKeywords = 0
    END

    --filter by category IDs
    SET @CategoryIds = isnull(@CategoryIds, '')    
    CREATE TABLE #FilteredCategoryIds
    (
        CategoryId int not null
    )
    INSERT INTO #FilteredCategoryIds (CategoryId)
    SELECT CAST(data as int) FROM [nop_splitstring_to_table](@CategoryIds, ',')    
    DECLARE @CategoryIdsCount int    
    SET @CategoryIdsCount = (SELECT COUNT(1) FROM #FilteredCategoryIds)

    --filter by customer role IDs (access control list)
    SET @AllowedCustomerRoleIds = isnull(@AllowedCustomerRoleIds, '')    
    CREATE TABLE #FilteredCustomerRoleIds
    (
        CustomerRoleId int not null
    )
    INSERT INTO #FilteredCustomerRoleIds (CustomerRoleId)
    SELECT CAST(data as int) FROM [nop_splitstring_to_table](@AllowedCustomerRoleIds, ',')
    DECLARE @FilteredCustomerRoleIdsCount int    
    SET @FilteredCustomerRoleIdsCount = (SELECT COUNT(1) FROM #FilteredCustomerRoleIds)
    
    --paging
    DECLARE @PageLowerBound int
    DECLARE @PageUpperBound int
    DECLARE @RowsToReturn int
    SET @RowsToReturn = @PageSize * (@PageIndex + 1)    
    SET @PageLowerBound = @PageSize * @PageIndex
    SET @PageUpperBound = @PageLowerBound + @PageSize + 1
    
    CREATE TABLE #DisplayOrderTmp 
    (
        [Id] int IDENTITY (1, 1) NOT NULL,
        [ProductId] int NOT NULL
    )

    SET @sql = '
    SELECT p.Id
    FROM
        Product p with (NOLOCK)'
    
    IF @CategoryIdsCount > 0
    BEGIN
        SET @sql = @sql + '
        LEFT JOIN Product_Category_Mapping pcm with (NOLOCK)
            ON p.Id = pcm.ProductId'
    END
    
    IF @ManufacturerId > 0
    BEGIN
        SET @sql = @sql + '
        LEFT JOIN Product_Manufacturer_Mapping pmm with (NOLOCK)
            ON p.Id = pmm.ProductId'
    END
    
    IF ISNULL(@ProductTagId, 0) != 0
    BEGIN
        SET @sql = @sql + '
        LEFT JOIN Product_ProductTag_Mapping pptm with (NOLOCK)
            ON p.Id = pptm.Product_Id'
    END
    
    --searching by keywords
    IF @SearchKeywords = 1
    BEGIN
        SET @sql = @sql + '
        JOIN #KeywordProducts kp
            ON  p.Id = kp.ProductId'
    END
    
    SET @sql = @sql + '
    WHERE
        p.Deleted = 0'
    
    --filter by category
    IF @CategoryIdsCount > 0
    BEGIN
        SET @sql = @sql + '
        AND pcm.CategoryId IN (SELECT CategoryId FROM #FilteredCategoryIds)'
        
        IF @FeaturedProducts IS NOT NULL
        BEGIN
            SET @sql = @sql + '
        AND pcm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))
        END
    END
    
    --filter by manufacturer
    IF @ManufacturerId > 0
    BEGIN
        SET @sql = @sql + '
        AND pmm.ManufacturerId = ' + CAST(@ManufacturerId AS nvarchar(max))
        
        IF @FeaturedProducts IS NOT NULL
        BEGIN
            SET @sql = @sql + '
        AND pmm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))
        END
    END
    
    --filter by vendor
    IF @VendorId > 0
    BEGIN
        SET @sql = @sql + '
        AND p.VendorId = ' + CAST(@VendorId AS nvarchar(max))
    END
    
    --filter by warehouse
    IF @WarehouseId > 0
    BEGIN
        --we should also ensure that 'ManageInventoryMethodId' is set to 'ManageStock' (1)
        --but we skip it in order to prevent hard-coded values (e.g. 1) and for better performance
        SET @sql = @sql + '
        AND  
            (
                (p.UseMultipleWarehouses = 0 AND
                    p.WarehouseId = ' + CAST(@WarehouseId AS nvarchar(max)) + ')
                OR
                (p.UseMultipleWarehouses > 0 AND
                    EXISTS (SELECT 1 FROM ProductWarehouseInventory [pwi]
                    WHERE [pwi].WarehouseId = ' + CAST(@WarehouseId AS nvarchar(max)) + ' AND [pwi].ProductId = p.Id))
            )'
    END
    
    --filter by product type
    IF @ProductTypeId is not null
    BEGIN
        SET @sql = @sql + '
        AND p.ProductTypeId = ' + CAST(@ProductTypeId AS nvarchar(max))
    END
    
    --filter by "visible individually"
    IF @VisibleIndividuallyOnly = 1
    BEGIN
        SET @sql = @sql + '
        AND p.VisibleIndividually = 1'
    END
    
    --filter by "marked as new"
    IF @MarkedAsNewOnly = 1
    BEGIN
        SET @sql = @sql + '
        AND p.MarkAsNew = 1
        AND (getutcdate() BETWEEN ISNULL(p.MarkAsNewStartDateTimeUtc, ''1/1/1900'') and ISNULL(p.MarkAsNewEndDateTimeUtc, ''1/1/2999''))'
    END
    
    --filter by product tag
    IF ISNULL(@ProductTagId, 0) != 0
    BEGIN
        SET @sql = @sql + '
        AND pptm.ProductTag_Id = ' + CAST(@ProductTagId AS nvarchar(max))
    END
    
    --"Published" property
    IF (@OverridePublished is null)
    BEGIN
        --process according to "showHidden"
        IF @ShowHidden = 0
        BEGIN
            SET @sql = @sql + '
            AND p.Published = 1'
        END
    END
    ELSE IF (@OverridePublished = 1)
    BEGIN
        --published only
        SET @sql = @sql + '
        AND p.Published = 1'
    END
    ELSE IF (@OverridePublished = 0)
    BEGIN
        --unpublished only
        SET @sql = @sql + '
        AND p.Published = 0'
    END
    
    --show hidden
    IF @ShowHidden = 0
    BEGIN
        SET @sql = @sql + '
        AND p.Deleted = 0
        AND (getutcdate() BETWEEN ISNULL(p.AvailableStartDateTimeUtc, ''1/1/1900'') and ISNULL(p.AvailableEndDateTimeUtc, ''1/1/2999''))'
    END
    
    --min price
    IF @PriceMin is not null
    BEGIN
        SET @sql = @sql + '
        AND (p.Price >= ' + CAST(@PriceMin AS nvarchar(max)) + ')'
    END
    
    --max price
    IF @PriceMax is not null
    BEGIN
        SET @sql = @sql + '
        AND (p.Price <= ' + CAST(@PriceMax AS nvarchar(max)) + ')'
    END
    
    --show hidden and ACL
    IF  @ShowHidden = 0 and @FilteredCustomerRoleIdsCount > 0
    BEGIN
        SET @sql = @sql + '
        AND (p.SubjectToAcl = 0 OR EXISTS (
            SELECT 1 FROM #FilteredCustomerRoleIds [fcr]
            WHERE
                [fcr].CustomerRoleId IN (
                    SELECT [acl].CustomerRoleId
                    FROM [AclRecord] acl with (NOLOCK)
                    WHERE [acl].EntityId = p.Id AND [acl].EntityName = ''Product''
                )
            ))'
    END
    
    --filter by store
    IF @StoreId > 0
    BEGIN
        SET @sql = @sql + '
        AND (p.LimitedToStores = 0 OR EXISTS (
            SELECT 1 FROM [StoreMapping] sm with (NOLOCK)
            WHERE [sm].EntityId = p.Id AND [sm].EntityName = ''Product'' and [sm].StoreId=' + CAST(@StoreId AS nvarchar(max)) + '
            ))'
    END
    
    --prepare filterable specification attribute option identifier (if requested)
   IF @LoadFilterableSpecificationAttributeOptionIds = 1
    BEGIN        
        CREATE TABLE #FilterableSpecs 
        (
            [SpecificationAttributeOptionId] int NOT NULL
        )
       DECLARE @sql_filterableSpecs nvarchar(max)
       SET @sql_filterableSpecs = '
            INSERT INTO #FilterableSpecs ([SpecificationAttributeOptionId])
            SELECT DISTINCT [psam].SpecificationAttributeOptionId
            FROM [Product_SpecificationAttribute_Mapping] [psam] WITH (NOLOCK)
                WHERE [psam].[AllowFiltering] = 1
                AND [psam].[ProductId] IN (' + @sql + ')'

       EXEC sp_executesql @sql_filterableSpecs

        --build comma separated list of filterable identifiers
        SELECT @FilterableSpecificationAttributeOptionIds = COALESCE(@FilterableSpecificationAttributeOptionIds + ',' , '') + CAST(SpecificationAttributeOptionId as nvarchar(4000))
        FROM #FilterableSpecs

        DROP TABLE #FilterableSpecs
    END

    --filter by specification attribution options
    SET @FilteredSpecs = isnull(@FilteredSpecs, '')    
    CREATE TABLE #FilteredSpecs
    (
        SpecificationAttributeOptionId int not null
    )
    INSERT INTO #FilteredSpecs (SpecificationAttributeOptionId)
    SELECT CAST(data as int) FROM [nop_splitstring_to_table](@FilteredSpecs, ',') 

   CREATE TABLE #FilteredSpecsWithAttributes
    (
       SpecificationAttributeId int not null,
        SpecificationAttributeOptionId int not null
    )
    INSERT INTO #FilteredSpecsWithAttributes (SpecificationAttributeId, SpecificationAttributeOptionId)
    SELECT sao.SpecificationAttributeId, fs.SpecificationAttributeOptionId
   FROM #FilteredSpecs fs INNER JOIN SpecificationAttributeOption sao ON sao.Id = fs.SpecificationAttributeOptionId
   ORDER BY sao.SpecificationAttributeId 

   DECLARE @SpecAttributesCount int    
    SET @SpecAttributesCount = (SELECT COUNT(1) FROM #FilteredSpecsWithAttributes)
    IF @SpecAttributesCount > 0
    BEGIN
        --do it for each specified specification option
        DECLARE @SpecificationAttributeOptionId int
       DECLARE @SpecificationAttributeId int
       DECLARE @LastSpecificationAttributeId int
       SET @LastSpecificationAttributeId = 0
        DECLARE cur_SpecificationAttributeOption CURSOR FOR
        SELECT SpecificationAttributeId, SpecificationAttributeOptionId
        FROM #FilteredSpecsWithAttributes

        OPEN cur_SpecificationAttributeOption
       FOREACH:
           FETCH NEXT FROM cur_SpecificationAttributeOption INTO @SpecificationAttributeId, @SpecificationAttributeOptionId
           IF (@LastSpecificationAttributeId <> 0 AND @SpecificationAttributeId <> @LastSpecificationAttributeId OR @@FETCH_STATUS <> 0) 
                SET @sql = @sql + '
       AND p.Id in (select psam.ProductId from [Product_SpecificationAttribute_Mapping] psam with (NOLOCK) where psam.AllowFiltering = 1 and psam.SpecificationAttributeOptionId IN (SELECT SpecificationAttributeOptionId FROM #FilteredSpecsWithAttributes WHERE SpecificationAttributeId = ' + CAST(@LastSpecificationAttributeId AS nvarchar(max)) + '))'
           SET @LastSpecificationAttributeId = @SpecificationAttributeId
        IF @@FETCH_STATUS = 0 GOTO FOREACH
        CLOSE cur_SpecificationAttributeOption
        DEALLOCATE cur_SpecificationAttributeOption
    END

    --sorting
    SET @sql_orderby = ''    
    IF @OrderBy = 5 /* Name: A to Z */
        SET @sql_orderby = ' p.[Name] ASC'
    ELSE IF @OrderBy = 6 /* Name: Z to A */
        SET @sql_orderby = ' p.[Name] DESC'
    ELSE IF @OrderBy = 10 /* Price: Low to High */
        SET @sql_orderby = ' p.[Price] ASC'
    ELSE IF @OrderBy = 11 /* Price: High to Low */
        SET @sql_orderby = ' p.[Price] DESC'
    ELSE IF @OrderBy = 15 /* creation date */
        SET @sql_orderby = ' p.[CreatedOnUtc] DESC'
    ELSE /* default sorting, 0 (position) */
    BEGIN
        --category position (display order)
        IF @CategoryIdsCount > 0 SET @sql_orderby = ' pcm.DisplayOrder ASC'
        
        --manufacturer position (display order)
        IF @ManufacturerId > 0
        BEGIN
            IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '
            SET @sql_orderby = @sql_orderby + ' pmm.DisplayOrder ASC'
        END
        
        --name
        IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '
        SET @sql_orderby = @sql_orderby + ' p.[Name] ASC'
    END
    
    SET @sql = @sql + '
    ORDER BY' + @sql_orderby
    
   SET @sql = '
   INSERT INTO #DisplayOrderTmp ([ProductId])' + @sql

    --PRINT (@sql)
    EXEC sp_executesql @sql

    DROP TABLE #FilteredCategoryIds
    DROP TABLE #FilteredSpecs
   DROP TABLE #FilteredSpecsWithAttributes
    DROP TABLE #FilteredCustomerRoleIds
    DROP TABLE #KeywordProducts

    CREATE TABLE #PageIndex 
    (
        [IndexId] int IDENTITY (1, 1) NOT NULL,
        [ProductId] int NOT NULL
    )
    INSERT INTO #PageIndex ([ProductId])
    SELECT ProductId
    FROM #DisplayOrderTmp
    GROUP BY ProductId
    ORDER BY min([Id])

    --total records
    SET @TotalRecords = @@rowcount
    
    DROP TABLE #DisplayOrderTmp

    --return products
    SELECT TOP (@RowsToReturn)
        p.*
    FROM
        #PageIndex [pi]
        INNER JOIN Product p with (NOLOCK) on p.Id = [pi].[ProductId]
    WHERE
        [pi].IndexId > @PageLowerBound AND 
        [pi].IndexId < @PageUpperBound
    ORDER BY
        [pi].IndexId
    
    DROP TABLE #PageIndex
END

GO
/****** Object:  StoredProcedure [dbo].[ProductLoadAllPagedNopAjaxFilters]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductLoadAllPagedNopAjaxFilters]  (  	@CategoryIds		nvarchar(MAX) = null,	 	@ManufacturerId		int = 0,  	@StoreId			int = 0,  	@VendorId			int = 0,  	@ParentGroupedProductId	int = 0,  	@ProductTypeId		int = null,  	@VisibleIndividuallyOnly bit = 0, 	 	@ProductTagId		int = 0,  	@FeaturedProducts	bit = null,	 	@PriceMin			decimal(18, 4) = null,  	@PriceMax			decimal(18, 4) = null,  	@Keywords			nvarchar(4000) = null,  	@SearchDescriptions bit = 0,  	@SearchSku			bit = 0,  	@SearchProductTags  bit = 0,  	@UseFullTextSearch  bit = 0,  	@FullTextMode		int = 0,  	@FilteredSpecs		nvarchar(MAX) = null,	 	@FilteredProductVariantAttributes		nvarchar(MAX) = null,  	@FilteredManufacturers		nvarchar(MAX) = null,  	@FilteredVendors	nvarchar(MAX) = null,  	@OnSale				bit = 0,  	@InStock			bit = 0,  	@LanguageId			int = 0,  	@OrderBy			int = 0,  	@AllowedCustomerRoleIds	nvarchar(MAX) = null,	 	@PageIndex			int = 0,   	@PageSize			int = 2147483644,  	@ShowHidden			bit = 0,  	@LoadAvailableFilters bit = 0,  	@FilterableSpecificationAttributeOptionIds nvarchar(MAX) = null OUTPUT,  	@FilterableProductVariantAttributeIds nvarchar(MAX) = null OUTPUT,  	@FilterableManufacturerIds nvarchar(MAX) = null OUTPUT,  	@FilterableVendorIds nvarchar(MAX) = null OUTPUT,  	@IsOnSaleFilterEnabled 	bit = 0,  	@IsInStockFilterEnabled bit = 0,  	@HasProductsOnSale	bit = 0 OUTPUT,  	@HasProductsInStock	bit = 0 OUTPUT,  	@TotalRecords		int = null OUTPUT  )    AS  BEGIN  	  	 	 	 	 	  	    	  	CREATE TABLE #KeywordProducts  	(  		[ProductId] int NOT NULL  	)    	DECLARE  		@SearchKeywords bit,  		@OriginalKeywords nvarchar(4000),  		@sql nvarchar(max),  		@sqlWithoutFilters nvarchar(max),  		@sql_orderby nvarchar(max)    	SET NOCOUNT ON  	  	 	SET @Keywords = isnull(@Keywords, '')  	SET @Keywords = rtrim(ltrim(@Keywords))  	SET @OriginalKeywords = @Keywords  	IF ISNULL(@Keywords, '') != ''  	BEGIN  		SET @SearchKeywords = 1  		  		IF @UseFullTextSearch = 1  		BEGIN  			 			SET @Keywords = REPLACE(@Keywords, '''', '')  			SET @Keywords = REPLACE(@Keywords, '"', '')  			  			 			IF @FullTextMode = 0   			BEGIN  				 				SET @Keywords = ' "' + @Keywords + '*" '  			END  			ELSE  			BEGIN  				 				   				 				WHILE CHARINDEX('  ', @Keywords) > 0   					SET @Keywords = REPLACE(@Keywords, '  ', ' ')    				DECLARE @concat_term nvarchar(100)				  				IF @FullTextMode = 5  				BEGIN  					SET @concat_term = 'OR'  				END   				IF @FullTextMode = 10  				BEGIN  					SET @concat_term = 'AND'  				END    				 				declare @fulltext_keywords nvarchar(4000)  				set @fulltext_keywords = N''  				declare @index int		  		  				set @index = CHARINDEX(' ', @Keywords, 0)    				 				IF(@index = 0)  					set @fulltext_keywords = ' "' + @Keywords + '*" '  				ELSE  				BEGIN		  					DECLARE @first BIT  					SET  @first = 1			  					WHILE @index > 0  					BEGIN  						IF (@first = 0)  							SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' '  						ELSE  							SET @first = 0    						SET @fulltext_keywords = @fulltext_keywords + '"' + SUBSTRING(@Keywords, 1, @index - 1) + '*"'					  						SET @Keywords = SUBSTRING(@Keywords, @index + 1, LEN(@Keywords) - @index)						  						SET @index = CHARINDEX(' ', @Keywords, 0)  					end  					  					 					IF LEN(@fulltext_keywords) > 0  						SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' ' + '"' + SUBSTRING(@Keywords, 1, LEN(@Keywords)) + '*"'	  				END  				SET @Keywords = @fulltext_keywords  			END  		END  		ELSE  		BEGIN  			 			SET @Keywords = '%' + @Keywords + '%'  		END  		   		 		SET @sql = '  		INSERT INTO #KeywordProducts ([ProductId])  		SELECT p.Id  		FROM Product p with (NOLOCK)  		WHERE '  		IF @UseFullTextSearch = 1  			SET @sql = @sql + 'CONTAINS(p.[Name], @Keywords) '  		ELSE  			SET @sql = @sql + 'PATINDEX(@Keywords, p.[Name]) > 0 '      		 		SET @sql = @sql + '  		UNION  		SELECT lp.EntityId  		FROM LocalizedProperty lp with (NOLOCK)  		WHERE  			lp.LocaleKeyGroup = N''Product''  			AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '  			AND lp.LocaleKey = N''Name'''  		IF @UseFullTextSearch = 1  			SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '  		ELSE  			SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '  	    		IF @SearchDescriptions = 1  		BEGIN  			 			SET @sql = @sql + '  			UNION  			SELECT p.Id  			FROM Product p with (NOLOCK)  			WHERE '  			IF @UseFullTextSearch = 1  				SET @sql = @sql + 'CONTAINS(p.[ShortDescription], @Keywords) '  			ELSE  				SET @sql = @sql + 'PATINDEX(@Keywords, p.[ShortDescription]) > 0 '      			 			SET @sql = @sql + '  			UNION  			SELECT p.Id  			FROM Product p with (NOLOCK)  			WHERE '  			IF @UseFullTextSearch = 1  				SET @sql = @sql + 'CONTAINS(p.[FullDescription], @Keywords) '  			ELSE  				SET @sql = @sql + 'PATINDEX(@Keywords, p.[FullDescription]) > 0 '        			 			SET @sql = @sql + '  			UNION  			SELECT lp.EntityId  			FROM LocalizedProperty lp with (NOLOCK)  			WHERE  				lp.LocaleKeyGroup = N''Product''  				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '  				AND lp.LocaleKey = N''ShortDescription'''  			IF @UseFullTextSearch = 1  				SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '  			ELSE  				SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '  				    			 			SET @sql = @sql + '  			UNION  			SELECT lp.EntityId  			FROM LocalizedProperty lp with (NOLOCK)  			WHERE  				lp.LocaleKeyGroup = N''Product''  				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '  				AND lp.LocaleKey = N''FullDescription'''  			IF @UseFullTextSearch = 1  				SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '  			ELSE  				SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '  		END    		 		IF @SearchSku = 1  		BEGIN  			SET @sql = @sql + '  			UNION  			SELECT p.Id  			FROM Product p with (NOLOCK)  			WHERE p.[Sku] = @OriginalKeywords '  		END    		IF @SearchProductTags = 1  		BEGIN  			 			SET @sql = @sql + '  			UNION  			SELECT pptm.Product_Id  			FROM Product_ProductTag_Mapping pptm with(NOLOCK) INNER JOIN ProductTag pt with(NOLOCK) ON pt.Id = pptm.ProductTag_Id  			WHERE pt.[Name] = @OriginalKeywords '    			 			SET @sql = @sql + '  			UNION  			SELECT pptm.Product_Id  			FROM LocalizedProperty lp with (NOLOCK) INNER JOIN Product_ProductTag_Mapping pptm with(NOLOCK) ON lp.EntityId = pptm.ProductTag_Id  			WHERE  				lp.LocaleKeyGroup = N''ProductTag''  				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '  				AND lp.LocaleKey = N''Name''  				AND lp.[LocaleValue] = @OriginalKeywords '  		END    		 		EXEC sp_executesql @sql, N'@Keywords nvarchar(4000), @OriginalKeywords nvarchar(4000)', @Keywords, @OriginalKeywords    	END  	ELSE  	BEGIN  		SET @SearchKeywords = 0  	END    	 	SET @CategoryIds = isnull(@CategoryIds, '')	  	CREATE TABLE #FilteredCategoryIds  	(  		CategoryId int not null  	)  	INSERT INTO #FilteredCategoryIds (CategoryId)  	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@CategoryIds, ',')	  	DECLARE @CategoryIdsCount int	  	SET @CategoryIdsCount = (SELECT COUNT(1) FROM #FilteredCategoryIds)    	 	SET @FilteredSpecs = isnull(@FilteredSpecs, '')	  	CREATE TABLE #FilteredSpecificationAttributeOptions  	(  		SpecificationAttributeOptionId int not null unique  	)    	INSERT INTO #FilteredSpecificationAttributeOptions (SpecificationAttributeOptionId)  	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@FilteredSpecs, ',')    	DECLARE @SpecificationAttributesCount int	  	SET @SpecificationAttributesCount =   	(  		SELECT COUNT(DISTINCT sao.SpecificationAttributeId) FROM #FilteredSpecificationAttributeOptions fs   		INNER JOIN SpecificationAttributeOption sao ON sao.Id = fs.SpecificationAttributeOptionId   	)    	CREATE TABLE #FilteredSpecificationAttributes  	(  		AttributeId int not null  	)    	CREATE UNIQUE CLUSTERED INDEX IX_#FilteredSpecificationAttributes_AttributeId  	ON #FilteredSpecificationAttributes (AttributeId);    	INSERT INTO #FilteredSpecificationAttributes  	SELECT DISTINCT sap.SpecificationAttributeId  	FROM SpecificationAttributeOption sap  	INNER JOIN #FilteredSpecificationAttributeOptions fs ON fs.SpecificationAttributeOptionId = sap.Id  	  	 	SET @FilteredProductVariantAttributes = isnull(@FilteredProductVariantAttributes, '')	  	CREATE TABLE #FilteredProductVariantAttributes  	(  		ProductVariantAttributeId int not null  	)    	CREATE INDEX IX_FilteredProductVariantAttributes_ProductVariantAttributeId  	ON #FilteredProductVariantAttributes (ProductVariantAttributeId);     	INSERT INTO #FilteredProductVariantAttributes (ProductVariantAttributeId)  	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@FilteredProductVariantAttributes, ',')    	DECLARE @ProductAttributesCount int	  	SET @ProductAttributesCount =   	(  		SELECT COUNT(DISTINCT ppm.ProductAttributeId) FROM #FilteredProductVariantAttributes fpva   		INNER JOIN Product_ProductAttribute_Mapping ppm ON ppm.Id = fpva.ProductVariantAttributeId   	)    	CREATE TABLE #FilteredProductAttributes  	(  		AttributeId int not null  	)    	CREATE UNIQUE CLUSTERED INDEX IX_#FilteredAttributes_AttributeId  	ON #FilteredProductAttributes (AttributeId);    	INSERT INTO #FilteredProductAttributes  	SELECT DISTINCT ProductAttributeId  	FROM Product_ProductAttribute_Mapping ppm  	INNER JOIN #FilteredProductVariantAttributes fpv ON fpv.ProductVariantAttributeId = ppm.Id  	  	 	SET @FilteredManufacturers = isnull(@FilteredManufacturers, '')	  	CREATE TABLE #FilteredManufacturers  	(  		ManufacturerId int not null  	)  	INSERT INTO #FilteredManufacturers (ManufacturerId)  	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@FilteredManufacturers, ',')  	DECLARE @ManufacturersCount int	  	SET @ManufacturersCount = (SELECT COUNT(1) FROM #FilteredManufacturers)  	  	 	SET @FilteredVendors = isnull(@FilteredVendors, '')	  	CREATE TABLE #FilteredVendorIds  	(  		VendorId int not null  	)  	INSERT INTO #FilteredVendorIds (VendorId)  	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@FilteredVendors, ',')	    	 	SET @AllowedCustomerRoleIds = isnull(@AllowedCustomerRoleIds, '')	  	CREATE TABLE #FilteredCustomerRoleIds  	(  		CustomerRoleId int not null  	)  	INSERT INTO #FilteredCustomerRoleIds (CustomerRoleId)  	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@AllowedCustomerRoleIds, ',')  	DECLARE @VendorsCount int	  	SET @VendorsCount = (SELECT COUNT(1) FROM #FilteredVendorIds)  	  	 	DECLARE @PageLowerBound int  	DECLARE @PageUpperBound int  	DECLARE @RowsToReturn int  	SET @RowsToReturn = @PageSize * (@PageIndex + 1)	  	SET @PageLowerBound = @PageSize * @PageIndex  	SET @PageUpperBound = @PageLowerBound + @PageSize + 1  	  	CREATE TABLE #DisplayOrderTmp   	(  		[Id] int IDENTITY (1, 1) NOT NULL,  		[ProductId] int NOT NULL,  		[ChildProductId] int  	)    	 	 	SET @sql = '  	INSERT INTO #DisplayOrderTmp ([ProductId], [ChildProductId])  	SELECT p.Id, ISNULL(cp.Id, 0)  	FROM  		Product p with (NOLOCK)  		LEFT JOIN Product cp with (NOLOCK)  		ON p.Id = cp.ParentGroupedProductId'  	  	IF @CategoryIdsCount > 0  	BEGIN  		SET @sql = @sql + '  		LEFT JOIN Product_Category_Mapping pcm with (NOLOCK)  			ON p.Id = pcm.ProductId'  	END  	  	IF @ManufacturerId > 0 OR @ManufacturersCount > 0  	BEGIN  		SET @sql = @sql + '  		LEFT JOIN Product_Manufacturer_Mapping pmm with (NOLOCK)  			ON p.Id = pmm.ProductId'  	END  	  	IF ISNULL(@ProductTagId, 0) != 0  	BEGIN  		SET @sql = @sql + '  		LEFT JOIN Product_ProductTag_Mapping pptm with (NOLOCK)  			ON p.Id = pptm.Product_Id'  	END  	  	 	IF @SearchKeywords = 1  	BEGIN  		SET @sql = @sql + '  		JOIN #KeywordProducts kp  			ON  p.Id = kp.ProductId'  	END  	  	SET @sql = @sql + '  	WHERE  		p.Deleted = 0'  		  	SET @sql = @sql + '  	AND  		(p.ParentGroupedProductId = 0 OR p.VisibleIndividually = 1)'  	  	 	IF @CategoryIdsCount > 0  	BEGIN  		SET @sql = @sql + '  		AND pcm.CategoryId IN (SELECT CategoryId FROM #FilteredCategoryIds)'  		  		IF @FeaturedProducts IS NOT NULL  		BEGIN  			SET @sql = @sql + '  		AND pcm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))  		END  	END  	  	 	IF @ManufacturerId > 0  	BEGIN  		SET @sql = @sql + '  		AND pmm.ManufacturerId = ' + CAST(@ManufacturerId AS nvarchar(max))  		  		IF @FeaturedProducts IS NOT NULL  		BEGIN  			SET @sql = @sql + '  		AND pmm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))  		END  	END  	  	 	IF @VendorId > 0  	BEGIN  		SET @sql = @sql + '  		AND p.VendorId = ' + CAST(@VendorId AS nvarchar(max))  	END  	  	 	IF @ParentGroupedProductId > 0  	BEGIN  		SET @sql = @sql + '  		AND p.ParentGroupedProductId = ' + CAST(@ParentGroupedProductId AS nvarchar(max))  	END  	  	 	IF @OnSale = 1  	BEGIN  		SET @sql = @sql + '  		AND   			(  				(cp.ID IS NULL AND p.OldPrice > 0  AND p.OldPrice != p.Price)  			  			OR  			   				(cp.ID IS NOT NULL AND cp.OldPrice > 0  AND cp.OldPrice != cp.Price)  			)'  	END  	 	IF @InStock = 1  	BEGIN  		SET @sql = @sql + '  		AND   			(  				(cp.ID IS NULL  AND   					(  						(p.ManageInventoryMethodId = 0) OR  						(P.ManageInventoryMethodId = 1 AND  							(  								(p.StockQuantity > 0 AND p.UseMultipleWarehouses = 0) OR   								(EXISTS(SELECT 1 FROM ProductWarehouseInventory [pwi] WHERE	[pwi].ProductId = p.Id	AND [pwi].StockQuantity > 0 AND [pwi].StockQuantity > [pwi].ReservedQuantity) AND p.UseMultipleWarehouses = 1)  							)  						)  					)  				)  				OR  				(p.Id IS NOT NULL AND   					(  						(cp.ManageInventoryMethodId = 0) OR  						(cp.ManageInventoryMethodId = 1 AND  							(  								(cp.StockQuantity > 0 AND cp.UseMultipleWarehouses = 0) OR   								(EXISTS(SELECT 1 FROM ProductWarehouseInventory [pwi] WHERE [pwi].ProductId = cp.Id	AND [pwi].StockQuantity > 0 AND [pwi].StockQuantity > [pwi].ReservedQuantity) AND cp.UseMultipleWarehouses = 1)  							)  						)  					)  				)  			)'  	END  	 	IF @ProductTypeId is not null  	BEGIN  		SET @sql = @sql + '  		AND p.ProductTypeId = ' + CAST(@ProductTypeId AS nvarchar(max))  	END  	  	 	IF @VisibleIndividuallyOnly = 1  	BEGIN  		SET @sql = @sql + '  		AND p.VisibleIndividually = 1'  	END  	  	 	IF ISNULL(@ProductTagId, 0) != 0  	BEGIN  		SET @sql = @sql + '  		AND pptm.ProductTag_Id = ' + CAST(@ProductTagId AS nvarchar(max))  	END  	  	 	IF @ShowHidden = 0  	BEGIN  		SET @sql = @sql + '  		AND p.Published = 1  		AND p.Deleted = 0  		AND (getutcdate() BETWEEN ISNULL(p.AvailableStartDateTimeUtc, ''1/1/1900'') and ISNULL(p.AvailableEndDateTimeUtc, ''1/1/2999''))'  	END  	  	 	 	 	IF @PriceMin > 0  	BEGIN  		SET @sql = @sql + '  		AND (  				(  					cp.Id IS NULL  					  					AND  					  					(p.Price >= ' + CAST(@PriceMin AS nvarchar(max)) + ')  				)  				OR  				(	  					(cp.Price >= ' + CAST(@PriceMin AS nvarchar(max)) + ')  				)  			)'  	END  	  	 	 	 	IF @PriceMax > 0  	BEGIN  		SET @sql = @sql + '  		AND (  				(  					cp.Id IS NULL  					  					AND  					  					(p.Price <= ' + CAST(@PriceMax AS nvarchar(max)) + ')  				)  				OR  				(  					(cp.Price <= ' + CAST(@PriceMax AS nvarchar(max)) + ')  				)  			)'  	END  	    	 	IF @ShowHidden = 0  	BEGIN  		SET @sql = @sql + '  		AND (p.SubjectToAcl = 0 OR EXISTS (  			SELECT 1 FROM #FilteredCustomerRoleIds [fcr]  			WHERE  				[fcr].CustomerRoleId IN (  					SELECT [acl].CustomerRoleId  					FROM [AclRecord] acl with (NOLOCK)  					WHERE [acl].EntityId = p.Id AND [acl].EntityName = ''Product''  				)  			))'  	END  	  	 	IF @StoreId > 0  	BEGIN  		SET @sql = @sql + '  		AND (p.LimitedToStores = 0 OR EXISTS (  			SELECT 1 FROM [StoreMapping] sm with (NOLOCK)  			WHERE [sm].EntityId = p.Id AND [sm].EntityName = ''Product'' and [sm].StoreId=' + CAST(@StoreId AS nvarchar(max)) + '  			))'  	END  	  	 	 	SET @sqlWithoutFilters = @sql  	  	 	 	 	 	 	IF @SpecificationAttributesCount > 0  	BEGIN  		SET @sql = @sql + '  		AND (  				(SELECT AttributesCount FROM #FilteredSpecificationAttributesToProduct fsatp  				WHERE p.Id = fsatp.ProductId) = ' + CAST(@SpecificationAttributesCount AS nvarchar(max)) +   			')'  	END  	  	 	 	 	 	 	  	 	 	  	IF @ProductAttributesCount > 0  	BEGIN  		SET @sql = @sql + '  				AND (  				(SELECT AttributesCount FROM #FilteredProductAttributesToProduct fpatp  				WHERE (cp.Id IS NULL AND p.Id = fpatp.ProductId) OR cp.Id = fpatp.ProductId) = ' + CAST(@ProductAttributesCount AS nvarchar(max)) +   			')'  	END  	  	 	IF @ManufacturersCount > 0  	BEGIN  		SET @sql = @sql + '  		AND pmm.ManufacturerId IN (SELECT ManufacturerId FROM #FilteredManufacturers)'  	END  	  	 	IF @VendorsCount > 0  	BEGIN  		  		SET @sql = @sql + '   		AND p.VendorId IN (SELECT VendorId FROM #FilteredVendorIds)'  	END  	  	 	SET @sql_orderby = [dbo].[seven_spikes_ajax_filters_product_sorting] (@OrderBy, @CategoryIdsCount, @ManufacturerId, @ParentGroupedProductId)  	  	SET @sql = @sql + '  	ORDER BY' + @sql_orderby    	  	 	 	 	 	 	 	 	  	EXEC sp_executesql @sqlWithoutFilters  	  	CREATE TABLE #ProductIdsBeforeFiltersApplied   	(  		[ProductId] int NOT NULL,  		[ChildProductId] int  	)    	CREATE UNIQUE CLUSTERED INDEX IX_ProductIds_ProductId  	ON #ProductIdsBeforeFiltersApplied (ProductId, ChildProductId);    	INSERT INTO #ProductIdsBeforeFiltersApplied ([ProductId], [ChildProductId])  	SELECT ProductId, ChildProductId  	FROM #DisplayOrderTmp  	GROUP BY ProductId, ChildProductId  	ORDER BY min([Id])    	 	   	DELETE FROM #DisplayOrderTmp    	 	 	 	 	   	CREATE TABLE #FilteredSpecificationAttributesToProduct  	(  		ProductId int not null,  		AttributesCount int not null  	)    	CREATE UNIQUE CLUSTERED INDEX IX_#FilteredSpecificationAttributesToProduct_ProductId  	ON #FilteredSpecificationAttributesToProduct (ProductId)    	IF @SpecificationAttributesCount > 0  	BEGIN    		 		 		   		IF @SpecificationAttributesCount > 1  		BEGIN    			INSERT INTO #FilteredSpecificationAttributesToProduct  			SELECT psm.ProductId, COUNT (DISTINCT sao.SpecificationAttributeId)  			FROM Product_SpecificationAttribute_Mapping psm  			INNER JOIN #ProductIdsBeforeFiltersApplied p ON p.ProductId = psm.ProductId  			INNER JOIN #FilteredSpecificationAttributeOptions fs ON fs.SpecificationAttributeOptionId = psm.SpecificationAttributeOptionId  			INNER JOIN SpecificationAttributeOption sao ON sao.Id = psm.SpecificationAttributeOptionId  			GROUP BY psm.ProductId  			HAVING COUNT (DISTINCT sao.SpecificationAttributeId) >= @SpecificationAttributesCount - 1  		END    		IF @SpecificationAttributesCount = 1  		BEGIN    			INSERT INTO #FilteredSpecificationAttributesToProduct  			SELECT DISTINCT psm.ProductId, 1  			FROM Product_SpecificationAttribute_Mapping psm  			INNER JOIN #ProductIdsBeforeFiltersApplied p ON p.ProductId = psm.ProductId  			INNER JOIN #FilteredSpecificationAttributeOptions fs ON fs.SpecificationAttributeOptionId = psm.SpecificationAttributeOptionId AND psm.AllowFiltering = 1     			INSERT INTO #FilteredSpecificationAttributesToProduct  			SELECT DISTINCT psm.ProductId, 0  			FROM Product_SpecificationAttribute_Mapping psm  			INNER JOIN #ProductIdsBeforeFiltersApplied p ON p.ProductId = psm.ProductId  			INNER JOIN SpecificationAttributeOption sao ON sao.Id = psm.SpecificationAttributeOptionId  			INNER JOIN #FilteredSpecificationAttributes fsa ON fsa.AttributeId = sao.SpecificationAttributeId  			WHERE NOT EXISTS (SELECT NULL FROM #FilteredSpecificationAttributesToProduct fsatp WHERE fsatp.ProductId = psm.ProductId) AND psm.AllowFiltering = 1     		END      		 		 		   		IF @SpecificationAttributesCount > 1  		BEGIN    			DELETE #FilteredSpecificationAttributesToProduct  			FROM #FilteredSpecificationAttributesToProduct fsatp  			WHERE (SELECT COUNT (DISTINCT sao.SpecificationAttributeId)  			FROM Product_SpecificationAttribute_Mapping psm  			INNER JOIN SpecificationAttributeOption sao ON sao.Id = psm.SpecificationAttributeOptionId  			INNER JOIN #FilteredSpecificationAttributes fsa ON fsa.AttributeId = sao.SpecificationAttributeId  			WHERE psm.ProductId = fsatp.ProductId) < @SpecificationAttributesCount    		END    	END    	 	 	 	 	 	 	   	CREATE TABLE #FilteredProductAttributesToProduct  	(  		ProductId int not null,  		AttributesCount int not null  	)    	CREATE UNIQUE CLUSTERED INDEX IX_#FilteredProductAttributesToProduct_ProductId  	ON #FilteredProductAttributesToProduct (ProductId)    	 	 	   	IF @ProductAttributesCount > 0  	BEGIN    		 		 		   		IF @ProductAttributesCount > 1  		BEGIN    			INSERT INTO #FilteredProductAttributesToProduct  			SELECT ppm.ProductId, COUNT (DISTINCT ppm.ProductAttributeId)  			FROM Product_ProductAttribute_Mapping ppm  			INNER JOIN #ProductIdsBeforeFiltersApplied p ON p.ProductId = ppm.ProductId OR p.ChildProductId = ppm.ProductId  			INNER JOIN #FilteredProductVariantAttributes fpva ON fpva.ProductVariantAttributeId = ppm.Id  			GROUP BY ppm.ProductId  			HAVING COUNT(DISTINCT ppm.ProductAttributeId) >= @ProductAttributesCount - 1    		END    		IF @ProductAttributesCount = 1  		BEGIN    			INSERT INTO #FilteredProductAttributesToProduct  			SELECT DISTINCT ppm.ProductId, 1  			FROM Product_ProductAttribute_Mapping ppm  			INNER JOIN #ProductIdsBeforeFiltersApplied p ON p.ProductId = ppm.ProductId OR p.ChildProductId = ppm.ProductId  			INNER JOIN #FilteredProductVariantAttributes fpva ON fpva.ProductVariantAttributeId = ppm.Id    			INSERT INTO #FilteredProductAttributesToProduct  			SELECT DISTINCT ppm.ProductId, 0  			FROM Product_ProductAttribute_Mapping ppm  			INNER JOIN #ProductIdsBeforeFiltersApplied p ON p.ProductId = ppm.ProductId OR p.ChildProductId = ppm.ProductId  			INNER JOIN #FilteredProductAttributes fa ON fa.AttributeId = ppm.ProductAttributeId  			WHERE ppm.ProductId NOT IN (SELECT ProductId FROM #FilteredProductAttributesToProduct)    		END    		 		 		 		 		 		   		 		 		 		 		 		   		 		 		   		IF @ProductAttributesCount > 1  		BEGIN    			DELETE #FilteredProductAttributesToProduct  			FROM #FilteredProductAttributesToProduct fpatp  			WHERE (SELECT COUNT(DISTINCT ppm.ProductAttributeId) FROM  			Product_ProductAttribute_Mapping ppm  			INNER JOIN #FilteredProductAttributes fa ON fa.AttributeId = ppm.ProductAttributeId  			WHERE ppm.ProductId = fpatp.ProductId) < @ProductAttributesCount    		END    	END  	  	   	EXEC sp_executesql @sql    	CREATE TABLE #PageIndex   	(  		[IndexId] int IDENTITY (1, 1) NOT NULL,  		[ProductId] int NOT NULL,  		[ChildProductId] int  	)  	  	INSERT INTO #PageIndex ([ProductId], [ChildProductId])  	SELECT ProductId, ChildProductId  	FROM #DisplayOrderTmp  	GROUP BY ProductId, ChildProductId  	ORDER BY min([Id])  	  	SET @TotalRecords = @@rowcount  	  	   	IF @LoadAvailableFilters = 1  	BEGIN  	  		CREATE TABLE #PotentialProductSpecificationAttributeIds   		(  			[ProductId] int NOT NULL,  			[SpecificationAttributeOptionId] int NOT NULL  		)  		  		 		 		 		 		INSERT INTO #PotentialProductSpecificationAttributeIds ([ProductId], [SpecificationAttributeOptionId])  		SELECT psm.ProductId, psm.SpecificationAttributeOptionId  		FROM Product_SpecificationAttribute_Mapping psm  		INNER JOIN #FilteredSpecificationAttributesToProduct fsatp on fsatp.ProductId = psm.ProductId  		INNER JOIN SpecificationAttributeOption sao ON sao.Id = psm.SpecificationAttributeOptionId  		INNER JOIN #FilteredSpecificationAttributes fsa ON fsa.AttributeId = sao.SpecificationAttributeId  		WHERE fsatp.AttributesCount = @SpecificationAttributesCount - 1 AND  		sao.SpecificationAttributeId NOT IN   		(SELECT sao.SpecificationAttributeId FROM Product_SpecificationAttribute_Mapping psm1  		INNER JOIN SpecificationAttributeOption sao1 ON sao1.Id = psm1.SpecificationAttributeOptionId  		INNER JOIN #FilteredSpecificationAttributeOptions fs ON fs.SpecificationAttributeOptionId = sao.Id  		WHERE psm1.ProductId = psm.ProductId)  		  		 		IF @ProductAttributesCount > 0  		BEGIN  			DELETE #PotentialProductSpecificationAttributeIds  			FROM #PotentialProductSpecificationAttributeIds ppsa  			INNER JOIN #ProductIdsBeforeFiltersApplied pibfa ON pibfa.ProductId = ppsa.ProductId  			WHERE   			(  				pibfa.ChildProductId = 0 AND  				(  					NOT EXISTS (SELECT NULL FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ProductId)  					OR  					(SELECT AttributesCount FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ProductId) != @ProductAttributesCount  				)  			)  			OR  			(  				pibfa.ChildProductId != 0 AND  				(  					NOT EXISTS (SELECT NULL FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ChildProductId)  					OR  					(SELECT AttributesCount FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ChildProductId) != @ProductAttributesCount  				)  			)  		END  		  		 		IF @ManufacturersCount > 0  		BEGIN  			DELETE FROM #PotentialProductSpecificationAttributeIds  			WHERE NOT EXISTS (  				SELECT NULL FROM Product_Manufacturer_Mapping [pmm]   				INNER JOIN #FilteredManufacturers [fm] ON [fm].ManufacturerId = [pmm].ManufacturerId  				WHERE [pmm].ProductId = #PotentialProductSpecificationAttributeIds.ProductId)  		END  		  		 		IF @VendorsCount > 0  		BEGIN  			DELETE FROM #PotentialProductSpecificationAttributeIds  			WHERE NOT EXISTS (  				SELECT NULL FROM Product [p]   				INNER JOIN #FilteredVendorIds [fv] ON [fv].VendorId = [p].VendorId  				WHERE [p].Id = #PotentialProductSpecificationAttributeIds.ProductId)  		END  		  		  		 		  		CREATE TABLE #FilterableSpecs   		(  			[ProductId] int NOT NULL,  			[SpecificationAttributeOptionId] int NOT NULL  		)  		  		CREATE TABLE #FilterableSpecsDistinct   		(  			[SpecificationAttributeOptionId] int NOT NULL  		)  		  		 		 		INSERT INTO #FilterableSpecs ([ProductId], [SpecificationAttributeOptionId])  		SELECT DISTINCT [psam].ProductId, [psam].SpecificationAttributeOptionId  		FROM [Product_SpecificationAttribute_Mapping] [psam] with (NOLOCK)  		WHERE [psam].[ProductId] IN (SELECT [pi].ProductId FROM #PageIndex [pi]) AND [psam].[AllowFiltering] = 1  		  		 		 		 		 		 		 		 		  		INSERT INTO #FilterableSpecs ([ProductId], [SpecificationAttributeOptionId])  		SELECT DISTINCT ProductId, SpecificationAttributeOptionId  		FROM #PotentialProductSpecificationAttributeIds  		  		INSERT INTO #FilterableSpecsDistinct ([SpecificationAttributeOptionId])  		SELECT DISTINCT SpecificationAttributeOptionId  		FROM #FilterableSpecs    		 		SELECT @FilterableSpecificationAttributeOptionIds = COALESCE(@FilterableSpecificationAttributeOptionIds + ',' , '') + CAST(SpecificationAttributeOptionId as nvarchar(4000))  		FROM #FilterableSpecsDistinct  		  		 		  		CREATE TABLE #PotentialProductVariantAttributeIds   		(  			[ProductId] int NOT NULL,  			[ProductVariantAttributeId] int NOT NULL  		)    		CREATE INDEX IX_PotentialProductVariantAttributeIds_ProductId  		ON #PotentialProductVariantAttributeIds (ProductId);  		  		 		 		 		 		   		INSERT INTO #PotentialProductVariantAttributeIds ([ProductId], [ProductVariantAttributeId])  		SELECT [ppm].ProductId, [ppm].Id  		FROM Product_ProductAttribute_Mapping [ppm]  		INNER JOIN #FilteredProductAttributesToProduct fpatp ON fpatp.ProductId = [ppm].ProductId  		INNER JOIN #FilteredProductAttributes fa ON fa.AttributeId = ppm.ProductAttributeId  		WHERE fpatp.AttributesCount = @ProductAttributesCount - 1 AND   		[ppm].Id NOT IN (SELECT ProductVariantAttributeId FROM #FilteredProductVariantAttributes)    		 		 		IF @SpecificationAttributesCount > 0  		BEGIN    			DELETE #PotentialProductVariantAttributeIds  			FROM #PotentialProductVariantAttributeIds ppva  			INNER JOIN #ProductIdsBeforeFiltersApplied pibfa ON pibfa.ProductId = ppva.ProductId OR pibfa.ChildProductId = ppva.ProductId  			WHERE   			(  				NOT EXISTS (SELECT NULL FROM #FilteredSpecificationAttributesToProduct WHERE ProductId = pibfa.ProductId)  				OR  				(SELECT AttributesCount FROM #FilteredSpecificationAttributesToProduct WHERE ProductId = pibfa.ProductId) != @SpecificationAttributesCount  			)    		END  		  		 		IF @ManufacturersCount > 0  		BEGIN  			DELETE FROM #PotentialProductVariantAttributeIds  			WHERE NOT EXISTS (  				SELECT NULL FROM Product_Manufacturer_Mapping pmm  				INNER JOIN #FilteredManufacturers fm ON fm.ManufacturerId = pmm.ManufacturerId  				INNER JOIN #ProductIdsBeforeFiltersApplied pibfa ON pibfa.ProductId = pmm.ProductId  				WHERE #PotentialProductVariantAttributeIds.ProductId = pibfa.ProductId OR #PotentialProductVariantAttributeIds.ProductId = pibfa.ChildProductId)  		END  		  		 		 		IF @VendorsCount > 0  		BEGIN  			DELETE FROM #PotentialProductVariantAttributeIds  			WHERE NOT EXISTS (  				SELECT NULL FROM Product [p]   				INNER JOIN #FilteredVendorIds [fv] ON [fv].VendorId = [p].VendorId  				INNER JOIN #ProductIdsBeforeFiltersApplied ON #PotentialProductVariantAttributeIds.ProductId = #ProductIdsBeforeFiltersApplied.ProductId  				OR #PotentialProductVariantAttributeIds.ProductId = #ProductIdsBeforeFiltersApplied.ChildProductId  				WHERE [p].Id = #ProductIdsBeforeFiltersApplied.ProductId OR [p].Id = #ProductIdsBeforeFiltersApplied.ChildProductId)  		END  		  		CREATE TABLE #FilterableProductVariantIds   		(  			[ProductId] int NOT NULL,  			[ProductVariantAttributeId] int NOT NULL  		)  		  		CREATE TABLE #FilterableProductVariantIdsDistinct   		(  			[ProductVariantAttributeId] int NOT NULL  		)  		  		 		 		INSERT INTO #FilterableProductVariantIds ([ProductId], [ProductVariantAttributeId])  		SELECT DISTINCT [ppm].ProductId, [ppm].Id  		FROM [Product_ProductAttribute_Mapping] [ppm]  		INNER JOIN #PageIndex [pi] ON [pi].ProductId = [ppm].[ProductId] OR [pi].ChildProductId = [ppm].ProductId  		  		 		INSERT INTO #FilterableProductVariantIds ([ProductId], [ProductVariantAttributeId])  		SELECT DISTINCT ProductId, ProductVariantAttributeId  		FROM #PotentialProductVariantAttributeIds  		  		INSERT INTO #FilterableProductVariantIdsDistinct ([ProductVariantAttributeId])  		SELECT DISTINCT ProductVariantAttributeId  		FROM #FilterableProductVariantIds  		  		 		SELECT @FilterableProductVariantAttributeIds = COALESCE(@FilterableProductVariantAttributeIds + ',' , '') + CAST(ProductVariantAttributeId as nvarchar(4000))  		FROM #FilterableProductVariantIdsDistinct  		  		 		  		CREATE TABLE #FilterableManufacturers   		(  			[ProductId] int NOT NULL,  			[ManufacturerId] int NOT NULL  		)  		  		CREATE TABLE #FilterableManufacturersDistinct   		(  			[ManufacturerId] int NOT NULL  		)  		  		 		 		INSERT INTO #FilterableManufacturers ([ProductId], [ManufacturerId])  		SELECT DISTINCT [pmm].ProductId, [pmm].ManufacturerId  		FROM Product_Manufacturer_Mapping [pmm]  		INNER JOIN #ProductIdsBeforeFiltersApplied ON #ProductIdsBeforeFiltersApplied.ProductId = [pmm].ProductId  		  		 		IF @SpecificationAttributesCount > 0  		BEGIN  		  			DELETE FROM #FilterableManufacturers  			FROM #FilterableManufacturers fm  			LEFT JOIN #FilteredSpecificationAttributesToProduct fsatp ON fsatp.ProductId = fm.ProductId  			WHERE fsatp.ProductId IS NULL OR fsatp.AttributesCount != @SpecificationAttributesCount  			  		END  		  		 		IF @ProductAttributesCount > 0  		BEGIN  		  			DELETE FROM #FilterableManufacturers  			FROM #FilterableManufacturers fm  			INNER JOIN #ProductIdsBeforeFiltersApplied pibfa ON pibfa.ProductId = fm.ProductId  			WHERE   			(  				pibfa.ChildProductId = 0 AND  				(  					NOT EXISTS (SELECT NULL FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ProductId)  					OR  					(SELECT AttributesCount FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ProductId) != @ProductAttributesCount  				)  			)  			OR  			(  				pibfa.ChildProductId != 0 AND  				(  					NOT EXISTS (SELECT NULL FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ChildProductId)  					OR  					(SELECT AttributesCount FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ChildProductId) != @ProductAttributesCount  				)  			)  				  		END  		  		 		IF @VendorsCount > 0  		BEGIN  		  			DELETE FROM #FilterableManufacturers  			WHERE NOT EXISTS  			(  				SELECT NULL FROM Product [p]  				INNER JOIN #FilteredVendorIds [fv] ON fv.VendorId = [p].VendorId  				WHERE [p].Id = #FilterableManufacturers.ProductId  			)  			  		END  		  		INSERT INTO #FilterableManufacturersDistinct ([ManufacturerId])  		SELECT DISTINCT ManufacturerId  		FROM #FilterableManufacturers  		  		 		SELECT @FilterableManufacturerIds = COALESCE(@FilterableManufacturerIds + ',' , '') + CAST(ManufacturerId as nvarchar(4000))  		FROM #FilterableManufacturersDistinct  		  		 		CREATE TABLE #FilterableVendors   		(  			[ProductId] int NOT NULL,  			[VendorId] int NOT NULL  		)  		  		CREATE TABLE #FilterableVendorsDistinct   		(  			[VendorId] int NOT NULL  		)  		  		 		 		INSERT INTO #FilterableVendors ([ProductId], [VendorId])  		SELECT DISTINCT [pv].Id, [pv].VendorId  		FROM Product [pv]  		INNER JOIN #ProductIdsBeforeFiltersApplied ON #ProductIdsBeforeFiltersApplied.ProductId = [pv].Id    		 		IF @SpecificationAttributesCount > 0  		BEGIN    			DELETE FROM #FilterableVendors  			FROM #FilterableVendors fv  			LEFT JOIN #FilteredSpecificationAttributesToProduct fsatp ON fsatp.ProductId = fv.ProductId  			WHERE fsatp.ProductId IS NULL OR fsatp.AttributesCount != @SpecificationAttributesCount  			  		END  		  		 		 		 		 		IF @ProductAttributesCount > 0  		BEGIN  		  			DELETE FROM #FilterableVendors  			FROM #FilterableVendors fv  			INNER JOIN #ProductIdsBeforeFiltersApplied pibfa ON pibfa.ProductId = fv.ProductId  			WHERE   			(  				pibfa.ChildProductId = 0 AND  				(  					NOT EXISTS (SELECT NULL FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ProductId)  					OR  					(SELECT AttributesCount FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ProductId) != @ProductAttributesCount  				)  			)  			OR  			(  				pibfa.ChildProductId != 0 AND  				(  					NOT EXISTS (SELECT NULL FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ChildProductId)  					OR  					(SELECT AttributesCount FROM #FilteredProductAttributesToProduct WHERE ProductId = pibfa.ChildProductId) != @ProductAttributesCount  				)  			)  				  		END  		  		 		IF @ManufacturersCount > 0  		BEGIN  		  			DELETE FROM #FilterableVendors  			WHERE NOT EXISTS  			(  				SELECT NULL FROM Product_Manufacturer_Mapping [pmm]  				INNER JOIN #FilteredManufacturers [fm] ON [fm].ManufacturerId = [pmm].ManufacturerId  				WHERE [pmm].ProductId = #FilterableVendors.ProductId  			)  			  		END  		  		INSERT INTO #FilterableVendorsDistinct ([VendorId])  		SELECT DISTINCT VendorId  		FROM #FilterableVendors    		 		SELECT @FilterableVendorIds = COALESCE(@FilterableVendorIds + ',' , '') + CAST(VendorId as nvarchar(4000))  		FROM #FilterableVendorsDistinct  		  		DROP TABLE #ProductIdsBeforeFiltersApplied  		DROP TABLE #FilteredSpecificationAttributeOptions  		DROP TABLE #FilterableSpecs  		DROP TABLE #FilteredSpecificationAttributes  		DROP TABLE #FilteredSpecificationAttributesToProduct  		DROP TABLE #FilterableSpecsDistinct  		DROP TABLE #PotentialProductSpecificationAttributeIds  		DROP TABLE #FilteredProductVariantAttributes  		DROP TABLE #FilteredProductAttributes  		DROP TABLE #FilteredProductAttributesToProduct  		DROP TABLE #FilterableProductVariantIds  		DROP TABLE #FilterableProductVariantIdsDistinct  		DROP TABLE #PotentialProductVariantAttributeIds  		DROP TABLE #FilteredManufacturers  		DROP TABLE #FilterableManufacturers  		DROP TABLE #FilterableVendors  		DROP TABLE #FilterableVendorsDistinct  		DROP TABLE #FilterableManufacturersDistinct  		   	END   	   	  	DELETE #PageIndex   	FROM #PageIndex  	LEFT OUTER JOIN (  	   SELECT MIN(IndexId) as RowId, ProductId   	   FROM #PageIndex   	   GROUP BY ProductId  	) AS KeepRows ON  	   #PageIndex.IndexId = KeepRows.RowId  	WHERE  	   KeepRows.RowId IS NULL  	     	SET @TotalRecords = @TotalRecords - @@rowcount   	   	  	  	  	  	   	CREATE TABLE #PageIndexDistinct   	(  		[IndexId] int IDENTITY (1, 1) NOT NULL,  		[ProductId] int NOT NULL  	)  	  	INSERT INTO #PageIndexDistinct ([ProductId])  	SELECT [ProductId]  	FROM #PageIndex  	ORDER BY [IndexId]  	  	IF @IsOnSaleFilterEnabled = 1  	BEGIN  		 		IF EXISTS (SELECT NULL FROM Product p   				  LEFT JOIN Product cp ON p.Id = cp.ParentGroupedProductId   				  INNER JOIN #PageIndexDistinct [pid] ON [pid].ProductId = p.Id  				  WHERE (  							(cp.Id IS NULL AND p.OldPrice > 0 AND p.Price != p.OldPrice)  							OR  							(cp.Id IS NOT NULL AND cp.OldPrice > 0 AND cp.OldPrice != cp.Price)  						)   				  )  		BEGIN  			SET @HasProductsOnSale = 1  		END  		ELSE  			SET @HasProductsOnSale = 0  	END  	  	IF @IsInStockFilterEnabled = 1  	BEGIN  	 		IF EXISTS (SELECT NULL FROM Product p   				LEFT JOIN Product cp ON p.Id = cp.ParentGroupedProductId   				INNER JOIN #PageIndexDistinct [pid] ON [pid].ProductId = p.Id  				WHERE (  						(cp.ID IS NULL  AND   							(  								(p.ManageInventoryMethodId = 0) OR  									(P.ManageInventoryMethodId = 1 AND  									(  										(p.StockQuantity > 0 AND p.UseMultipleWarehouses = 0) OR   										(EXISTS(SELECT 1 FROM ProductWarehouseInventory [pwi] WHERE	[pwi].ProductId = p.Id	AND [pwi].StockQuantity > 0 AND [pwi].StockQuantity > [pwi].ReservedQuantity) AND p.UseMultipleWarehouses = 1)  									)  								)  							)  						)  						OR  						(p.Id IS NOT NULL AND   							(  								(cp.ManageInventoryMethodId = 0) OR  								(cp.ManageInventoryMethodId = 1 AND  									(  										(cp.StockQuantity > 0 AND cp.UseMultipleWarehouses = 0) OR   										(EXISTS(SELECT 1 FROM ProductWarehouseInventory [pwi] WHERE [pwi].ProductId = cp.Id	AND [pwi].StockQuantity > 0 AND [pwi].StockQuantity > [pwi].ReservedQuantity) AND cp.UseMultipleWarehouses = 1)  									)  								)  							)  						)  					)  				)  		BEGIN  			SET @HasProductsInStock = 1  		END  		ELSE  			SET @HasProductsInStock = 0  	END    	SELECT TOP (@RowsToReturn)  		p.*  	FROM  		#PageIndexDistinct [pi]  		INNER JOIN Product p with (NOLOCK) on p.Id = [pi].[ProductId]  	WHERE  		[pi].IndexId > @PageLowerBound AND   		[pi].IndexId < @PageUpperBound  	ORDER BY  		[pi].IndexId  	  	DROP TABLE #KeywordProducts  	DROP TABLE #FilteredCategoryIds  	DROP TABLE #FilteredVendorIds  	DROP TABLE #FilteredCustomerRoleIds  	DROP TABLE #DisplayOrderTmp  	DROP TABLE #PageIndex  	DROP TABLE #PageIndexDistinct    	  END

GO
/****** Object:  StoredProcedure [dbo].[ProductTagCountLoadAll]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductTagCountLoadAll]
(
	@StoreId int
)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT pt.Id as [ProductTagId], COUNT(p.Id) as [ProductCount]
	FROM ProductTag pt with (NOLOCK)
	LEFT JOIN Product_ProductTag_Mapping pptm with (NOLOCK) ON pt.[Id] = pptm.[ProductTag_Id]
	LEFT JOIN Product p with (NOLOCK) ON pptm.[Product_Id] = p.[Id]
	WHERE
		p.[Deleted] = 0
		AND p.Published = 1
		AND (@StoreId = 0 or (p.LimitedToStores = 0 OR EXISTS (
			SELECT 1 FROM [StoreMapping] sm with (NOLOCK)
			WHERE [sm].EntityId = p.Id AND [sm].EntityName = 'Product' and [sm].StoreId=@StoreId
			)))
	GROUP BY pt.Id
	ORDER BY pt.Id
END

GO
/****** Object:  StoredProcedure [dbo].[retrieveCart]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[retrieveCart]
	-- Add the parameters for the stored procedure here
@arrayKeys nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure her
	SELECT  npr.Id Id, npr.Name Name  ,npr.Id as  ShortDescription , npr.Id  as FullDescription, npr.Price ,npr.ProductCost as Cost , npr.OldPrice , npr.StockQuantity , npr.Weight , max ('https://www.dubazzar.com/Images/Thumbs/' + 
              RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' )as 'ImagePath' 
              FROM Product npr
              Left JOIN Product_Picture_Mapping npp ON (npr.Id = npp.ProductId)  
              Left JOIN Picture npi ON (npp.PictureID = npi.ID) 
              Left Join Product_Category_Mapping PCM on PCM.ProductId =  npp.ProductId
           left join Category C on C.Id = PCM.CategoryId 
            WHERE  npp.ProductId in (Select RetVal from [dbo].[udf-Str-Parse](@arrayKeys,',')) group by npr.Name  , npr.Id , npr.Price , npr.OldPrice , npr.ProductCost, npr.StockQuantity  , npr.Weight
END



GO
/****** Object:  StoredProcedure [dbo].[RetrieveTabCar]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RetrieveTabCar] 
	-- Add the parameters for the stored procedure here
	@arrayKeys nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  npr.Id Id, npr.Name Name  ,npr.ShortDescription , npr.FullDescription , npr.Price ,npr.ProductCost as Cost , npr.OldPrice , npr.StockQuantity , npr.Weight , max ('https://www.dubazzar.com/Images/Thumbs/' + 
            RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' )as 'ImagePath' 
            FROM Product npr
            Left JOIN Product_Picture_Mapping npp ON (npr.Id = npp.ProductId)  
             Left JOIN Picture npi ON (npp.PictureID = npi.ID) 
            Left Join Product_Category_Mapping PCM on PCM.ProductId =  npp.ProductId
            left join Category C on C.Id = PCM.CategoryId 
             WHERE  npp.ProductId in (Select RetVal from [dbo].[udf-Str-Parse](@arrayKeys,',') ) group by npr.Name  , npr.Id , npr.ShortDescription , npr.FullDescription , npr.Price , npr.OldPrice , npr.ProductCost, npr.StockQuantity  , npr.Weight
END



GO
/****** Object:  StoredProcedure [dbo].[SearchProduct]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SearchProduct]
	-- Add the parameters for the stored procedure here
	@ProductName varchar(255),
	 @LastId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 20 
                 max( 'https://www.dubazzar.com/Images/Thumbs/' +
                RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' ) 
                as 'ImagePath' ,
                p.Price,p.Name as Name ,p.ProductCost as Cost  , p.Weight as Weight, p.ShortDescription ,p.FullDescription ,p.OldPrice ,p.StockQuantity ,c.Id CategoryId ,c.Name CategoryName ,p.Id Id from Product p 
                 left join [Product_Category_Mapping] pcm on pcm.ProductId = p.Id 
                right join Category c on c.Id = pcm.CategoryId 
                 left join Product_Picture_Mapping npp ON (p.Id = npp.ProductId) 
                 left JOIN Picture npi ON (npp.PictureID = npi.ID) 
                 where  p.Name like '%"+ProductName+"%' 
                 and p.Id > @LastId 
                 group by   p.Price,p.Name , p.ProductCost, p.Weight ,p.ShortDescription ,p.FullDescription ,p.OldPrice ,p.StockQuantity ,c.Id ,c.Name ,p.Id  order by p.Id
END



GO
/****** Object:  StoredProcedure [dbo].[selectcustomerpassword]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[selectcustomerpassword] 
	-- Add the parameters for the stored procedure here
	@Email nvarchar(1000), 
	@Password nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1  Customer.* ,  CustomerPassword.Password from Customer 
             join CustomerPassword ON Customer.Id = CustomerPassword.CustomerId where  Customer.Email=@Email and CustomerPassword.Password=@Password
END



GO
/****** Object:  StoredProcedure [dbo].[selectcustomerpassword2]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[selectcustomerpassword2] 
	-- Add the parameters for the stored procedure here
	@Email nvarchar(1000), 
	@Password nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1  Customer.* ,  CustomerPassword.Password from Customer 
             join CustomerPassword ON Customer.Id = CustomerPassword.CustomerId where  Customer.Email=@Email and CustomerPassword.Password=@Password
END



GO
/****** Object:  StoredProcedure [dbo].[SelectCustomerwithmail]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectCustomerwithmail]  
 
AS

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
	select * from Customer



GO
/****** Object:  StoredProcedure [dbo].[SelectExternalAuthenticationRecord]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectExternalAuthenticationRecord]  
 
AS

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
	select * from ExternalAuthenticationRecord



GO
/****** Object:  StoredProcedure [dbo].[selectfromcountry]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[selectfromcountry]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Country
END



GO
/****** Object:  StoredProcedure [dbo].[selectfrommaincategory]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[selectfrommaincategory]
	-- Add the parameters for the stored procedure here
	@Paramcatid int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 9 'https://www.dubazzar.com/Images/Thumbs/' + 
                 RIGHT('000000' + CONVERT(NVARCHAR(32),pic.ID),7) + '_' + SeoFilename + '.jpeg' as 'ImagePath', cat.*
                 FROM picture pic 
                 right join Category cat on  pic.ID = cat.PictureId
                 where  Published = 'true' and cat.ParentCategoryId = @Paramcatid
END



GO
/****** Object:  StoredProcedure [dbo].[SelectImageUrl]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectImageUrl]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 3 Url from  dbo.SS_AS_SliderImage
END



GO
/****** Object:  StoredProcedure [dbo].[selectlastID]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[selectlastID] 
	-- Add the parameters for the stored procedure here
	@FirstName varchar(255),
	@LastName varchar(255),
	 @Email varchar(255),
	  @CountryId int , @StateId int,@City varchar(255),@Address1 varchar(255),@Address2 varchar(255), @PhoneNumber varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT [dbo].[Address] ( [FirstName], [LastName], [Email], [Company], 
                    [CountryId], [StateProvinceId], [City], [Address1], 
                     [Address2], [ZipPostalCode], [PhoneNumber], [FaxNumber], [CustomAttributes], [CreatedOnUtc])
                     VALUES ( @FirstName, @LastName , @Email , '' , 
                     @CountryId , @StateId , @City, @Address1, @Address2 , 11511 , @PhoneNumber , '', NULL, GETUTCDATE()) ;  SELECT SCOPE_IDENTITY() as LastID
END



GO
/****** Object:  StoredProcedure [dbo].[SelectProductWithId]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectProductWithId]
	-- Add the parameters for the stored procedure here
	@ProductId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'https://www.dubazzar.com/Images/Thumbs/' + 
              RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' as 'ImagePath'  , npr.Id , npr.Name , npr.ShortDescription , npr.FullDescription , npr.Price , npr.OldPrice  , npr.ProductCost as Cost, npr.StockQuantity
              FROM Product npr
                LEFT JOIN Product_Picture_Mapping npp ON (npr.Id = npp.ProductId)
             LEFT JOIN Picture npi ON (npp.PictureID = npi.ID)
             WHERE  npp.ProductId= @ProductId
END



GO
/****** Object:  StoredProcedure [dbo].[Selecttop9frommaincategory]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Selecttop9frommaincategory]
	-- Add the parameters for the stored procedure here
	@ParentCategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 9 'https://www.dubazzar.com/Images/Thumbs/' +
                + RIGHT('000000' + CONVERT(NVARCHAR(32),pic.ID),7) + '_' + SeoFilename + '.jpeg' as 'ImagePath', cat.*
                FROM picture pic 
                 right join Category cat on  pic.ID = cat.PictureId
              where  Published = 'true' and cat.ParentCategoryId = @ParentCategoryId
			  

END



GO
/****** Object:  StoredProcedure [dbo].[SelectTopSixNewArrivalProduct]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectTopSixNewArrivalProduct] 
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 6  
                 max( 'https://www.dubazzar.com/Images/Thumbs/'+  
                 RIGHT('0000000' + CONVERT(NVARCHAR(32),npi.ID),7) + '_' + SeoFilename + '.jpeg' ) 
                 as 'ImagePath' , 
                 p.Price,p.Name as Name , c.Id CategoryId ,c.Name CategoryName ,p.Id Id from Product p 
                 left join [Product_Category_Mapping] pcm on pcm.ProductId = p.Id 
                 left join Category c on c.Id = pcm.CategoryId 
                 jOIN Product_Picture_Mapping npp ON (p.Id = npp.ProductId) 
                  JOIN Picture npi ON (npp.PictureID = npi.ID)  where p.Price > 0 
                group by   p.Price,p.Name , c.Id ,c.Name ,p.Id
END



GO
/****** Object:  StoredProcedure [dbo].[SelectTopTenRecordfromproduct]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[SelectTopTenRecordfromproduct]  
 
AS

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- Insert statements for procedure here
	select top 10  Id , Name from Product
	


GO
/****** Object:  StoredProcedure [dbo].[SelectwithCountryID]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectwithCountryID]
	-- Add the parameters for the stored procedure here
	@CountryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select cou.* , sta.Name as StateName , sta.id as StateID 
                   from Country cou 
                  left join StateProvince sta on cou.id=sta.CountryId 
		         where cou.id=@CountryId and cou.published = 'true'
END



GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomerAddress]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCustomerAddress]
	-- Add the parameters for the stored procedure here
	@customerid int , @Addressid int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE customer set [BillingAddress_Id] =  @Addressid  ,[ShippingAddress_Id] =  @Addressid   where customer.id = @CustomerId
END



GO
/****** Object:  StoredProcedure [dbo].[UpdatePictureUrl]    Script Date: 7/4/2019 4:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePictureUrl]
	-- Add the parameters for the stored procedure here
	@des VARCHAR(255),
	@catID int  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update Category set Description= @des where Id = @catID
END



GO
USE [master]
GO
ALTER DATABASE [pavillion_v4] SET  READ_WRITE 
GO
