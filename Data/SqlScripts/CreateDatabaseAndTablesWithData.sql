USE [master] 
GO 

SELECT 'KILL ' + CAST(session_id AS VARCHAR(10)) AS 'SQL Command', 
login_name as 'Login'
FROM sys.dm_exec_sessions
WHERE is_user_process = 1
AND database_id = DB_ID('AccountBalance'); 
GO

/****** Object:  Database [AccountBalance]    Script Date: 12/03/2021 12:33:34 PM ******/
DROP DATABASE IF EXISTS [AccountBalance]
GO

/****** Object:  Database [AccountBalance]    Script Date: 12/03/2021 12:33:34 PM ******/
CREATE DATABASE [AccountBalance]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AccountBalance', FILENAME = N'C:\Users\meteorosz\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\AccountBalance.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AccountBalance_log', FILENAME = N'C:\Users\meteorosz\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\AccountBalance.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AccountBalance].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [AccountBalance] SET ANSI_NULL_DEFAULT ON 
GO

ALTER DATABASE [AccountBalance] SET ANSI_NULLS ON 
GO

ALTER DATABASE [AccountBalance] SET ANSI_PADDING ON 
GO

ALTER DATABASE [AccountBalance] SET ANSI_WARNINGS ON 
GO

ALTER DATABASE [AccountBalance] SET ARITHABORT ON 
GO

ALTER DATABASE [AccountBalance] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [AccountBalance] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [AccountBalance] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [AccountBalance] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [AccountBalance] SET CURSOR_DEFAULT  LOCAL 
GO

ALTER DATABASE [AccountBalance] SET CONCAT_NULL_YIELDS_NULL ON 
GO

ALTER DATABASE [AccountBalance] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [AccountBalance] SET QUOTED_IDENTIFIER ON 
GO

ALTER DATABASE [AccountBalance] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [AccountBalance] SET  DISABLE_BROKER 
GO

ALTER DATABASE [AccountBalance] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [AccountBalance] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [AccountBalance] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [AccountBalance] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [AccountBalance] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [AccountBalance] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [AccountBalance] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [AccountBalance] SET RECOVERY FULL 
GO

ALTER DATABASE [AccountBalance] SET  MULTI_USER 
GO

ALTER DATABASE [AccountBalance] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [AccountBalance] SET DB_CHAINING OFF 
GO

ALTER DATABASE [AccountBalance] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [AccountBalance] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [AccountBalance] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [AccountBalance] SET QUERY_STORE = OFF
GO

USE [AccountBalance]
GO

ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO

ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO

ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

ALTER DATABASE [AccountBalance] SET  READ_WRITE 
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Status]') AND type in (N'U'))
DROP TABLE [dbo].[Status]
GO

CREATE TABLE [dbo].[Status](
	[Id] [int] NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[Status](
    [Id], [Description]
) VALUES (
    0, 'Open'
)
INSERT INTO [dbo].[Status](
    [Id], [Description]
) VALUES (
    1, 'Closed'
)
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
DROP TABLE [dbo].[Payment]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account]') AND type in (N'U'))
DROP TABLE [dbo].[Account]
GO

CREATE TABLE [dbo].[Account](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountName] [nvarchar](500) NOT NULL,
	[Status] [int] NOT NULL,
    [Comment] [nvarchar](500) NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [LastModifiedDateTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[Account] ADD DEFAULT (getdate()) FOR [CreatedDateTime]
GO
ALTER TABLE [dbo].[Account] ADD DEFAULT (getdate()) FOR [LastModifiedDateTime]
GO

CREATE TABLE [dbo].[Payment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Amount] [decimal](18, 0) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[AccountId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Payment] ADD  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [FK_Payment_Account] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([Id])
GO
ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [FK_Payment_Account]
GO

INSERT INTO [dbo].[Account](
      [AccountName]
      ,[Status]
      ,[Comment])
  
  VALUES ('Tim', 1, 'Account automatically closed')
GO

INSERT INTO [dbo].[Payment](
    [Amount]
    ,[AccountId]
    ,[CreatedDateTime]
)
VALUES (
    100
    ,1
    ,'2021-01-01 08:00:00.000'
)
GO
INSERT INTO [dbo].[Payment](
    [Amount]
    ,[AccountId]
    ,[CreatedDateTime]
)
VALUES (
    150
    ,1
    ,'2021-02-01 08:00:00.000'
)
GO
INSERT INTO [dbo].[Payment](
    [Amount]
    ,[AccountId]
    ,[CreatedDateTime]
)
VALUES (
    -20
    ,1
    ,'2021-03-01 08:00:00.000'
)