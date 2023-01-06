
DROP TABLE Tc
DROP TABLE Tb
DROP TABLE Ta


-- create the tables
CREATE TABLE Ta (
	aid INT PRIMARY KEY,
	a2 INT UNIQUE,
	name VARCHAR(20)
)


CREATE TABLE Tb (
	bid INT PRIMARY KEY,
	b2 INT
)

CREATE TABLE Tc (
	cid INT PRIMARY KEY,
	aid INT FOREIGN KEY REFERENCES Ta(aid),
	bid INT FOREIGN KEY REFERENCES Tb(bid)
)

SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc

DELETE FROM Ta
DELETE FROM Tb
DELETE FROM Tc

GO
CREATE OR ALTER PROCEDURE insertIntoTaTbTc AS
BEGIN

	DECLARE @i INT=0
	DECLARE @fk1 INT
	DECLARE @fk2 INT
	WHILE @i<100
	BEGIN
		INSERT INTO Ta VALUES (@i, @i*2, CONCAT('test', RAND()*@i))
		INSERT INTO Tb VALUES (@i, RAND()*@i)

		SET @fk1 = (SELECT TOP 1 aid FROM Ta ORDER BY NEWID())
		SET @fk2 = (SELECT TOP 1 bid FROM Tb ORDER BY NEWID())

		INSERT INTO Tc VALUES (@i,@fk1,@fk2)

		SET @i=@i+1
	END
END

EXEC insertIntoTaTbTc


SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc


-- clustered index automatically created for aid column in Ta
-- nonclustered index automatically created for tge a2 column in Ta
-- clustered index autmatically created for bid column in Tb
-- clustered index automatically created for cid column in Tc

-- a. 
-- clustered index scan: scan the entire table
-- Estimated operator cost: 0.003392
SELECT * FROM Ta 
ORDER BY aid


-- clustered index seek: return a specific subset of rows
-- Estimated operator cost: 0.003293
SELECT * FROM Ta
WHERE aid < 10



-- nonclustered index scan: scan the entire nonclustered index
-- Estimated operator cost: 0.003392
SELECT a2
FROM Ta
ORDER BY a2


-- nonclustered index seek: return a specific subset of rows 
-- Estimated operator cost: 0.0032985
SELECT a2
FROM Ta
WHERE a2 BETWEEN 50 AND 78



-- key lookup: uses a nonclustered index to satisfy all or some of a query's predicates,
-- but it doesn't contain all the information needed to cover the query, so additional data is needed
-- Estimated operator cost: 0.0032831
SELECT name, a2
FROM Ta
WHERE a2 = 56



-- b.
-- Write a query on table Tb with a WHERE clause of the form WHERE b2 = value
-- Create a nonclustered index that can speed up the query.

-- Estimated operator cost before creating the nonclustered index: 0.003392
-- it does a clustered index scan
SELECT *
FROM Tb
WHERE b2 = 78


IF EXISTS (SELECT name FROM sys.indexes WHERE name= N'TB_b2_index')
 DROP INDEX TB_b2_index ON Tb;

GO
CREATE NONCLUSTERED INDEX TB_b2_index ON Tb(b2);
GO

-- Estimated operator cost after creating the nonclustered index:0.0032831
-- it does a nonclustered index seek
-- It improvesthe performance of frequently used queries not covered by the clustered index or to locate rows in a table without a clustered index 


-- c.
-- Create a view that joins at least 2 tables. Check whether existing indexes are helpful; if not, 
-- reassess existing indexes / examine the cardinality of the tables.


GO
CREATE OR ALTER VIEW ViewThreeTables AS
	SELECT Ta.aid, Tb.bid, Tc.cid
	FROM Tc 
	INNER JOIN Ta ON Ta.aid =Tc.cid
	INNER JOIN Tb ON Tb.bid = Tc.cid
	WHERE Tb.b2>45

GO
SELECT *
FROM ViewThreeTables

-- with existing indexes ( the automatically created ones and the nonclustered index on b2): Estimated operator cost: 0.0033007  /  0.0000899
-- without the nonclustered index on b2 and only the automatically created indexes: Estimated operator cost: 0.003392  /  0.000071