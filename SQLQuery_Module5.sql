/*
 Stored Procedures
 Calculation of Salaries of employees
	 You might need the list of active employees from the employee table	 
	 You have the salary divided into HRA, DA, Basic -- Additional Amount	 
	 You also have to pay bonuses/incentives -- Additional Amount
	 You need the leaves
	 You also have LOP's -- Deductible Amount
	 You have to encash their leaves -- Additional Amount
	 They have to pay taxes -- Deductible amount

 SQL Stored Procedures are block or batch(es) of SQL statements 
	That are executed together
	In a specific sequence
	To serve definite business purpose
 which can be reused as and when required and it is accessible to everyone
 who has access to the database

 WHAT ? A stored Proc can do whatever a normal T-SQL statement can do 
	unlike functions which can only perform retrivals of data from tables.
 WHERE ? It is created and becomes a part of the database. It is stored in the 
	schema where it is created. The default schema like other db objects is dbo
	unless we specify another schema where it should be created.
 WHY ? 
 1. Encapsulation : OOPS(Object Oriented Programming concepts). Binds 
	complicated business logic into a single unit without exposing the internal
	content.
 2. Reusuability : SP's are reusuable and can be called multiple number of times
	based on need by users having execute permissions on them.
 3. Maintainabilty : The logic inside the SP can be controlled/maintained
	from a centralized location.
 4. Execution Plan Caching : 
	- Parsing  (20%) - X
	- Compiled (40%) - X
	- Executes (40%)
	 The SP when created is parsed and compiled. So it does not compile everytime it is run.
	 It also caches the best execution plan in the few initial runs.
		a. Execution plan is the path used by SQL optimizer to execute your query
			and return the result.
		b. SQL server creates the execution plan during the query execution
		c. SQL Server takes that little bit of extra time in compiling your code 
			+ creating the execution plan
 */
-- Creation of Stored Procedure
CREATE OR ALTER PROCEDURE csp_GetData
AS
BEGIN
	SELECT *
	FROM Employee
END

--Execute the Stored Procedure
EXEC csp_GetData

--ALTERING SP to add/remove columns
CREATE OR ALTER PROCEDURE dbo.csp_GetData
AS
BEGIN
	SELECT EmployeeId,EmployeeFirstName,EmployeeLastName,Address
	FROM Employee
END

EXEC csp_GetData

--Adding a paramter
CREATE OR ALTER PROCEDURE dbo.csp_GetData
(
	@EmployeeId int = 0 -- Default value to a parameter makes it optional
)
AS
BEGIN
	SELECT emp.EmployeeId,dbo.fn_GetEmployeeFullName(EmployeeFirstName,EmployeeLastName) AS FullName
				,Address,EmployeeDOB
	FROM Employee AS emp
	LEFT JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeId
	WHERE emp.EmployeeId = @EmployeeId OR @EmployeeId = 0 --(FALSE OR TRUE)
END

EXEC csp_GetData @EmployeeId = 8
GO

SELECT * FROM EmployeeDOB

--Adding an additional paramter
CREATE OR ALTER PROCEDURE dbo.csp_GetData
(
	@EmployeeId int = 0 -- Optional Paramter
	,@EmployeeAddress varchar(100) -- Mandatory Parameter
)
/*
Date		ModifiedBy	Comments
15-05-2021	Dinesh		CreatedNew proc
20-05-2021	John		Modifed to add Salary Column
07-12-2022	Dinesh		ExplainedProc
*/
AS
BEGIN
	SELECT EmployeeId,dbo.fn_GetEmployeeFullName(EmployeeFirstName,EmployeeLastName) AS FullName
		,Address
	FROM Employee
	WHERE (EmployeeId = @EmployeeId OR @EmployeeId = 0)
	AND Address = @EmployeeAddress
END

EXEC csp_GetData  @EmployeeAddress = 'India',@EmployeeId = 6

SELECT * FROM Employee

-- To view the definition of the SP
sp_helptext csp_GetData

CREATE OR ALTER PROCEDURE csp_SetData
(
	@EmployeeID INT
	, @EmployeeFirstName varchar(100)
	, @EmployeeLastName varchar(100)
	, @Salary INT
	, @Address varchar(200)
)
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM Employee WHERE EmployeeId = @EmployeeID)	
		INSERT INTO Employee(EmployeeId, EmployeeFirstName,EmployeeLastName,Salary,Address)
		SELECT @EmployeeID, @EmployeeFirstName,@EmployeeLastName,@Salary,@Address
	ELSE
		PRINT 'EmployeeID Already exists!! Please choose a new ID'
END

EXEC csp_SetData 10,'Leo','Smith',2000,'US'
SELECT * FROM Employee

-- Views
	-- View could be looked as an additional layer on top of a table which enables us to protect
		-- sensitive information based on our needs
	-- View is just a query on top of a table
	-- As this is just a layer on top of a table, views do not store any data physically in the server
	-- Instead, the data when requested, the query is executed and the data is returned

-- Create a new view
CREATE OR ALTER VIEW vw_GetEmployeeData
AS
	SELECT * FROM Employee

-- Fetch data from a view
SELECT * FROM vw_GetEmployeeData

-- Restrict to specific columns
CREATE OR ALTER VIEW vw_GetEmployeeData
AS
	SELECT EmployeeID, EmployeeFirstName, EmployeeLastName, Address 
	FROM Employee
	WHERE EmployeeID > 3

SELECT * FROM vw_GetEmployeeData

-- Joining tables to view the data
CREATE OR ALTER VIEW vw_GetEmployeeData
AS
	SELECT emp.EmployeeID, dbo.fn_GetEmployeeFullName(EmployeeFirstName,EmployeeLastName) AS FullName, Address, EmployeeDOB
	FROM Employee AS emp
	LEFT JOIN EmployeeDOB AS edob ON edob.EmployeeID = emp.EmployeeID
	WHERE emp.EmployeeID > 3

SELECT * 
FROM vw_GetEmployeeData
WHERE EmployeeID IN (5,6)

SELECT * FROM vw_GetEmployeeData AS vw
INNER JOIN Employee AS ut ON ut.EmployeeId = vw.EmployeeId

--SELECT * FROM UniqueTest

-- Orphan View
	-- Views for which the base table/column has changed/altered is called an orphan view
	-- To prevent such scenarios, and to not make our views orphan, we schemabind the view
	-- Schemabinding binds our views to the dependent physical column and tables in the views
	-- Schemabinding is only applicable for columns that are binded in the view
CREATE OR ALTER VIEW vw_GetEmployeeBackupData
WITH SCHEMABINDING
AS
	SELECT EmployeeID, EmployeeFirstName, Address
	FROM dbo.Employee_Backup

SELECT * INTO Employee_Backup
FROM Employee

DROP VIEW vw_GetEmployeeBackupData

SELECT * FROM Employee_Backup

SELECT * FROM vw_GetEmployeeBackupData

ALTER TABLE Employee_Backup
DROP COLUMN EmployeeID

ALTER TABLE Employee_Backup
DROP COLUMN Salary

SELECT * FROM Employee_Backup

DROP TABLE Employee_Backup

SELECT * FROM vw_GetEmployeeBackupData

-- View the definition of a view
CREATE OR ALTER VIEW vw_GetEmployeeDetails
WITH SCHEMABINDING 
AS
	SELECT EmployeeId, EmployeeFirstName, EmployeeLastName FROM dbo.Employee

sp_helptext vw_GetEmployeeDetails

Employee
A - NULLABLE -- Optional
B - NULLABLE -- Optional
C - NOT NULLABLE -- Mandatory
vwEmployee(A,B)
INSERT INTO vwEmployee(A,B)
SELECT Val1,Val2

-- DML operations on a view
	-- Views are not only meant to read data
	-- Views does not have physical data stored, so any DML operation is executed on the parent table
	-- We can also perform Insert/Update/Delete on the table using the views
		-- Your view should always have a select from a single table
		-- All the NOT NULL(Mandatory) columns in the base table are to be selected in the view
		
SELECT * FROM vw_GetEmployeeBackupData -- View

SELECT * FROM Employee_Backup -- Base Table
SELECT * FROM vw_GetEmployeeBackupData

-- INSERT
INSERT INTO vw_GetEmployeeBackupData(EmployeeID,EmployeeFirstName, Address)
SELECT 999,'Tom','US'

-- UPDATE
UPDATE vw_GetEmployeeBackupData
SET Address = 'India'
WHERE EmployeeID = 999

-- DELETE
DELETE FROM vw_GetEmployeeBackupData
WHERE EmployeeID = 999

SELECT * FROM Employee
SELECT * FROM EmployeeDOB

/*
Transaction
	Set of SQL operations performed in a sequence such that all operations are
		guranteed to succeed or fail as a single unit
TRANSACTION IS ALL OR NONE
	
Transfer an amount worth 100$
	-- 100 $ is deducted from the payer's account
	-- 100 $ is credited to receiver's account

When do we use a transaction : 
	-- When multiple number of rows are inserted, updated or deleted in a sequence
	-- When the changes to one table required the other table data to be
		kept consistent
	-- When we are working on modifying data across two or more concurrent DB's

Transactions is categorized by four properties, often referred to as the ACID property
	ACID (Atomicity, Consistency, Isolation, Durability)
Atomicity : Transactions should be regarded as a single unit, irrespective of the number of steps involved
Consistency : States that the transaction should always leave the DB/Table in a consistent
	state after commit or rollback of the changes
Isolation : Each transaction has its own boundary and do not interfere with other 
	transactions
Durabilty : Any modifcation done on the data after the transaction is finished should 
	be kept permanently in the DB/system

Types of transactions : 
	Autocommit transaction : The statements written as part of this are automatically
		treated as a transaction and is committed or rolled back once the statement is
		executed
	Explicit Transaction : This is where we specify the boundary of the transaction.
		We manually specify the begin and the end of the transaction

ISOLATION LEVELS in transactions
	-- READ COMMITTED - This helps us in reading only committed data from the table
	-- READ UNCOMMITTED - This reads dirty data as well. 
Default Transaction isolation level in SQL server is READ UNCOMMITTED when the SELECT is ran in the same query window
Default Transaction isolation level in SQL server is READ COMMITTED when the SELECT is ran in another query window
*/
BEGIN TRANSACTION -- This is the starting point in a transaction
	--== SQL QUERY GOES HERE
	UPDATE e
	SET e.EmployeeLastName = 'KumarNew' --Kumar
	--SELECT * 
	FROM Employee AS e
	WHERE EmployeeID = 1

	UPDATE e
	SET e.EmployeeDOB = '2000-01-01'--2003-08-27
	--SELECT * 
	FROM EmployeeDOB AS e
	WHERE EmployeeID = 1

ROLLBACK TRANSACTION -- If you want to rollback your transaction
COMMIT TRANSACTION -- If you want to commit your transaction

SELECT * FROM Employee WHERE EmployeeId = 1
SELECT * FROM EmployeeDOB WHERE EmployeeId = 1
-- DIRTY READ: When we read data that is not yet committed to the database is called a dirty read
SELECT @@TRANCOUNT
/*
-- Transaction Isolation Level (Retrival of data)
The default transaction isolation level in SQL Server is Read Uncommitted in the same query window
The default transaction isolation level in SQL Server is Read committed in a different query window
	READ COMMITTED	-- It will only read committed data in the table. If there 
		is a transaction running on the table, the query will wait till the
		transaction is completed.
	READ UNCOMMITTED -- In this level, the uncommitted data from the table 
		is also read. This brings in dirty data from the table.
*/
BEGIN TRANSACTION
	UPDATE emp
	SET EmployeeFirstName = 'David'--Steve
	--SELECT *
	FROM Employee AS emp
	WHERE EmployeeId = 4

COMMIT TRAN
ROLLBACK TRANSACTION
SELECT * FROM Employee

-- Reads only committed data
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
SELECT * FROM Employee

-- Reads dirty data as well
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SELECT * FROM Employee

SELECT * FROM Employee

--== Error/Exception Handling
-- TRY CATCH blocks to handle errors
-- TRY block has all the SQL statements that needs to be executed
-- If there are any error from the SQL queries, the CATCH block is hit

DECLARE @Numerator int = 40
, @Denominator int = 0

-- TRY CATCH
BEGIN TRY
	SELECT @Numerator/@Denominator
END TRY
BEGIN CATCH
	SELECT 'Catch block is hit'

	DECLARE @ErrorMessage varchar(500)
	SET @ErrorMessage = ERROR_MESSAGE()

	--INSERT INTO ErrorAudit(ErrorMessage, ErrorDate)
	SELECT @ErrorMessage --, GETDATE()
END CATCH
	
BEGIN TRY
	BEGIN TRANSACTION
	-- SQL1

	-- SQL2

	-- SQL3
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
END CATCH

CREATE OR ALTER PROCEDURE spName
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE Employee
			SET EmployeeLastName = 'Yadav'--Kumar
			WHERE EmployeeID = 1

			INSERT INTO Employee(EmployeeId,EmployeeFirstName,EmployeeLastName,Salary,Address)
			SELECT 101, 'Hello', 'World', 2000, 'US'

			INSERT INTO UniqueTest(Id,Name)
			SELECT 10,'Leo'

			--UPDATE Employee
			--SET EmployeeID = 1/0 -- Divide by Zero
			--WHERE EmployeeID = 1
		COMMIT TRANSACTION
		SELECT 'TransactionCommitted'
	END TRY
	BEGIN CATCH
		SELECT ERROR_LINE(),ERROR_MESSAGE(),GETDATE()
		ROLLBACK TRANSACTION
		SELECT 'TransactionRolledBack'
	END CATCH
END

EXEC spName

SELECT * FROM Employee
SELECT * FROM UniqueTest

-- CTE's (Common table Expressions)
	-- CTE is just a temporary storage for the data to be stored and used only once in their lifetime
	-- Scope of a CTE is only till the first SELECT inside the same batch after the CTE is created

;WITH cteEmployee(FirstName, LastName, Address, DOB)
AS
(
	SELECT e.EmployeeFirstName
		,e.EmployeeLastName
		,e.Address
		,edob.EmployeeDOB
	FROM Employee AS e
	INNER JOIN EmployeeDOB AS edob ON e.EmployeeId = edob.EmployeeID
	WHERE Address = 'India'
)
SELECT * FROM cteEmployee AS x
--INNER JOIN Employee AS Y on x.FirstName = Y.EmployeeFirstName
--CROSS JOIN cteEmployee AS y
--CROSS JOIN cteEmployee AS z
SELECT * FROM cteEmployee AS x

-- Subqueries
-- Get the Employees who earn more than the Avg Salary
SELECT * 
FROM Employee
WHERE Salary > (SELECT AVG(Salary) FROM Employee)

DECLARE @AvgSalary int = (SELECT AVG(Salary) FROM Employee)
SELECT * FROM Employee
WHERE Salary > @AvgSalary

-- Derived Table
SELECT * FROM
(
	SELECT *,
		DENSE_RANK() OVER(ORDER BY Salary DESC) AS RankValue
	FROM Employee
) AS x
WHERE RankValue = 4

;with cte
AS
(
	SELECT *,
		DENSE_RANK() OVER(ORDER BY Salary DESC) AS RankValue
	FROM Employee
)
SELECT * FROM cte
WHERE RankValue = 4

