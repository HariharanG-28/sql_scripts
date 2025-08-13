ALTER PROC attence_sp
    @empid      VARCHAR(50),
    @logintime  DATETIME = NULL,
    @logouttime DATETIME = NULL
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM attendance
        WHERE empid = @empid
          AND CAST(logintime AS DATE) = CAST(GETDATE() AS DATE)
    )
    BEGIN
        DECLARE @leavestatus VARCHAR(50);
        DECLARE @attendance  VARCHAR(50);

        IF @logintime IS NULL
            SET @leavestatus = 'Y';
        ELSE
            SET @leavestatus = 'N';

        IF @logintime IS NULL
            SET @attendance = 'N';
        ELSE
            SET @attendance = 'Y';

        INSERT INTO attendance (empid, logintime, logouttime, leavestatus, attendance, working_hrs)
        VALUES (@empid, @logintime, @logouttime, @leavestatus, @attendance, NULL);
    END
    ELSE
    BEGIN
        UPDATE attendance
        SET logouttime = @logouttime,
            working_hrs = DATEDIFF(MINUTE , logintime, @logouttime)/60.0 
        WHERE empid = @empid
          AND CAST(logintime AS DATE) = CAST(GETDATE() AS DATE);
    END
	SELECT 
        a.empid,
        e.empname,
        a.logintime,
        a.logouttime,
        a.leavestatus,
        a.Attendance,
        a.working_hrs
    FROM attendance a
    INNER JOIN employee_info e ON a.empid = e.empid
    WHERE a.empid = @empid
     AND CAST(logintime AS DATE) = CAST(GETDATE() AS DATE)
END;

