
--modify the type of a column
GO 
CREATE OR ALTER PROCEDURE setPriceFromHotelDecimal
AS
	ALTER TABLE Hotel ALTER COLUMN price DECIMAL(5,2)


GO
CREATE OR ALTER PROCEDURE setPriceFromHotelInt
AS 
	ALTER TABLE Hotel ALTER COLUMN price INT

EXEC setPriceFromHotelInt

--add/remove a column
GO
CREATE OR ALTER PROCEDURE addPresidentToCountry
AS 
	ALTER TABLE Country ADD president_name VARCHAR(80)



GO
CREATE OR ALTER PROCEDURE removePresidentFromCountry
AS
	ALTER TABLE Country DROP COLUMN president_name

EXEC removePresidentFromCountry

--add/remove a DEFAULT constraint
GO
CREATE OR ALTER PROCEDURE addDefaultToStarsFromHotel
AS
	ALTER TABLE Hotel ADD CONSTRAINT default_stars DEFAULT(0) FOR stars


GO
CREATE OR ALTER PROCEDURE removeDefaultFromStarsFromHotel
AS
	ALTER TABLE Hotel DROP CONSTRAINT default_stars

EXEC removeDefaultFromStarsFromHotel


-- create/drop a table
GO
CREATE OR ALTER PROCEDURE addAgency
AS
		CREATE TABLE Agency(
				agency_id INT NOT NULL,
				agency_name VARCHAR(100) NOT NULL,
				nr_of_agents INT NOT NULL,
				CONSTRAINT AGENCY_PRIMARY_KEY PRIMARY KEY(agency_id),
				agent_agency_id INT NOT NULL
		)

EXEC addAgency

GO
CREATE OR ALTER PROCEDURE dropAgency
AS	
	DROP TABLE Agency



-- add/remove a primary key
GO
CREATE OR ALTER PROCEDURE addNameAndNrOfAgentsPrimaryKey
AS 
	ALTER TABLE Agency
			DROP CONSTRAINT AGENCY_PRIMARY_KEY
	ALTER TABLE Agency
		ADD CONSTRAINT AGENCY_PRIMARY_KEY PRIMARY KEY(agency_name, nr_of_agents)

EXEC addNameAndNrOfAgentsPrimaryKey


GO
CREATE OR ALTER PROCEDURE removeNameAndNrOfAgentsPrimaryKey
AS
	ALTER TABLE Agency
		DROP CONSTRAINT AGENCY_PRIMARY_KEY
	ALTER TABLE Agency
		ADD CONSTRAINT AGENCY_PRIMARY_KEY PRIMARY KEY(agency_id)

EXEC removeNameAndNrOfAgentsPrimaryKey



-- add/remove a conadidate key
GO
CREATE OR ALTER PROCEDURE newCandidateKeyAgent
AS
	ALTER TABLE Agent
		ADD CONSTRAINT AGENT_CANDIDATE_KEY UNIQUE(first_name, last_name, country_name)

EXEC newCandidateKeyAgent



GO
CREATE OR ALTER PROCEDURE removeCandidateKeyAgent
AS
	ALTER TABLE Agent
		DROP CONSTRAINT AGENT_CANDIDATE_KEY

EXEC removeCandidateKeyAgent



-- add/remove a foreign key
GO
CREATE OR ALTER PROCEDURE newForeignKeyAgency
AS
	ALTER TABLE Agency
		ADD CONSTRAINT AGENCY_FOREIGN_KEY FOREIGN KEY(agent_agency_id) REFERENCES Agent(id_agent)


GO
CREATE OR ALTER PROCEDURE removeForeignKeyAgency
AS
	ALTER TABLE Agency
		DROP CONSTRAINT AGENCY_FOREIGN_KEY




-- table that contains the current version of the database schema
CREATE TABLE versionTable(
	version INT
)

INSERT INTO versionTable
VALUES 
	(1) --initial version



--table that constains the initial version, the version after the execution of the proceure and the procedure that changes the table
CREATE TABLE procedureTable(
	initial_version INT,
	final_version INT,
	prcedure_name VARCHAR(200),
	PRIMARY KEY(initial_version, final_version)
)


INSERT INTO procedureTable
VALUES
	(1,2,'setPriceFromHotelDecimal'),
	(2,1,'setPriceFromHotelInt'),
	(2,3,'addPresidentToCountry'),
	(3,2,'removePresidentFromCountry'),
	(3,4,'addDefaultToStarsFromHotel'),
	(4,3,'removeDefaultFromStarsFromHotel'),
	(4,5,'addAgency'),
	(5,4,'dropAgency'),
	(5,6,'addNameAndNrOfAgentsPrimaryKey'),
	(6,5,'removeNameAndNrOfAgentsPrimaryKey'),
	(6,7,'newCandidateKeyAgent'),
	(7,6,'removeCandidateKeyAgent'),
	(7,8,'newForeignKeyAgency'),
	(8,7,'removeForeignKeyAgency')



--procedure to bring the database to the specified version
GO
CREATE OR ALTER PROCEDURE goToVers(@newVersion INT)
AS
		DECLARE @current_vers INT
		DECLARE @procedureName VARCHAR(200)
		SELECT @current_vers = version FROM versionTable

		IF (@newVersion > (SELECT MAX(final_version) FROM procedureTable) OR @newVersion<1)
			RAISERROR ('Bad version', 10, 1)
		ELSE
		BEGIN
			IF @newVersion=@current_vers
				PRINT('You are already on this version');
            ELSE
			BEGIN
				IF @current_vers>@newVersion
				BEGIN
					WHILE @current_vers>@newVersion
							BEGIN
								SELECT @procedureName=prcedure_name 
								FROM procedureTable 
								WHERE initial_version=@current_vers AND final_version = @current_vers-1
								PRINT ('Executing '+@procedureName);
								EXEC (@procedureName)
								SET @current_vers=@current_vers-1
							END
				END
				
				IF @current_vers<@newVersion
				BEGIN
					WHILE @current_vers<@newVersion
						BEGIN
							SELECT @procedureName=prcedure_name 
							FROM procedureTable
							WHERE initial_version=@current_vers AND final_version=@current_vers+1
							PRINT('Executing '+ @procedureName);
							EXEC (@procedureName)
							SET @current_vers=@current_vers+1
						END
				END
				
				UPDATE versionTable SET version=@newVersion
			END
		END

EXEC goToVers 1

SELECT *
FROM versionTable


DELETE FROM versionTable

SELECT *
FROM procedureTable
		
