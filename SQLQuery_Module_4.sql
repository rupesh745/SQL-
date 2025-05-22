
select * from Employee

select *,Grade =
case
when Salary<1500 then 'C'
when Salary<=3000 then 'B'
When Salary>3000 then 'A'
else 'Salary Not Defined'
end
from Employee



-- Order By
-- Group By and Having
-- Except and Intersect
-- UNION and UNION ALL
-- Ranking Functions

-- Order By
	-- When there is a request from the Business to deliver Reports or Metrics for some analysis
		--, they might also need data to be arranged (in a particular order).
	-- Ascending or Descending
	-- The Order By Clause in SQL helps us in achieveing this
	-- The default ordering mechanism in SQL is Ascending order
	-- If we want to force the sorting to be in descending order, we need to specify it explicitly(DESC)
	-- We can have sorting applied on more than one column in the table
	-- The second column is only used, when the first column sorting returns the same value
	-- You have to specify the sorting mechanism for each column individually
SELECT *
FROM Employee
ORDER BY Salary DESC, EmployeeID asc

	-- You can also sort data using the column position/index in the SELECT
	-- This is not the ideal way
	-- Cases when the SELECT statement is altered, might be bad for this kind of sorting
SELECT EmployeeFirstName, Salary, Address, EmployeeLastName
FROM Employee
ORDER BY 3 DESC-- Column Position for the Salary column
	, 1 asc -- Column Position for the EmployeeID column

select * from Employee
where Salary=(select max(Salary) from Employee)



/*
For integer values
1      -- -5,-30,12,25,35,0,1 --> asc 0,1,12,25,35  --> 35,25,12,1,0  (int data type)
2
3
4
5
.
.
11
.
.
.
22
23
.
.


Dinesh     --abc, aag,bba, bac --> asc aag,abc,bac, bba  -->desc  (varachar data type --> for alphabetical values)
Dillip

For varchar data type : 
(Special Characters)  --> Vyanktj19@gmail.com  --> 

1             --> EmpId varachar(10) --> 1,11,333,2222
11
1211    -->varchar  1,2,3,11,222,56,22,33,1111,333,2222,4,12
. int asce ---> 1,2,3,4,11,12,22,33,56,222,333,1111,2222
  varchar asc --> 1,11,1111,12, 2,22,222,2222, 33,333,4,56
.
.
2
22
222
2222
3
33
333
A
B
C
D
*/
-- v@gmail.com , wow !!! , v.j@gail.com , v-j@gmail.com, v_j@gmail.com
 SELECT ASCII('!'),ASCII('#'), ASCII('@'),ASCII('&'),ASCII('-'),ASCII('*')

 --ASC= !,#,&,@ , *, -
CREATE TABLE intSort
(
	id int
)

INSERT INTO intSort(id)
SELECT 1 UNION ALL
SELECT 2 UNION ALL
SELECT 3 UNION ALL
SELECT 11 UNION ALL
SELECT 12 UNION ALL
SELECT 22 UNION ALL
SELECT 44 UNION ALL
SELECT 222 UNION ALL
SELECT 111 UNION ALL
SELECT -10 UNION ALL
SELECT -5 UNION ALL
SELECT -13

SELECT * FROM intSort
ORDER BY id ASC

CREATE TABLE textSort
(
	id varchar(10)
)

INSERT INTO textSort(id)
SELECT 1 UNION ALL
SELECT 2 UNION ALL
SELECT 3 UNION ALL
SELECT 11 UNION ALL
SELECT 12 UNION ALL
SELECT 22 UNION ALL
SELECT 44 UNION ALL
SELECT 222 UNION ALL
SELECT 111 UNION ALL
SELECT -10 UNION ALL
SELECT -5 UNION ALL
SELECT -13 


INSERT INTO textSort(id)
SELECT '!hello' UNION ALL
SELECT 'Hello' UNION ALL
SELECT 'Hhello' UNION ALL
SELECT '@hello' UNION ALL
SELECT '#hello' UNION ALL
SELECT '123.45' UNION ALL
SELECT '2.46' UNION ALL
SELECT '-10'

--alpha + num+ spl char -- > splchar(anscii), numeric (0-9), alph (A-Z,a-z), 

SELECT * FROM textSort
ORDER BY id ASC

-- GROUP BY: 
	-- Group BY clause helps us in grouping the data based on certain values
	-- All the non aggregated columns in the SELECT clause should be in the GROUP BY clause
--SELECT * INTO Population

create table Population
(Country varchar(10),City varchar(10),Town varchar(10), Population int (10))

insert into Population
values('C1','CT1','T1',100),
('C1','CT1','T2',23),
('C1','CT2','T3',87),
('C1','CT2','T4',98),
('C2','CT3','T5',74),
('C2','CT3','T6',14),
('C2','CT4','T7',78),
('C2','CT4','T8',56)
SELECT * FROM Population

create table Populations
(Country varchar(10),City varchar(10),Town varchar(10), Population int)

insert into Populations
values('C1','CT1','T1',100),
('C1','CT1','T2',23),
('C1','CT2','T3',87),
('C1','CT2','T4',98),
('C2','CT3','T5',74),
('C2','CT3','T6',14),
('C2','CT4','T7',78),
('C2','CT4','T8',56)
SELECT * FROM Populations
-- Total Population in the table
SELECT SUM(population)
FROM Populations

SELECT SUM(Population) 
from Population

-- Total population based on a country
SELECT Country,SUM(Population) AS TotalPopulation
FROM Populations
GROUP BY Country

-- Total population based on a city
SELECT City,SUM(Population) AS TotalPopulation
FROM Populations
GROUP BY City

SELECT Country,City,SUM(Population) AS SumOfPopulation
FROM Populations
GROUP BY Country,City

-- Filter data before Group By
	-- Here the data is first filtered and then it is grouped
SELECT City, SUM(Population) AS TotalPopulation 
FROM Populations
WHERE City <> 'CT4' --AND SUM(Population) < 150
GROUP BY City

SELECT City, SUM(Population) AS TotalPopulation 
FROM Populations
WHERE City = 'CT3'or City='CT4' --AND SUM(Population) < 150
GROUP BY City

-- Filter the data after grouping (filter aggregated data)
	-- For aggregated data filtering, we need to use the HAVING clause
	-- Aggregated data cannot be filtered using a WHERE clause
	-- HAVING can be used only with a GROUP BY

SELECT City,SUM(Population) AS SumOfPopulation
FROM Populations
WHERE City <> 'CT3' -- Before the grouping
GROUP BY City
HAVING SUM(Population) < 150 -- After the grouping
ORDER BY City 
/*
--Sequence in which the commands needs to be written
SELECT DISTINCT TOP (n) *,ColumnNames,FUNCTIONS 
FROM
[INNER/LEFT/CROSS] JOIN....ON
WHERE
GROUP BY
HAVING
ORDER BY

Sequence in which the parts of a query is executed
FROM
JOIN (INNER/OUTER/CROSS)
ON
WHERE
GROUP BY
HAVING
DISTINCT
ORDER BY
TOP
Column List/[*]/Functions
*/

-- UNION vs UNION ALL
	-- When data returned from a SELECT using a UNION, it always returns UNIQUE data in case there 
		-- are duplicates
	-- When data retruned from a SELECT using a UNION ALL, it will return duplicated data 
		-- when there are duplicate values
	-- As a reason, UNION runs slower as compared to a UNION ALL
	-- When you run UNION, UNION ALL on tables, you need to remember 2 things : 
		-- No of columns selected from the tables are the same
		-- The columns that are retunred should be of the same data type

SELECT 1 UNION ALL
SELECT 2 UNION ALL
SELECT 2 

SELECT 1 UNION 
SELECT 2 UNION 
SELECT 2 

SELECT EmployeeId, EmployeeFirstName FROM Employee -- 9
UNION all
SELECT * FROM PrimaryKeyTest -- 2
UNION ALL
SELECT * FROM UniqueTest -- 3

SELECT EmployeeId,EmployeeFirstName FROM Employee--9
UNION 
SELECT * FROM PrimaryKeyTest--2
UNION 
SELECT * FROM UniqueTest--3

-- Except operator
	-- Return the records which are present in first SELECT only but missing in second select
	-- When you run UNION, UNION ALL, EXCEPT, INTERSECT on tables, you need to remember 2 things : 
		-- No of columns selected from the tables are the same
		-- The columns that are retunred should be of the same data type

-- F1 = Apples, Oranges, Bananas
-- F2 = Apples, Oranges, Papaya
 --F1 except F2  --> Bananas
 --F2 except F1 ---> Papaya


SELECT Id,Name
FROM DefaultTest
--select * from defaulttest
SELECT *
FROM PrimaryKeyTest

SELECT Id,Name
FROM DefaultTest
EXCEPT
SELECT Id,Name
FROM PrimaryKeyTest

SELECT *
FROM PrimaryKeyTest
EXCEPT
SELECT Id,Name
FROM DefaultTest

-- INTERSECT Operator
	-- The common records between both the SELECT statements

-- F1 = Apples, Oranges, Bananas
-- F2 = Apples, Oranges, Papaya
--F1 intersect F2 -->Apples, Oranges
--F2 intersects F1 -->Apples, Oranges

SELECT Id,Name
FROM DefaultTest
INTERSECT
SELECT *
FROM PrimaryKeyTest

SELECT Id,Name
FROM PrimaryKeyTest
INTERSECT
SELECT Id,Name
FROM DefaultTest

-- Ranking Functions
	-- Ranking Functions helps us in assigning rank to each of the rows based on certain values
	-- Types of Ranking Functions : 
		-- ROW_NUMBER
		-- RANK
		-- DENSE_RANK
--SELECT * INTO Ranking 

Event Javeline Throw

Player  Score(Desc)    ROW_NUMBER   RANK              DENSE_RANK
A        89.8           1            1 GOLD MEDAL       1
B        89.6           2            2 SILVER MEDAL     2 
C        89.6           3            2 SILVER MEDAL     2
D        89.4           4            4                  3

CREATE TABLE Ranking (
    Country CHAR(3),
    City VARCHAR(50),
    Population INT
);
INSERT INTO Ranking (Country, City, Population) VALUES
('A', 'Z', 452345),
('A', 'M', 687688),
('A', 'G', 687688),
('B', 'N', 935676),
('B', 'O', 126863),
('B', 'P', 445678),
('B', 'Q', 434645),
('B', 'R', 789768),
('B', 'S', 345324),
('B', 'H', 345324);
select * from Ranking;

SELECT * FROM Ranking

-- ORDER BY
SELECT *
	, ROW_NUMBER() OVER(ORDER BY Population DESC) AS Row_Value 
FROM Ranking
SELECT *
	, RANK() OVER(ORDER BY Population DESC) AS RnkValue
FROM Ranking
SELECT *
	, DENSE_RANK() OVER(ORDER BY Population DESC) AS Dense_Rank
FROM Ranking

SELECT *
	, ROW_NUMBER() OVER(ORDER BY Population DESC) AS Row_Value 
	, RANK() OVER(ORDER BY Population DESC) AS RnkValue
	, DENSE_RANK() OVER(ORDER BY Population DESC) AS Dense_Rank
FROM Ranking
-- ORDER BY combined with the Partition By

-- ROW_NUMBER
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY Country ORDER BY Population DESC) AS Rows_Number
FROM Ranking

-- RANK
SELECT *,
	RANK() OVER(PARTITION BY Country ORDER BY Population DESC) AS RankValue
FROM Ranking

-- DENSE_RANK
SELECT *,
	DENSE_RANK() OVER(PARTITION BY Country ORDER BY Population DESC) AS RankValue
FROM Ranking
where Country='A'

-- CTE (Common Table Expression)
-- It is a temp object
-- It has a very limited scope
-- Can be used only in the first statement right after it is created
-- In the memory
-- Connected object

-- To get the third highest populated city across countries
;with RankedPopulation
AS
(
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY Country ORDER BY Population DESC) AS RankValue
	FROM Ranking
)
SELECT * FROM RankedPopulation
WHERE RankValue IN (3)

-- How to get the 3rd highest populated cities in the whole table
;with RankedPopulation
AS
(
	SELECT *,
		DENSE_RANK() OVER(ORDER BY Population DESC) AS RankValue
	FROM Ranking
)
SELECT * FROM RankedPopulation
WHERE RankValue IN (3)

SELECT * FROM RankedPopulation
WHERE RankValue IN (2)
-- How to get the 3rd lowest populated cities in the whole table
;with RankedPopulation
AS
(
	SELECT *,
		DENSE_RANK() OVER(ORDER BY Population ASC) AS RankValue
	FROM Ranking
)
SELECT * FROM RankedPopulation
WHERE RankValue IN (3)

SELECT * 
FROM EMP3

SELECT *
, CASE WHEN EMP3ID %2=1 THEN 'ODD' ELSE 'EVEN' END AS ODDEVEN
,CASE WHEN ADDRESS = 'INDIA'THEN 10 
      WHEN ADDRESS = 'KOREA' THEN 5 
	  ELSE 3 END AS HIKEPERCENTAGE
 FROM EMP3

 IF (1=2)
 BEGIN
 SELECT *
, CASE WHEN EMP3ID %2=1 THEN 'ODD' ELSE 'EVEN' END AS ODDEVEN
,CASE WHEN ADDRESS = 'INDIA'THEN 10 
      WHEN ADDRESS = 'KOREA' THEN 5 
	  ELSE 3 END AS HIKEPERCENTAGE
 FROM EMP3
 END 