--Creating database 

CREATE DATABASE tennis_analytics;
USE tennis_analytics;

--Creating tables 

--Categories table 
CREATE TABLE categories (
    category_id VARCHAR(100) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

SELECT * FROM categories;

--Competitions table
CREATE TABLE competitions(
    competition_id VARCHAR(50) PRIMARY KEY,
    competition_name VARCHAR(200) NOT NULL,
    parent_id VARCHAR(100),
    type VARCHAR(50),
    gender VARCHAR(20),
    category_id VARCHAR(100),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

 SELECT * FROM competitions;

--Complexes table
CREATE TABLE complexes(complex_id VARCHAR(50) PRIMARY KEY,
    complex_name VARCHAR(100) NOT NULL
 );

 SELECT * FROM complexes;


--Venues table 
CREATE TABLE venues(venue_id VARCHAR(50) PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    city_name VARCHAR(100),
    country_name VARCHAR(100),
    country_code CHAR(3),
    timezone VARCHAR(100),
    complex_id VARCHAR(50),
    FOREIGN KEY (complex_id) REFERENCES complexes(complex_id)
);

SELECT * FROM venues;


--Ranking tables 

--Competitors table 
CREATE TABLE competitors(competitor_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100),
    country_code CHAR(3),
    abbreviation VARCHAR(10)
 );


 SELECT * FROM competitors;

--Competitors ranking table 

CREATE TABLE competitor_rankings (
    rank_id INT IDENTITY(1,1) PRIMARY KEY,
    rank INT,
    movement INT,
    points INT,
    competitions_played INT,
    competitor_id VARCHAR(50),
    FOREIGN KEY (competitor_id) REFERENCES competitors(competitor_id)
);

SELECT * FROM competitor_rankings;



---Importing csv files 

-- Drop tables if they exist
DROP TABLE IF EXISTS competitions;
DROP TABLE IF EXISTS categories;

-- Creating categories table
CREATE TABLE categories (
    category_id VARCHAR(100) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Creating competitions table
CREATE TABLE competitions(
    competition_id VARCHAR(50) PRIMARY KEY,
    competition_name VARCHAR(200) NOT NULL,
    parent_id VARCHAR(100),
    type VARCHAR(50),
    gender VARCHAR(20),
    category_id VARCHAR(100),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Import categories
BULK INSERT categories
FROM 'C:\SQLData\category.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

SELECT COUNT(*) FROM categories;

-- Import competitions
BULK INSERT competitions
FROM 'C:\SQLData\competition.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);


SELECT COUNT(*) FROM competitions;

--Import complexes
BULK INSERT complexes
FROM 'C:\SQLData\complexes.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

SELECT COUNT(*) FROM complexes;

--Importing venues


ALTER TABLE venues
ALTER COLUMN country_code VARCHAR(10);

BULK INSERT venues
FROM 'C:\SQLData\venues.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

SELECT COUNT(*) FROM venues;


--Importing comptitors 
-- Clear dependent data
DELETE FROM competitor_rankings;
DELETE FROM competitors;

-- Increase column sizes
ALTER TABLE competitors
ALTER COLUMN country_code VARCHAR(100);

ALTER TABLE competitors
ALTER COLUMN abbreviation VARCHAR(100);

-- Import competitors
BULK INSERT competitors
FROM 'C:\SQLData\competitors.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
);

SELECT COUNT(*) FROM competitors;

--Importing competitors rankings

-- Step 1: Clear table
DELETE FROM competitor_rankings;

-- Step 2: Drop temp table
DROP TABLE IF EXISTS competitor_rankings_temp;

-- Step 3: Create temp table (correct order)
CREATE TABLE competitor_rankings_temp (
    rank VARCHAR(50),
    movement VARCHAR(50),
    competitor_id VARCHAR(200),
    points VARCHAR(50),
    competitions_played VARCHAR(50)
);

-- Step 4: Import CSV
BULK INSERT competitor_rankings_temp
FROM 'C:\SQLData\competitor_ranking.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Step 5: Disable FK constraint
ALTER TABLE competitor_rankings NOCHECK CONSTRAINT ALL;

-- Step 6: Insert data (NO FILTER, NO JOIN)
INSERT INTO competitor_rankings
(rank, movement, points, competitions_played, competitor_id)
SELECT
TRY_CAST(rank AS INT),
TRY_CAST(movement AS INT),
TRY_CAST(points AS INT),
TRY_CAST(competitions_played AS INT),
competitor_id
FROM competitor_rankings_temp;

-- Step 7: Enable FK back
ALTER TABLE competitor_rankings CHECK CONSTRAINT ALL;

-- Step 8: Check data
SELECT COUNT(*) FROM competitor_rankings;

-- Step 9: Drop temp table
DROP TABLE competitor_rankings_temp;



---QUERIES---


---Competitions queries----



--1) List all competitions along with their category name

SELECT c.competition_name,cat.category_name
FROM competitions c
JOIN categories cat
ON c.category_id=cat.category_id;


--2) Count the number of competitions in each category
SELECT cat.category_name,COUNT(c.competition_id) AS total_competitions
FROM competitions c
JOIN categories cat
ON c.category_id=cat.category_id
GROUP BY cat.category_name;


--3) Find all competitions of type 'doubles'
SELECT competition_name,type
FROM competitions 
WHERE type='doubles';


--4) Get competitions that belong to a specific category (e.g., ITF Men)

SELECT c.competition_name,cat.category_name
FROM competitions c
JOIN categories cat
ON c.category_id=cat.category_id
WHERE cat.category_name='ITF Men';



--5) Identify parent competitions and their sub-competitions 

SELECT 
p.competition_name AS parent_competition,
c.competition_name AS sub_competition
FROM competitions c
JOIN competitions p
ON c.parent_id = p.competition_id;


--6) Analyze the distribution of competition types by category
SELECT cat.category_name,c.type,COUNT(*) AS total 
FROM competitions c
JOIN categories cat
ON c.category_id=cat.category_id
GROUP BY cat.category_name,c.type
ORDER BY cat.category_name;



--7) List all competitions with no parent (top-level competitions) want these as per project requirements

SELECT competition_name
FROM competitions
WHERE parent_id IS NULL;




------Venues and Complexes queries------


--1) List all venues along with their associated complex name

SELECT v.venue_name,c.complex_name
FROM venues v
JOIN complexes c 
ON v.complex_id=c.complex_id;


--2) Count the number of venues in each complex

SELECT c.complex_name,COUNT(v.venue_id) AS total_venues
FROM complexes c
LEFT JOIN venues v
ON c.complex_id=v.complex_id
GROUP BY c.complex_name;


--3) Get details of venues in a specific country (e.g., Chile)

SELECT *
FROM venues
WHERE country_name = 'Chile';


--4) Identify all venues and their timezones

SELECT venue_name,timezone
FROM venues;


--5) Find complexes that have more than one venue

SELECT c.complex_name,COUNT(v.venue_id) AS total_venues
FROM complexes c
JOIN venues v
ON c.complex_id=v.complex_id
GROUP BY c.complex_name
HAVING COUNT(v.venue_id) > 1;

--6) List venues grouped by country

SELECT country_name,COUNT(*) AS total_venues
FROM venues 
GROUP BY country_name
ORDER BY total_venues DESC;


--7) Find all venues for a specific complex (e.g., Nacional)

SELECT v.venue_name,c.complex_name
FROM venues v
JOIN complexes c
ON v.complex_id=c.complex_id
WHERE c.complex_name='Nacional';

SELECT * FROM competitors;

---- Count competitors by country -----

--1) SELECT country, COUNT(*) AS total_players

FROM competitors
GROUP BY country
ORDER BY total_players DESC;

--2) Find competitors with missing country

SELECT name
FROM competitors
WHERE country IS NULL;

--3) Search competitor by name

SELECT * FROM competitors
WHERE name LIKE '%Nadal%';

-------- Ranking Queries ----------

--1) Top 10 ranked players

SELECT c.name, r.rank, r.points
FROM competitor_rankings r
JOIN competitors c
ON r.competitor_id = c.competitor_id
ORDER BY r.rank ASC;

--2) Players with highest points

SELECT TOP 10 c.name, r.points
FROM competitor_rankings r
JOIN competitors c
ON r.competitor_id = c.competitor_id
ORDER BY r.points DESC;

--3) Average ranking points

SELECT AVG(points) AS avg_points
FROM competitor_rankings;

--4) Competitors with most competitions played

SELECT TOP 10 c.name, r.competitions_played
FROM competitor_rankings r
JOIN competitors c
ON r.competitor_id = c.competitor_id
ORDER BY r.competitions_played DESC;




















