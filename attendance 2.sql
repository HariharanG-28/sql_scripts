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
            SET @leavestatus = 'Y'
        ELSE
            SET @leavestatus = 'N'

        IF @logintime IS NULL
            SET @attendance = 'N'
        ELSE
            SET @attendance = 'Y'

        INSERT INTO attendance (empid, logintime, logouttime, leavestatus, attendance, working_hrs)
        VALUES (@empid, @logintime, @logouttime, @leavestatus, @attendance, NULL)
    END
    ELSE
    BEGIN
        UPDATE attendance
        SET logouttime = @logouttime,
            working_hrs = DATEDIFF(MINUTE, logintime, @logouttime)/60.0 
        WHERE empid = @empid
          AND CAST(logintime AS DATE) = CAST(GETDATE() AS DATE);
    END
END;


execute attence_sp @empid = 'AVI210',
	@logintime = '2025-08-12 09:00:00',
    @logouttime = null

execute attence_sp @empid = 'AVI210',
    @logouttime = '2025-08-13 16:00:00'


select * from  attendance

SELECT * FROM employee_info
