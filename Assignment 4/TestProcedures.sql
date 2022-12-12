USE [Travel Agency DB]
-- add into Tables

GO
CREATE OR ALTER PROCEDURE addIntoTables(@tableName VARCHAR(50)) AS
BEGIN
	IF @tableName IN ( SELECT [Name] from [Tables])
	BEGIN
		PRINT 'Table already present in Tables'
		RETURN
	END

	IF @tableName NOT IN ( SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES)
	BEGIN
		PRINT 'Table not present in database'
		RETURN
	END

	INSERT INTO [Tables] ([Name]) VALUES (@tableName)
END


-- add into Views
GO
CREATE OR ALTER PROCEDURE addIntoViews(@viewName VARCHAR(50)) AS
BEGIN
	IF @viewName IN (SELECT [Name] FROM [Views])
	BEGIN
		PRINT 'View already present in Views'
		RETURN
	END


	IF @viewName NOT IN ( SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS)
	BEGIN
		PRINT 'View not present in database'
		RETURN
	END

	INSERT INTO [Views] ([Name]) VALUES (@viewName)
END


-- add into Tests
GO
CREATE OR ALTER PROCEDURE addIntoTests(@testName VARCHAR(50)) AS
BEGIN
	IF @testName IN (SELECT [Name] from [Tests])
	BEGIN
		PRINT 'Test already present in Tests'
		RETURN
	END

	INSERT INTO [Tests] ([Name]) VALUES (@testName)
END



-- connect Tables to Tests
GO
CREATE OR ALTER PROCEDURE connectTablesToTest( @tableName VARCHAR(50), @testName VARCHAR(50), @rows INT, @position INT) AS
BEGIN
	IF @tableName NOT IN (SELECT [Name] FROM [Tables])
	BEGIN
		PRINT 'Table not in Tables'
		RETURN
	END

	IF @testName NOT IN (SELECT [Name] FROM [Tests])
	BEGIN
		PRINT 'Test not in Tests'
		RETURN
	END

	IF EXISTS(
		SELECT *
		FROM TestTables T1 JOIN Tests T2 ON T1.TestID=T2.TestID
		WHERE T2.[Name]=@testName AND Position=@position
	)
	BEGIN
		PRINT 'Position provided conflicts with previous position'
		RETURN
	END

	INSERT INTO [TestTables] (TestID, TableID, NoOfRows, Position)
	VALUES(
			(SELECT [Tests].TestID FROM [Tests] WHERE [Name]=@testName),
			(SELECT [Tables].TableID FROM [Tables] WHERE [Name]=@tableName),
			@rows,
			@position
	)	
END


-- connect Views to Tests
GO
CREATE OR ALTER PROCEDURE connectViewsToTests(@viewName VARCHAR(50), @testName VARCHAR(50)) AS
BEGIN
	IF @viewName NOT IN (SELECT [Name] FROM [Views])
	BEGIN
		PRINT 'View not in Views'
		RETURN
	END

	IF @testName NOT IN (SELECT [Name] FROM [Tests])
	BEGIN
		PRINT 'Test not in Tests'
		RETURN
	END

	INSERT INTO [TestViews] (TestID, ViewID)
	VALUES(
		  (SELECT [Tests].TestID FROM [Tests] WHERE [Name]=@testName),
		  (SELECT [Views].ViewID FROM [Views] WHERE [Name]=@viewName)
	)
END


-- delete data from a table
GO
CREATE OR ALTER PROCEDURE deleteDataFromTable (@tableID INT) AS
BEGIN
	IF @tableID NOT IN (SELECT [TableID] FROM [Tables])
	BEGIN
		PRINT 'Table not in Tables'
		RETURN
	END

	DECLARE @tableName VARCHAR(50) = (SELECT [Name] FROM [Tables] WHERE TableID=@tableID)
	PRINT 'Delete data from table ' + @tableName
	DECLARE @query NVARCHAR(100) = N'DELETE FROM ' + @tableName
	PRINT @query
	EXEC sp_executesql @query
END


-- delete from all tables involved in a test
GO
CREATE OR ALTER PROCEDURE deleteDataFromAllTables(@testID INT) AS
BEGIN
	IF @testID NOT IN (SELECT [TestID] FROM [Tests])
	BEGIN
		PRINT 'Test not in Tests'
		RETURN
	END
	PRINT 'Delete data from all tables for the test ' + CONVERT(VARCHAR, @testID)
	DECLARE @tableID INT
	DECLARE @pos INT

	--we use cursor to iterate through the tables in the descending order of the positions
	DECLARE tablesCursorDesc CURSOR LOCAL FOR
		SELECT T1.TableID, T1.Position
		FROM TestTables T1
		INNER JOIN Tests T2 ON T2.TestID=T1.TestID
		WHERE T2.TestID=@testID
		ORDER BY T1.Position DESC

	OPEN tablesCursorDesc
	FETCH tablesCursorDesc INTO @tableID, @pos
	WHILE @@FETCH_STATUS=0
	BEGIN
		EXEC deleteDataFromTable @tableID
		FETCH NEXT FROM tablesCursorDesc INTO @tableId, @pos
	END
	CLOSE tablesCursorDesc
	DEALLOCATE tablesCursorDesc
END



-- find how many column does the primary key contain
/*
GO
CREATE OR ALTER PROCEDURE findHowManyColumns 
AS
BEGIN
	SELECT SCHEMA_NAME(o.schema_id) AS 'Schemaa'
	, OBJECT_NAME(i.object_id) AS 'TableName'
	, COUNT(COL_NAME(ic.object_id,ic.column_id)) AS 'Primary_Key_Column_Count'
	FROM sys.indexes i 
		INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
		INNER JOIN sys.objects o ON i.object_id = o.object_ID
		INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
	WHERE i.is_primary_key = 1
			AND o.type_desc = 'USER_TABLE'
	GROUP BY OBJECT_NAME(i.object_id), o.schema_id
	HAVING COUNT(1) > 0
	ORDER BY 1
END
GO*/


-- insert data into a specific table
GO
CREATE OR ALTER PROCEDURE insertDataIntoTable(@testRunID INT, @testID INT, @tableID INT) AS
BEGIN
	IF @testID NOT IN (SELECT [TestID] FROM [Tests])
	BEGIN
		PRINT 'Test not in Tests'
		RETURN
	END

	IF @testRunID NOT IN (SELECT [TestRunID] FROM [TestRuns])
	BEGIN
		PRINT 'TestRun not in TestRuns'
		RETURN
	END

	IF @tableID NOT IN (SELECT [TableID] FROM [Tables])
	BEGIN
		PRINT 'Table not in Tables'
		RETURN
	END

	DECLARE @startTime DATETIME = SYSDATETIME()
	DECLARE @tableName VARCHAR(50) = (
			SELECT [Name]
			FROM [Tables]
			WHERE TableID=@tableID
	)
	PRINT 'Insert data into table ' + @tableName
	DECLARE @numberOfRows INT =(
			SELECT [NoOfRows]
			FROM [TestTables]
			WHERE TestID=@testID AND TableID=@tableID
	)

	
	EXEC generateRandomDataForTable @tableName, @numberOfRows
	DECLARE @endTime DATETIME=SYSDATETIME()
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
	VALUES (@testRunID, @tableID, @startTime, @endTime)
END


--insert data in all the tables involved in a test
GO
CREATE OR ALTER PROCEDURE insertDataInAllTables(@testRunID INT, @testID INT)
AS
BEGIN
	IF @testID NOT IN(SELECT [TestID] FROM [Tests])
	BEGIN	
		PRINT 'Test not in Tests'
		RETURN
	END

	IF @testRunID NOT IN (SELECT [TestRunID] FROM [TestRuns])
	BEGIN
		PRINT 'TestRun not in TestRuns'
		RETURN
	END

	PRINT 'Insert data in all the tables for the test ' + CONVERT(VARCHAR, @testID)
	DECLARE @tableID INT
	DECLARE @pos INT
	--cursor to iterate through the tables in ascending order of their position
	DECLARE allTablesCursorAsc CURSOR LOCAL FOR
		SELECT T1.TableID, T1.Position
		FROM TestTables T1
		INNER JOIN Tests T2 ON T2.TestID=T1.TestID
		WHERE T1.TestID =@testID
		ORDER BY T1.Position ASC

	OPEN allTablesCursorAsc
	FETCH allTablesCursorAsc INTO @tableID, @pos
	WHILE @@FETCH_STATUS=0
	BEGIN
		EXEC insertDataIntoTable @testRunID, @testID, @tableID
		FETCH NEXT FROM allTablesCursorAsc INTO @tableID, @pos
	END
	CLOSE allTablesCursorAsc
	DEALLOCATE allTablesCursorAsc
END



--select data from a view
GO
CREATE OR ALTER PROCEDURE selectDataFromView(@viewID INT, @testRunID INT)
AS
BEGIN
	IF @viewID NOT IN(SELECT [ViewID] FROM [Views])
	BEGIN
		PRINT 'View not in Views'
		RETURN
	END

	IF @testRunID NOT IN(SELECT [TestRunID] FROM [TestRuns])
	BEGIN
		PRINT 'TestRun not in TestRuns'
		RETURN
	END

	DECLARE @startTime DATETIME=SYSDATETIME()
	DECLARE @viewName VARCHAR(100) =(
			SELECT [Name]
			FROM [Views]
			WHERE ViewID = @viewID
	)
	PRINT 'Selecting data from the view ' + @viewName
	DECLARE @query NVARCHAR(150)=N'SELECT * FROM '+ @viewName
	EXEC sp_executesql @query

	DECLARE @endTime DATETIME=SYSDATETIME()
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt)
	VALUES (@testRunID, @viewID, @startTime, @endTime)
END


--select data from all the views
GO
CREATE OR ALTER PROCEDURE selectAllViews (@testRunID INT, @testID INT) AS
BEGIN
	IF @testID NOT IN (SELECT [TestID] FROM [Tests])
	BEGIN
		PRINT 'Test not present in Tests.'
		RETURN
	END

	IF @testRunID NOT IN (SELECT [TestRunID] FROM [TestRuns])
	BEGIN
		PRINT 'Test run not present in TestRuns.'
		RETURN
	END

	PRINT 'Selecting data from all the views from the test ' + CONVERT(VARCHAR, @testID)
	DECLARE @viewID INT

	--cursor to iterate through all the views
	DECLARE selectAllViewsCursor CURSOR LOCAL FOR
		SELECT T1.ViewID FROM TestViews T1
		INNER JOIN Tests T2 ON T2.TestID = T1.TestID
		WHERE T1.TestID = @testID

	OPEN selectAllViewsCursor
	FETCH selectAllViewsCursor INTO @viewID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		EXEC selectDataFromView @viewID, @testRunID
		FETCH NEXT FROM selectAllViewsCursor INTO @viewID
	END
	CLOSE selectAllViewsCursor
	DEALLOCATE selectAllViewsCursor
END



-- run a test
GO
CREATE OR ALTER PROCEDURE runTest(@testID INT, @description VARCHAR(MAX)) AS
BEGIN
	IF @testID NOT IN (SELECT [TestID] FROM [Tests])
	BEGIN
		PRINT 'Test not present in Tests.'
		RETURN
	END

	PRINT 'Running test with the id ' + CONVERT(VARCHAR, @testID)
	INSERT INTO TestRuns([Description])
	VALUES (@description)
	DECLARE @testRunID INT =(
		SELECT MAX(TestRunID)
		FROM TestRuns
	)
	EXEC deleteDataFromAllTables @testID
	DECLARE @startTime DATETIME=SYSDATETIME()
	EXEC insertDataInAllTables @testRunID, @testID
	EXEC selectAllViews @testRunID, @testID
	DECLARE @endTime DATETIME=SYSDATETIME()
	EXEC deleteDataFromAllTables @testID

	UPDATE [TestRuns] SET StartAt = @startTime, EndAt=@endTime
	DECLARE @timeDiff INT = DATEDIFF(SECOND, @startTime, @endTime)
	PRINT 'The test with id ' + CONVERT(VARCHAR, @testID) + ' took ' + CONVERT(VARCHAR, @timeDiff) + ' seconds.'
END


EXEC runTest 2,'Done'
EXEC deleteDataFromAllTables 2


--run all tests
GO
CREATE OR ALTER PROCEDURE runAllTests AS
BEGIN
	DECLARE @testName VARCHAR(100)
	DECLARE @testID INT
	DECLARE @description VARCHAR(200)

	--cursor to iterate through the tests
	DECLARE allTestsCursor CURSOR LOCAL FOR
			SELECT *
			FROM Tests

	OPEN allTestsCursor
	FETCH allTestsCursor INTO @testID, @testName
	WHILE @@FETCH_STATUS=0
	BEGIN
		PRINT 'Running '+ @testName
		SET @description = 'Test results for the test with the ID ' + CAST(@testID AS VARCHAR(2))
		EXEC runTest @testID, @description
		FETCH NEXT FROM allTestsCursor INTO @testID, @testName
	END
	CLOSE allTestsCursor
	DEALLOCATE allTestsCursor
END



--VIEWS: create the views 
--a view with a SELECT statement operating on one table;
GO
CREATE OR ALTER VIEW hotelsWithPriceMoreThan200 AS
	SELECT H.hotel_name, H.price
	FROM Hotel H
	WHERE H.price>200


-- a view with a SELECT statement that operates on at least 2 different tables and contains at least one JOIN operator;
GO
CREATE OR ALTER VIEW hotelsAndActivities AS
	SELECT H.hotel_name, A.activity_id
	FROM Hotel H INNER JOIN Activity A ON A.hotel_id=H.id_hotel


--a view with a SELECT statement that has a GROUP BY clause, operates on at least 2 different tables and contains at least one JOIN operator.
GO
CREATE OR ALTER VIEW groupHotelsByActivites AS
	SELECT H.hotel_name, AL.name_activity, COUNT(*) AS ActivityHotels
	FROM Hotel H
	INNER JOIN Activity A ON H.id_hotel=A.hotel_id
	INNER JOIN ActivityList AL ON A.activity_id=AL.id_activity
	GROUP BY  H.hotel_name, AL.name_activity



GO

--create tests


--first test
--  a table with no foreign key and a single-column primary key, a table with a foreign key and a single-column primary key and a table with a multi-column primary key
-- a view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables
EXEC addIntoViews  'groupHotelsByActivites'
EXEC addIntoTests 'Test1'
EXEC addIntoTables 'Hotel'
EXEC connectTablesToTest 'Hotel', 'Test1', 500, 1
EXEC addIntoTables 'ActivityList'
EXEC connectTablesToTest 'ActivityList', 'Test1', 500, 2
EXEC addIntoTables 'Activity'
EXEC connectTablesToTest 'Activity', 'Test1', 500, 3
EXEC connectViewsToTests 'groupHotelsByActivites', 'Test1'


--second test
-- a table with a single-column primary key
-- a view with a SELECT statement operating on one table
EXEC addIntoViews 'hotelsWithPriceMoreThan200'
EXEC addIntoTests 'Test2'
EXEC addIntoTables 'Hotel'
EXEC connectTablesToTest 'Hotel', 'Test2', 100,1
EXEC connectViewsToTests 'hotelsWithPriceMoreThan200', 'Test2'



--third test
--a table with a foreign key and a single-column primary key and a table with a multi-column primary key
--a view with a SELECT statement that operates on at least 2 different tables and contains at least one JOIN operator;

EXEC addIntoViews 'hotelsAndActivities'
EXEC addIntoTests 'Test3'
EXEC addIntoTables 'Hotel'
EXEC connectTablesToTest 'Hotel', 'Test3', 100, 1
EXEC addIntoTables 'ActivityList'
EXEC connectTablesToTest 'ActivityList', 'Test3', 100, 2
EXEC addIntoTables 'Activity'
EXEC connectTablesToTest 'Activity', 'Test3',100, 3
EXEC connectViewsToTests 'hotelsAndActivities', 'Test3'


SELECT *
FROM Hotel


SELECT *
FROM Activity


SELECT *
FROM ActivityList

DELETE FROM ActivityList
DELETE FROM Activity

EXEC runAllTests

DELETE FROM TestRuns
DELETE FROM TestRunTables
DELETE FROM TestRunViews
DELETE FROM TestTables
DELETE FROM TestViews
DELETE FROM Views
DELETE FROM Tests
DELETE FROM Tables

DELETE Hotel WHERE id_hotel NOT IN (SELECT TOP 9 id_hotel FROM Hotel)
DELETE FROM TypeOfRoom

SELECT *
FROM [Views]

SELECT *
FROM [Tables]

SELECT *
FROM [Tests]


SELECT *
FROM [TestTables]

SELECT *
FROM [TestViews]

SELECT *
FROM [TestRuns]

SELECT *
FROM [TestRunTables]

SELECT *
FROM [TestRunViews]