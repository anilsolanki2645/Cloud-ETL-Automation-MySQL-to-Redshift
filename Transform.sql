-- ------------------------- IMDB ETL project SQL Transformation script ----------------------
-- ------------------------------------------------------------------------------------------------------------------
-- Note : This is not a Complete transformation script we can use more Technique to transform the data in ETL process
-- ------------------------------------------------------------------------------------------------------------------

-- Data Cleaning and Feature Engineering

-- Convert Votes to INT by removing commas
-- allready done in code

-- Data Enrichment

-- Add a new column for average rating (assuming rating is out of 10)
ALTER TABLE movie_data
ADD COLUMN avg_rating DECIMAL(4, 1);

-- Calculate average rating
UPDATE movie_data
SET avg_rating = (rating + metascore) / 2;

-- Add a new column for id as primary key with auto-increment
ALTER TABLE movie_data
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

-- Filtering

-- Remove rows with missing or invalid data
DELETE FROM movie_data
WHERE movie_name IS NULL OR year_of_release IS NULL OR watch_time IS NULL OR rating IS NULL OR metascore IS NULL OR votes IS NULL OR description IS NULL;

-- Remove Description column
ALTER TABLE movie_data DROP COLUMN description;


-- Remove row with metascore 0
DELETE FROM movie_data where metascore=0;

-- Data Deduplication

-- Create a new table for deduplicated data
CREATE TABLE deduplicated_movie_data AS
SELECT DISTINCT *
FROM movie_data;

-- Drop the original table
DROP TABLE movie_data;

-- Rename the deduplicated table to the original table name
ALTER TABLE deduplicated_movie_data
RENAME TO movie_data;
