USE [master]
GO
/****** Object:  Database [RoleAdmin]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE DATABASE [RoleAdmin]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RoleAdmin', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\RoleAdmin.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'RoleAdmin_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\RoleAdmin_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [RoleAdmin] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RoleAdmin].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RoleAdmin] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [RoleAdmin] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [RoleAdmin] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [RoleAdmin] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [RoleAdmin] SET ARITHABORT OFF 
GO
ALTER DATABASE [RoleAdmin] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RoleAdmin] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RoleAdmin] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RoleAdmin] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RoleAdmin] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [RoleAdmin] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [RoleAdmin] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RoleAdmin] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [RoleAdmin] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RoleAdmin] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RoleAdmin] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RoleAdmin] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RoleAdmin] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RoleAdmin] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RoleAdmin] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RoleAdmin] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RoleAdmin] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RoleAdmin] SET RECOVERY FULL 
GO
ALTER DATABASE [RoleAdmin] SET  MULTI_USER 
GO
ALTER DATABASE [RoleAdmin] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RoleAdmin] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RoleAdmin] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RoleAdmin] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [RoleAdmin] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'RoleAdmin', N'ON'
GO
USE [RoleAdmin]
GO
/****** Object:  User [NT Service\MSSQLSERVER]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE USER [NT Service\MSSQLSERVER] FOR LOGIN [NT Service\MSSQLSERVER] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NT AUTHORITY\SYSTEM]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE USER [NT AUTHORITY\SYSTEM] FOR LOGIN [NT AUTHORITY\SYSTEM] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [NT AUTHORITY\NETWORK SERVICE]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE USER [NT AUTHORITY\NETWORK SERVICE] FOR LOGIN [NT AUTHORITY\NETWORK SERVICE] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [NT Service\MSSQLSERVER]
GO
ALTER ROLE [db_owner] ADD MEMBER [NT AUTHORITY\SYSTEM]
GO
ALTER ROLE [db_owner] ADD MEMBER [NT AUTHORITY\NETWORK SERVICE]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetUserMenuList]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetUserMenuList]
(	
	-- Add the parameters for the function here	
	@UserId nvarchar(450)
)
RETURNS @MenuList TABLE  
(
	-- Add the column definitions for the TABLE variable here
	[ID] int ,
	[ParentID] int,
	[Name] varchar(100),
	[URL] nvarchar(max),
	[isActive] int,
	[Style] nvarchar(max),
	[FileName] nvarchar(50)
)
AS
BEGIN
	-- Add the SELECT statement with parameter references here	
	
	INSERT INTO @MenuList([ID],[ParentID],[Name],[URL],[isActive],[Style],[FileName])
	
	SELECT [ID],[ParentID],[Name],[URL],[isActive],[Style],[FileName]
	FROM [dbo].[MenuMaster]
	WHERE ID in (
			SELECT MenuId from dbo.Menu_Role where UserId = @UserId   ---for userID specific
			UNION SELECT MenuId from dbo.Menu_Role where RoleId in (SELECT RoleId from AspNetUserRoles where UserId = @UserId)
	) AND isVisible = 1; 				
RETURN
END

GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LastLogIn] [datetime] NULL,
	[isEnabled] [bit] NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Menu_Role]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu_Role](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MenuId] [int] NULL,
	[UserId] [nvarchar](450) NULL,
	[RoleId] [nvarchar](450) NULL,
 CONSTRAINT [PK_Menu_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuMaster]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MenuMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NULL,
	[Name] [varchar](100) NULL,
	[URL] [nvarchar](max) NULL,
	[isActive] [int] NOT NULL CONSTRAINT [DF_MenuMaster_isActive]  DEFAULT ((1)),
	[Style] [nvarchar](max) NULL,
	[FileName] [nvarchar](50) NULL,
	[isVisible] [bit] NULL,
 CONSTRAINT [PK_MenuMaster] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetMenuForRole]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetMenuForRole]
(	
	-- Add the parameters for the function here	
	@Role int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT MenuMaster.ID, ParentID, Name, URL, isActive, Style, [FileName] FROM MenuMaster INNER JOIN Menu_Role 
	ON MenuMaster.ID = Menu_Role.MenuId 
	WHERE Menu_Role.RoleId = @Role
)

GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20190711043541_initial', N'2.0.0-rtm-26452')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240618173113_EmptyMigration', N'2.0.0-rtm-26452')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240618173238_empty', N'2.0.0-rtm-26452')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240618173326_em', N'2.0.0-rtm-26452')
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName]) VALUES (N'1', NULL, N'OPD/Doctor', N'OPD/Doctor')
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName]) VALUES (N'2', NULL, N'Laboratory', N'Laboratory')
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName]) VALUES (N'3', NULL, N'Imaging/Ultrasound etc', N'Imaging/Ultrasound etc')
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName]) VALUES (N'4', NULL, N'Nurse', N'Nurse')
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName]) VALUES (N'5', NULL, N'Reception', N'Reception')
INSERT [dbo].[AspNetRoles] ([Id], [ConcurrencyStamp], [Name], [NormalizedName]) VALUES (N'7', NULL, N'super', N'Administrator')
SET IDENTITY_INSERT [dbo].[AspNetUserRoles] ON 

INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'10', N'7', 5)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'11', N'4', 6)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'1', N'1', 7)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'7', N'2', 8)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'12', N'5', 1005)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'13', N'1', 1006)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'14', N'4', 1007)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'4', N'5', 1008)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'2', N'2', 1009)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'15', N'6', 1010)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'16', N'6', 1011)
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId], [ID]) VALUES (N'17', N'6', 1012)
SET IDENTITY_INSERT [dbo].[AspNetUserRoles] OFF
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'13f2f61f-c3f8-4b22-bf46-9475c1e8a15f', 0, NULL, N'alem@gmail.com', 0, 1, NULL, NULL, NULL, N'AN8NGd8LxQWT7Gel+YkoGwY0zqMgOWU7IXrHN/IRRJacisnzJRimkf1VuyCAQ5lk3w==', NULL, 0, N'1e85ccad-5e17-4c9d-9751-c13e419dc3a1', 0, N'alem', NULL, NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'2534a46b-80b3-4330-bc92-2cd81ac18b9c', 0, NULL, N'aman@gmail.com', 0, 1, NULL, NULL, NULL, N'AAJD8/EPLOLCEcgm6GNYGEw7zOoIhTaLO3rJe3Q0i8jY6+WZDDmzbcRnzG6lEoFlGA==', NULL, 0, N'e26e3fca-5d86-4e32-a139-7dd9389a4934', 0, N'aman', NULL, NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'26f9053f-a2bc-4ef4-a873-5b2abf683ae7', 0, NULL, N'hamza@gmail.com', 0, 1, NULL, NULL, NULL, N'AMo3czSZVsJ8xD0FEY98QVcWCHaz1nX+IdxwpD6+NDrUgxfvHyQ7dMoVdw3Qfu7fYg==', NULL, 0, N'675dd001-4c0a-4e52-a0a7-0c27209d5f5b', 0, N'hamza', NULL, CAST(N'2024-06-30 19:15:54.443' AS DateTime), 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'61455836-eddf-476e-bdd5-f0c4cde42556', 0, NULL, N'hayat@gmail.com', 0, 1, NULL, NULL, NULL, N'AJKARoyRTQqQ2ugewA2n71eWtxaDt1wFrSvLnxDlXprzPpS+fn3f9qXOQDKVb2AQkw==', NULL, 0, N'0466a779-c774-4225-80a8-3e5368329e7e', 0, N'hayat', NULL, CAST(N'2024-06-30 21:09:31.167' AS DateTime), 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'86845af9-6508-4ff1-a2be-9fa647921f1f', 0, NULL, N'almaz@gmail.com', 0, 1, NULL, NULL, NULL, N'AJwD9+P3qRyELDX2v9j7duWonO1xO2v2HdD3GtEPh9+jbyv21ZGTi4Nmv/+nq3q00Q==', NULL, 0, N'34e0b916-4244-4496-9ece-3dd58ec09383', 0, N'almaz', NULL, NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'8c1322a3-ff31-4b41-a825-562535887771', 0, NULL, N'alem@gmail.com', 0, 1, NULL, N'tofik@hawi.com', NULL, N'ALa0SK4KlOtAXwvycn868iZCAEilVVoZhXRYalgtrvJFBe3BNTWCgfiFOaMQyMBV3w==', NULL, 0, N'9cfd0329-29df-4231-80e2-bee48e7078ef', 0, N'tofik', NULL, CAST(N'2024-07-01 07:46:39.297' AS DateTime), 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'a4880f84-15f9-47e4-bd1d-9efd85a2add9', 0, NULL, N'ayte@gmail.ccm', 0, 1, NULL, NULL, NULL, N'AGcz/c5KhzveHT7wZc9pZk94vmRF42PZQT3rbbNqiDtnht8gpBBA6pTt5bl3TRCaMA==', NULL, 0, N'225de05a-ee65-48fa-ac8e-78e56a3bd761', 0, N'aytenew', NULL, NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'c052d996-b124-463d-b2c8-5cd4f58de53c', 0, NULL, N'eliasali@kiya-tech.com', 0, 1, NULL, NULL, NULL, N'AMmFauU6/wobhbWsg49acjN749gLTf0U3Y/OWXKDBK/UdablE0s6xDoWOmAKLN9Faw==', NULL, 0, N'87d33de3-ea40-4c56-a8be-95dac951a66f', 0, N'basitN', NULL, NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'c2076ce2-f1ab-4a87-9cae-96c1539d3433', 0, NULL, N'altaseb@gmail.com', 0, 1, NULL, NULL, NULL, N'AJPsBKRuN9ofRxBaZnfpe+N1h3F153u63RpdGAkpNjGDygCZxgELenbvK3Eecb5Mkg==', NULL, 0, N'01b47c5e-9af5-4b32-95c7-c744f78dbd23', 0, N'altaseb', NULL, NULL, 0)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'ddbcc74f-f585-4a73-b308-d06895af5cb0', 0, NULL, N'zewdu@gmail.ccm', 0, 1, NULL, NULL, NULL, N'ADEJOX4xqgfOur8fHwbNfMAc88VK7Yu+e5Br2FWTYGIGJeO2WXkIe9zrxlKGXhhRUg==', NULL, 0, N'7ff7a787-4d41-46ec-b6e8-dab8b4098d64', 0, N'zewdu', NULL, CAST(N'2024-06-30 19:15:31.347' AS DateTime), 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'eac98bbf-a250-48f5-b42a-7e29483c2a8f', 0, NULL, N'yimam@gmail.com', 0, 1, NULL, NULL, NULL, N'AGOEjSjdH4BBuYj9cuOWuis9mncQXjDOxSUoCYAYmPvOjLAkdsrM9UqHzL9HRbME+g==', NULL, 0, N'7b0dfd6b-36e0-42d4-b2fd-501b6bc1c219', 0, N'yimam', NULL, CAST(N'2024-06-30 19:22:53.853' AS DateTime), 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'eaca3178-76bf-4271-9625-89c7337180cb', 0, NULL, N'abdulbasit@kiya-tech.com', 0, 1, NULL, NULL, NULL, N'AKopPfarvJVNLwc7VUu+9M0EbbRUorTuQbkAdpP6wyvxEc12AzMfKuTXRoUe0HL4mA==', NULL, 0, N'c7da4ac7-c83b-41ce-9c86-d154f4959274', 0, N'basit', NULL, CAST(N'2024-07-01 07:46:09.590' AS DateTime), 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'f2b56c86-81b8-4cff-867f-76610f4739a2', 0, NULL, N'ethiopia@gmail.com', 0, 1, NULL, NULL, NULL, N'AIDfLdBEasaYbLOp1OLUJ7b/nlkIHkrwnIlTlI0SQvSiAYiA8AOO+HiCVdVRdwwiuw==', NULL, 0, N'582b2a45-b147-4d29-9fec-2e6fd3da1c36', 0, N'ethiopia', NULL, NULL, 1)
INSERT [dbo].[AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Email], [EmailConfirmed], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName], [LockoutEndDateUtc], [LastLogIn], [isEnabled]) VALUES (N'f9df0b7d-e6ef-4b87-8359-6910415289fe', 0, NULL, N'dagi@gmail.com', 0, 1, NULL, NULL, NULL, N'AKQYK5Jr2IAidOyhJV3LrnnNKxAb9Lf19PKomKTaLgFm/1iVZ2UTiY3co3tG4gy5LQ==', NULL, 0, N'974f250f-f0f7-465a-8b70-f803b4cfba1a', 0, N'dagi', NULL, CAST(N'2024-06-30 21:32:49.083' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Menu_Role] ON 

INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (17, 1, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (18, 2, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (19, 3, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (20, 4, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (21, 5, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (22, 6, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (23, 7, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (24, 8, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (25, 9, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (26, 10, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (27, 11, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (28, 12, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (29, 13, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (31, 15, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (32, 16, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (33, 17, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (34, 30, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (35, 31, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (36, 1, NULL, N'2')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (37, 8, NULL, N'2')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (38, 9, NULL, N'2')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (39, 22, NULL, N'2')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (40, 23, NULL, N'2')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (41, 1, NULL, N'3')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (42, 8, NULL, N'3')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (43, 10, NULL, N'3')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (44, 24, NULL, N'3')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (45, 25, NULL, N'3')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (46, 1, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (47, 8, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (48, 11, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (49, 12, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (50, 15, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (51, 26, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (52, 27, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (53, 13, NULL, N'4')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (54, 1, NULL, N'5')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (55, 13, NULL, N'5')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (56, 14, NULL, N'5')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (57, 15, NULL, N'5')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (58, 28, NULL, N'5')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (59, 29, NULL, N'5')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (60, 1, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (61, 2, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (62, 4, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (63, 5, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (64, 6, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (65, 7, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (66, 8, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (67, 9, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (68, 10, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (69, 11, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (70, 12, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (71, 13, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (72, 14, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (73, 15, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (74, 16, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (75, 17, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (76, 18, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (77, 19, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (78, 20, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (79, 21, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (80, 22, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (81, 23, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (82, 24, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (83, 25, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (84, 26, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (85, 27, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (86, 28, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (87, 29, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (88, 30, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (89, 31, NULL, N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (90, 32, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (91, 33, NULL, N'1')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (114, 33, N'1', N'7')
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (122, 26, N'1', NULL)
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (123, 27, N'1', NULL)
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (124, 26, N'3', NULL)
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (125, 27, N'3', NULL)
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (126, 28, N'3', NULL)
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (127, 29, N'3', NULL)
INSERT [dbo].[Menu_Role] ([Id], [MenuId], [UserId], [RoleId]) VALUES (1094, 30, N'1', NULL)
SET IDENTITY_INSERT [dbo].[Menu_Role] OFF
SET IDENTITY_INSERT [dbo].[MenuMaster] ON 

INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (1, NULL, N'Dashboard', NULL, 1, NULL, NULL, 0)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (2, NULL, N'Doctor', N'/', 1, N'nav-icon fas fa-user-md', NULL, 0)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (4, NULL, N'Orders', N'/Orderlab', 1, N'nav-icon fas fa-solid fa-microscope', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (5, 4, N'Order Ultrasound', N'/Ulrasound', 1, N'n', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (6, 4, N'Order Injection', N'/orderColor', 1, N'green', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (7, 4, N'Order Prescription', N'/Account/roleManage', 1, N'nav-icon fas fa-tachometer-alt', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (8, NULL, N'Order History', N'#', 1, N'nav-icon fa-solid fa-notes-medical', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (9, 8, N'Lab History', N'/Account/roleManage', 1, N'nav-icon fas fa-tachometer-alt', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (10, 8, N'Imaging History', N'/Account/roleManage', 1, N'nav-icon fas fa-tachometer-alt', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (11, 8, N'Injection History', N'/Account/roleManage', 1, N'nav-icon fas fa-tachometer-alt', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (12, 8, N'Prescription History', NULL, 1, N'red', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (13, NULL, N'Patient', NULL, 1, N'nav-icon fas fa-solid fa-hospital-user', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (14, 13, N'Register New', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (15, 13, N'Search', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (16, 13, N'History', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (17, 13, N'Examination', N'#', 1, N'nav-icon fas fa-hospital-user', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (18, NULL, N'User Management', N'/userManager', 1, N'nav-icon fas fa-user', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (19, 18, N'User List', N'/Admin/registerStaff', 1, N'nav-icon fas fa-file', N'registerStaff', 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (20, 18, N'User & Role', N'/Admin/roleManage', 1, N'red', N'roleManage', 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (21, 18, N'Reset Password', N'/SerchP', 1, N'red', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (22, NULL, N'Labratory', N'#', 1, N'nav-icon fas fa-flask', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (23, 22, N'Process Lab Order', N'/LabOrder', 1, N'red', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (24, NULL, N'Imaging', NULL, 1, N'nav-icon fas fa-solid fa-x-ray', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (25, 24, N'Process Imaging', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (26, NULL, N'Nurse', NULL, 1, N'nav-icon fas fa-solid fa-user-nurse', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (27, 26, N'Process Injection ', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (28, NULL, N'Reception', NULL, 1, N'nav-icon fas fa-solid fa-file-medical', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (29, 28, N'Confirm Payment', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (30, NULL, N'Appointment', NULL, 1, N'nav-icon fas fa-solid fa-calendar ', NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (31, 30, N'Set Appointment', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (32, 4, N'Order Laboratory', NULL, 1, NULL, NULL, 1)
INSERT [dbo].[MenuMaster] ([ID], [ParentID], [Name], [URL], [isActive], [Style], [FileName], [isVisible]) VALUES (33, 30, N'Appointment History', NULL, 1, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[MenuMaster] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [RoleNameIndex]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [EmailIndex]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserName-20240627-023241]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserName-20240627-023241] ON [dbo].[AspNetUsers]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserNameIndex]    Script Date: 7/1/2024 12:17:22 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Menu_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_Menu_Role_AspNetRoles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[Menu_Role] NOCHECK CONSTRAINT [FK_Menu_Role_AspNetRoles]
GO
ALTER TABLE [dbo].[Menu_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_Menu_Role_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Menu_Role] NOCHECK CONSTRAINT [FK_Menu_Role_AspNetUsers]
GO
/****** Object:  StoredProcedure [dbo].[spGetOtherMenuList]    Script Date: 7/1/2024 12:17:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spGetOtherMenuList]
(
	@UserId nvarchar(450),
	@RoleId int
)
as
begin
	begin try			
		
		if(@UserId = 0 OR @RoleId =0)
			return;

		begin try
			CREATE TABLE #T (ID int, ParentID int, Name varchar(100), UserId int);  --create temporay table and store the menus result
		end try
		begin catch
		-- table is already there!
			truncate table #T;
		end catch

		INSERT INTO #T(ID, ParentID, Name, UserId)	
		-- get menus out of his role but with his ID
		SELECT ID, ParentID, Name, @UserId AS UserId FROM MenuMaster 
		WHERE ID IN
		(
			SELECT  Menu_Role.MenuId FROM  Menu_Role
			WHERE Menu_Role.UserId = @UserId
		)
		UNION  
		-- now get menus out of his role and not his ID
		SELECT ID,ParentID, Name, NULL AS UserId FROM MenuMaster 
		WHERE ID NOT IN
		(	
			SELECT DISTINCT MenuId FROM Menu_Role WHERE RoleId = @RoleId--his role accesses
		)
		AND ID NOT IN
		(	
			SELECT  Menu_Role.MenuId FROM  Menu_Role
			WHERE Menu_Role.UserId = @UserId
		)
	
		--* NOW add the parents for those with parent id and is not in the list
		INSERT INTO #T(ID, ParentID, Name, UserId)	
		SELECT ID, ParentID, Name, NULL FROM MenuMaster 
		WHERE ID NOT IN (SELECT ID FROM #T)
		AND ID IN (SELECT ParentID FROM #T)
		
		SELECT ID, ParentID, Name, UserId FROM #T ORDER BY ID, ParentID; 
	end try
	BEGIN CATCH     
		THROW;
	END CATCH;  
end


GO
USE [master]
GO
ALTER DATABASE [RoleAdmin] SET  READ_WRITE 
GO
