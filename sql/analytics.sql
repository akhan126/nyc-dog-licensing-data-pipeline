-- ============================================
-- Part 3: SQL Exploration & Analytics
-- NYC Dog Licensing Project
-- ============================================

-- 1) Single-table aggregation (GROUP BY)
SELECT
    breed_id,
    COUNT(*) AS total_dogs
FROM dogs
GROUP BY breed_id;


-- 2) Multi-table INNER JOIN
SELECT
    d.dog_id,
    b.breed_name,
    z.zip_code
FROM dogs d
JOIN breeds b ON d.breed_id = b.breed_id
JOIN zipcodes z ON d.zip_id = z.zip_id;


-- 3) LEFT JOIN (data quality check)
SELECT
    d.dog_id,
    b.breed_name
FROM dogs d
LEFT JOIN breeds b ON d.breed_id = b.breed_id
WHERE b.breed_id IS NULL;


-- 4) Window function (RANK)
SELECT
    zip_id,
    breed_id,
    COUNT(*) AS breed_count,
    RANK() OVER (
        PARTITION BY zip_id
        ORDER BY COUNT(*) DESC
    ) AS breed_rank
FROM dogs
GROUP BY zip_id, breed_id;


-- 5) CTE (Common Table Expression)
WITH yearly_counts AS (
    SELECT
        extract_year,
        COUNT(*) AS total_licenses
    FROM dogs
    GROUP BY extract_year
)
SELECT *
FROM yearly_counts;


-- 6) Derived metric (ALTER TABLE + UPDATE)
ALTER TABLE dogs
ADD COLUMN dog_age INT;

UPDATE dogs
SET dog_age = EXTRACT(YEAR FROM CURRENT_DATE) - animal_birth_year;


-- 7) EXPLAIN ANALYZE example
EXPLAIN ANALYZE
SELECT *
FROM dogs
WHERE license_issued_date >= '2022-01-01';


-- 8) Materialized view
CREATE MATERIALIZED VIEW breed_zip_summary AS
SELECT
    breed_id,
    zip_id,
    COUNT(*) AS total_dogs
FROM dogs
GROUP BY breed_id, zip_id;

-- Refresh strategy
REFRESH MATERIALIZED VIEW breed_zip_summary;
