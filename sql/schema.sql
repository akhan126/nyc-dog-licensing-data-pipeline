
-- FULL DATABASE RESET (for verification/trial runs)

DROP TABLE IF EXISTS dogs CASCADE;
DROP TABLE IF EXISTS zipcodes CASCADE;
DROP TABLE IF EXISTS breeds CASCADE;



-- LOOKUP TABLE: Breeds

CREATE TABLE breeds (
    breed_id     SERIAL PRIMARY KEY,
    breed_name   TEXT NOT NULL UNIQUE
);



-- LOOKUP TABLE: Zip Codes

CREATE TABLE zipcodes (
    zip_id       SERIAL PRIMARY KEY,
    zip_code     VARCHAR(5) NOT NULL UNIQUE,
    CONSTRAINT zip_format CHECK (zip_code ~ '^[0-9]{5}$')
);



-- FACT TABLE: Dogs

CREATE TABLE dogs (
    dog_id               SERIAL PRIMARY KEY,

    animal_name          TEXT NOT NULL, --data will be cleaned first
    animal_gender        CHAR(1),
    animal_birth_year    INT,
    license_issued_date  DATE NOT NULL,
    license_expired_date DATE,
    extract_year         INT,

    breed_id             INT NOT NULL REFERENCES breeds(breed_id),
    zip_id               INT NOT NULL REFERENCES zipcodes(zip_id),

    -- Prevent duplicate records when loading ETL batches
    CONSTRAINT unique_dog_record UNIQUE (
        animal_name,
        animal_gender,
        animal_birth_year,
        license_issued_date,
        breed_id,
        zip_id
    )
);



-- INDEXES FOR PERFORMANCE

-- (1) Optimizes breed-level filtering, grouping, frequency counts
CREATE INDEX idx_dogs_breed_id ON dogs(breed_id);

-- (2) Speeds up geographic analysis (ZIP-level distribution)
CREATE INDEX idx_dogs_zip_id ON dogs(zip_id);

-- (3) Critical for time-series reporting (licenses per year)
CREATE INDEX idx_dogs_extract_year ON dogs(extract_year);


-- DATA QUALITY CONSTRAINTS
-- ========================

-- Ensure breed names are not empty
ALTER TABLE breeds 
ADD CONSTRAINT breed_name_not_empty 
CHECK (breed_name <> '' AND breed_name IS NOT NULL);

-- Only allow M, F, or U
ALTER TABLE dogs 
ADD CONSTRAINT valid_gender 
CHECK (animal_gender IN ('M', 'F', 'U'));

-- Birth years must be realistic
ALTER TABLE dogs 
ADD CONSTRAINT valid_birth_year 
CHECK (animal_birth_year BETWEEN 1990 AND EXTRACT(YEAR FROM CURRENT_DATE));

-- Issued date must be <= expired date (allow null expiration)
ALTER TABLE dogs 
ADD CONSTRAINT dates_chronological
CHECK (
    license_expired_date IS NULL 
    OR license_issued_date <= license_expired_date
);



-- ADDITIONAL FIELDS / INDEXES
-- ===========================

-- Audit timestamp
ALTER TABLE dogs 
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Combined index for date-range queries
CREATE INDEX idx_dogs_license_dates 
ON dogs(license_issued_date, license_expired_date);



-- DOCUMENTATION COMMENTS
-- ======================
COMMENT ON TABLE dogs 
    IS 'Core fact table containing licensed dog records in NYC';

COMMENT ON COLUMN dogs.extract_year 
    IS 'Year when this record was extracted from the source dataset';

COMMENT ON TABLE breeds 
    IS 'Lookup table for dog breeds, normalized to prevent duplication';

COMMENT ON TABLE zipcodes 
    IS 'Lookup table for 5-digit NYC ZIP codes';

-- END OF SCHEMA
