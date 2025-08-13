create proc employee_sp
@empname varchar(110),
@empaddress varchar(50),
@Personalmailid varchar(50),
@officemailid varchar(50),
@mobile bigint ,
@dateofjoining datetime ,
@dateofleaving datetime = null,
@Active varchar(50)='yes',
@check varchar(50) output
as
begin
declare @flag varchar(50)
if exists(select top 1 * from employee_info WHERE mobile = @mobile and empname = @empname )
	Begin
	    SET  @flag = 'exists'
	end 
else
	Begin
      declare @aviid int
	  set @aviid = (select count(*) from employee_info)
	  SET @aviid = @aviid+1
      insert into employee_info
      select 'AVI'+ right('00'+ convert(varchar,@aviid),2),
              @empname, 
              @empaddress,
              @Personalmailid,
		      @officemailid,
		      @mobile,
		      @dateofjoining,
		      @dateofleaving,
		      @Active

	 SET  @flag = 'inserted'
   end 
     set @check = @flag
end