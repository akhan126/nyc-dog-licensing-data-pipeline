-- ============================================
-- Part 3: SQL Exploration & Analytics
-- NYC Dog Licensing Project
-- ============================================

-- 1) Single-table aggregation (GROUP BY)
CREATE VIEW DOGS_PER_BREED(Breed_id, Num_of_dogs)
AS SELECT 
        breed_id,
        COUNT(*) 
   FROM DOGS
   GROUP BY breed_id;

--Interpretation: This view groups tuples from the base table DOGS by
--breed_id and computes the number of dogs belonging to each breed. It
--serves as a virtual summary table that eliminates the need to repeat
--the GROUP BY aggregation in future queries. Analysts can now retrieve
--breed-level statistics directly from this view as if it were a base
--relation.


-- 2) Multi-table INNER JOIN
SELECT 
    d.dog_id,
    d.animal_name,
    b.breed_name,
    z.zip_code,
    d.license_issued_date
FROM dogs d
INNER JOIN breeds b 
        ON d.breed_id = b.breed_id
INNER JOIN zipcodes z 
        ON d.zip_id = z.zip_id;
--This query demonstrates an INNER JOIN across three related tables
--DOGS, BREEDS, and ZIPCODES. It enriches each dog record by replacing
--foreign key identifiers with human-readable breed names and ZIP codes
--producing a unified and meaningful dataset. This multi-table join
--reflects how normalized relations can be combined to support practical
--reporting and analysis tasks.


-- 3) LEFT JOIN (data quality check)
--Querry Dogs with Missing Breed Information
SELECT 
    d.dog_id,
    d.animal_name,
    b.breed_name,
    d.license_issued_date
FROM dogs d
LEFT JOIN breeds b
       ON d.breed_id = b.breed_id
WHERE b.breed_name IS NULL;

--Interpretation: This query uses a LEFT OUTER JOIN to identify
--dog records that have no matching breed entry in the BREEDS
--lookup table. The LEFT JOIN preserves all rows from the DOGS
-- table and inserts NULL values when no corresponding breed exists
--allowing analysts to detect missing or inconsistent reference data.
--This example demonstrates how outer joins support data-quality checks
--and highlight integrity issues in a relational schema.


-- 4) Ranking the most common breeds within each ZIP code
SELECT 
    z.zip_code,
    b.breed_name,
    COUNT(*) AS num_dogs,
    RANK() OVER (
        PARTITION BY z.zip_code 
        ORDER BY COUNT(*) DESC
    ) AS breed_rank
FROM dogs d
JOIN breeds b ON d.breed_id = b.breed_id
JOIN zipcodes z ON d.zip_id = z.zip_id
GROUP BY z.zip_code, b.breed_name, b.breed_id;

--Interpretation: This query uses the analytic function RANK()
--with a PARTION BY clause to rank dog breeds within each ZIP code
--based on their frequency. The window function evaluates the ranking
--after aggregation, without colapsing ZIP codes into a single group.
--This demonstrates how analytic queries can reveal local patterns
--such as the most common breed per ZIP while preserving detailed
--row-level structure.


-- 5) CTE (Common Table Expression)
--Counting dogs licensed per year
WITH yearly_counts AS (
    SELECT 
        extract_year,
        COUNT(*) AS num_dogs
    FROM dogs
    GROUP BY extract_year
)
SELECT 
    extract_year,
    num_dogs
FROM yearly_counts
ORDER BY extract_year;

--Interpretaion: This query uses a Common Table Expression to separate
--the logic of computing dog counts per year from the final retrieval
--step. The CTE yearly_counts performs the aggregation, while the outer
--query selects from the intermediate result as if it were a temporary
--view. This structure improves readability and breaking a complex
--task into smaller, simpler, reusable parts when working with multi-step
--analytical queries.


-- 6) Derived metric (ALTER TABLE + UPDATE)
--Add a column for dog age
ALTER TABLE dogs
ADD COLUMN dog_age INT;

--Populate a derived column for dog age
UPDATE dogs
SET dog_age = EXTRACT(YEAR FROM CURRENT_DATE) - animal_birth_year;

--Interpretation: This example demonstrates how to add a derived metric
--to an existing table using ALTER TABLE followed by UPDATE. The new
--column dog_age is computed by subtracting each dog's birth year from
--the current calender year, creating a meaningful attribute for
--age-based analysis. This approach shows how derived metrics can be
--incorporated into a relational schema to support richer analytical
--queries.


-- 7) EXPLAIN ANALYZE example
--Index-usage demonstration with EXPLAIN (before/after)

--Query performance before creating the index
EXPLAIN ANALYZE
SELECT *
FROM dogs
WHERE license_issued_date >= '2020-01-01';

--Create the index
CREATE INDEX idx_license_issued_date
ON dogs (license_issued_date);

--Query performance after creating the index
EXPLAIN ANALYZE
SELECT *
FROM dogs
WHERE license_issued_date >= '2020-01-01';

--Interpretation: This demonstration compares a SELECT query run before
--and after creating an index on the license_issued_date column of the 
--DOGS table. The first EXPLAIN ANALYZE typically shows a sequential scan,
--indicating that PostgreSQL must read the entire table to evaluate the
--filter condition. After adding the index, the query planner switches to 
--an index-based scan, lowering query cost and improving performance,
-- which illustrates the effectiveness of indexing frequently filtered columns.


-- 8. Materialized view: Most common breed per ZIP code
CREATE MATERIALIZED VIEW mv_breed_counts_by_zip AS
SELECT 
    z.zip_code,
    b.breed_name,
    COUNT(*) AS num_dogs
FROM dogs d
JOIN breeds b ON d.breed_id = b.breed_id
JOIN zipcodes z ON d.zip_id = z.zip_id
GROUP BY z.zip_code, b.breed_name, b.breed_id;

--Refresh strategy
REFRESH MATERIALIZED VIEW mv_breed_counts_by_zip;

--Interpretation: This materialized view stores precomputed dog counts
--per breed and zip code improving performance for repeated analytical
--queries. Because the data is materialized physically, it must be
--refreshed when new dog records are loaded into the database.
--The REFRESH MATERIALIZED VIEW command regenerates the stored results,
--ensuring that the view remains synchronized with updates to the
--underlying tables. 

-- Refresh strategy
REFRESH MATERIALIZED VIEW breed_zip_summary;
