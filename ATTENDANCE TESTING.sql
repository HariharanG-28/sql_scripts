CREATE TABLE [dbo].[EmployeeAttendance](
	[EmpID] [varchar](50) NOT NULL,
	[AttendanceDate] [date] NOT NULL,
	[LoginTime] [datetime] NULL,
	[LogoutTime] [datetime] NULL,
	[LeaveStatus] [char](1) NOT NULL,
	[Attendance] [char](1) NOT NULL,
	[Working_Hrs] [decimal](5, 2) NULL
	)

ALTER  PROCEDURE [dbo].[attendance_entry]
    @EmpID         VARCHAR(50),   
    @LoginTime     DATETIME = NULL,
    @LogoutTime    DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AttendanceDate DATE = CAST(GETDATE() AS DATE);

    -- Convert only time part into today's datetime
    IF @LoginTime IS NOT NULL
        SET @LoginTime = DATEADD(SECOND, DATEDIFF(SECOND, CAST(@LoginTime AS DATE), @LoginTime), CAST(@AttendanceDate AS DATETIME));

    IF @LogoutTime IS NOT NULL
        SET @LogoutTime = DATEADD(SECOND, DATEDIFF(SECOND, CAST(@LogoutTime AS DATE), @LogoutTime), CAST(@AttendanceDate AS DATETIME));

    -- INSERT CASE
    IF NOT EXISTS (
        SELECT 1 
        FROM EmployeeAttendance
        WHERE EmpID = @EmpID
          AND AttendanceDate = @AttendanceDate
    )
    BEGIN
        INSERT INTO EmployeeAttendance (
            EmpID, AttendanceDate, LoginTime, LogoutTime, LeaveStatus, Attendance, Working_Hrs
        )
        VALUES (
            @EmpID, 
            @AttendanceDate, 
            @LoginTime, 
            @LogoutTime, 
            CASE WHEN @LoginTime IS NULL THEN 'Y' ELSE 'N' END,  -- LeaveStatus
            CASE WHEN @LoginTime IS NULL THEN 'N' ELSE 'Y' END,  -- Attendance
            CASE 
                WHEN @LoginTime IS NOT NULL AND @LogoutTime IS NOT NULL 
                THEN DATEDIFF(MINUTE, @LoginTime, @LogoutTime) / 60.0
                ELSE NULL
            END
        );
    END
    ELSE
    BEGIN
        UPDATE EmployeeAttendance
        SET LoginTime   = COALESCE(@LoginTime, LoginTime),
            LogoutTime  = COALESCE(@LogoutTime, LogoutTime),
            Working_Hrs = CASE 
                            WHEN @LogoutTime IS NOT NULL AND COALESCE(@LoginTime, LoginTime) IS NOT NULL
                            THEN DATEDIFF(MINUTE, COALESCE(@LoginTime, LoginTime), @LogoutTime) / 60.0
                            ELSE Working_Hrs
                          END,
            -- Only set LeaveStatus & Attendance if LoginTime is NULL in the record
            LeaveStatus = CASE 
                            WHEN LoginTime IS NULL AND COALESCE(@LoginTime, LoginTime) IS NULL THEN 'Y'
                            ELSE 'N'
                          END,
            Attendance  = CASE 
                            WHEN LoginTime IS NULL AND COALESCE(@LoginTime, LoginTime) IS NULL THEN 'N'
                            ELSE 'Y'
                          END
        WHERE EmpID = @EmpID
          AND AttendanceDate = @AttendanceDate;
    END

    -- Return records for that employee
    SELECT EmpID, 
           AttendanceDate,
           LoginTime, 
           LogoutTime, 
           LeaveStatus, 
           Attendance, 
           Working_Hrs
    FROM EmployeeAttendance
    WHERE EmpID = @EmpID
    ORDER BY AttendanceDate ASC;
END



	Select * 
from dbo.EmployeeAttendance

Truncate table dbo.EmployeeAttendance

-- Morning login entries (only LoginTime)
EXEC attendance_entry @EmpID = 'AVI01', @LoginTime = '09:00', @LogoutTime = NULL;
EXEC attendance_entry @EmpID = 'AVI02', @LoginTime = '09:15', @LogoutTime = NULL;
EXEC attendance_entry @EmpID = 'AVI03', @LoginTime = '08:50', @LogoutTime = NULL;
EXEC attendance_entry @EmpID = 'AVI04', @LoginTime = '09:10', @LogoutTime = NULL;
EXEC attendance_entry @EmpID = 'AVI05', @LoginTime = '09:05', @LogoutTime = NULL;
EXEC attendance_entry @EmpID = 'AVI06', @LoginTime = '09:30', @LogoutTime = NULL;

-- Evening logout updates (only LogoutTime)
EXEC attendance_entry @EmpID = 'AVI01', @LoginTime = NULL, @LogoutTime = '18:00';
EXEC attendance_entry @EmpID = 'AVI02', @LoginTime = NULL, @LogoutTime = '17:45';
EXEC attendance_entry @EmpID = 'AVI03', @LoginTime = NULL, @LogoutTime = '18:10';
EXEC attendance_entry @EmpID = 'AVI04', @LoginTime = NULL, @LogoutTime = '17:55';
EXEC attendance_entry @EmpID = 'AVI05', @LoginTime = NULL, @LogoutTime = '18:05';
EXEC attendance_entry @EmpID = 'AVI06', @LoginTime = NULL, @LogoutTime = '17:50';