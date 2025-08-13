USE [AVI_HRMS]
GO

/****** Object:  Table [dbo].[EmployeeAttendance]    Script Date: 8/13/2025 2:56:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EmployeeAttendance](
	[EmpID] [varchar](50) NOT NULL,
	[AttendanceDate] [date] NOT NULL,
	[LoginTime] [datetime] NULL,
	[LogoutTime] [datetime] NULL,
	[LeaveStatus] [char](1) NOT NULL,
	[Attendance] [char](1) NOT NULL,
	[Working_Hrs] [decimal](5, 2) NULL,
 CONSTRAINT [PK_EmployeeAttendance] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC,
	[AttendanceDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


