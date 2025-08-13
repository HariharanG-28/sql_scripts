USE [AVI_HRMS]
GO

/****** Object:  Table [dbo].[employee_info]    Script Date: 8/13/2025 2:55:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[employee_info](
	[emp_id] [varchar](10) NOT NULL,
	[emp_name] [nvarchar](110) NOT NULL,
	[emp_address] [nvarchar](200) NULL,
	[personal_mail_id] [varchar](254) NULL,
	[official_mail_id] [varchar](254) NULL,
	[mobile_no] [varchar](15) NULL,
	[is_active] [bit] NOT NULL,
	[date_of_joining] [date] NULL,
	[date_of_leaving] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[employee_info] ADD  DEFAULT ((1)) FOR [is_active]
GO

ALTER TABLE [dbo].[employee_info] ADD  DEFAULT (getdate()) FOR [date_of_joining]
GO


