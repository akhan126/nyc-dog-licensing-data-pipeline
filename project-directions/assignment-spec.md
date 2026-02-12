# Course Project Assignment Specification

This document contains the original project requirements provided by the instructor.
It is included here for reference and grading context.

**Course:** Database Systems & Data Preparation  
**Dataset Used:** NYC Dog Licensing Data  

Project Overview
You will work through the complete data‐project lifecycle on a real, multi‐fi le open dataset of your choice (or select from the instructor’s list). Starting with raw CSV/JSON fi les you will design a relational schema, load and clean the data, explore it with SQL, push the analysis further with Python, and fi nally refl ect on ethical and performance considerations.
Tooling Requirements
● PostgreSQL (or SQLite if local install is a barrier)
● Python 3.x with: pandas, SQLAlchemy/psycopg2, matplotlib or seaborn, and one optional library of your choice (e.g., scikit-learn, plotly, pyspark).
● Jupyter Notebook or a reproducible .py script for each part.
● Git (private repo) for version control and submission.
Data Choices
● NYC 311 Service Requests (CSV, 8 M rows)
● COVID-19 U.S. county-level time series (CSV)
● LendingClub loan statistics (CSV + JSON)
● NOAA hourly weather (“ISD Lite”) (fi xed-width text)
● Reddit comment dumps (JSON)
You may propose a diff erent public dataset if (a) ≥ 300 K rows or ≥ 1 GB uncompressed and (b) it contains at least three logical entity types. Approval due by Project Milestone 0.
Part 0 – Proposal & ER Diagram (10 pts, but required)
• 1-page proposal with a draft ERD and data source links.
Part 1 – Schema Design & Database Build (30 pts)
A. Conceptual → logical mapping (10 pts)
• Final ER diagram with entities, relationships, PKs, FKs.
B. SQL DDL script (15 pts)
• CREATE TABLE statements with constraints & appropriate data types.
• 2+ indexes and justifi cation.
C. Data-volume sanity check (5 pts)
• Short Python script that counts rows & reports NULL/invalid counts per table.
Part 2 – Data Ingestion & Preparation (40 pts)
A. ETL in Python (25 pts)
• Read raw fi les, handle encoding issues, convert data types, standardize units/dates.
• Insert into DB in chunks (COPY or executemany) with timing logs.
B. Data-quality notebook (15 pts)
• Missing-value profi le, outlier detection, at least two transformations (e.g., binning, scaling, text cleaning), written justifi cation for each.
Part 3 – SQL Exploration & Analytics (40 pts)
Write and save eight SQL views or queries that demonstrate:
1. Single-table aggregation (GROUP BY)
2. Multi-table join (INNER)
3. Outer join or sub-query
4. Window/analytic function
5. CTE or recursive query
6. Derived metric updated with ALTER TABLE + UPDATE
7. Index-usage demonstration with EXPLAIN (before/after)
8. Creation of a materialized view or standard view + refresh strategy
Each query: 5 pts × 8 = 40 pts. Graded on correctness, readability, and brief written interpretation (2-3 sentences each).
Part 4 – Python Analysis & Visualization (40 pts)
A. Exploratory notebook (20 pts)
• Use pandas-SQLAlchemy connection to pull data.
• At least three visualizations (one must be interactive or geospatial if data allow).
• Narrative explaining trends, anomalies, and limitations.
B. Mini-model or advanced technique (20 pts)
Choose ONE: regression, classifi cation, clustering, time-series forecasting, or network analysis. Include train/test split, metric evaluation, and a short explanation of why the method is appropriate.
Part 5 – Advanced Topics (30 pts)
Complete two of the following (15 pts each). Indicate your choices in the proposal.
1. NoSQL replication: push a subset of data to MongoDB, design an appropriate document model, and compare a sample query’s performance vs. PostgreSQL.
2. Access-control & security: create two DB roles (analyst, guest) with diff erent privileges and demonstrate them through failed/successful query screenshots; include short discussion of HIPAA/GLBA relevance to your dataset.
3. Effi ciency study: benchmark three diff erent indexing or partitioning strategies (e.g., hash vs. B-tree; range partitioning) and graph query latency.
4. SUGGEST your OWN ADVANCED TOPIC (It should be an implementation or a code based specifi c task that would qualify under advanced topics, you can propose this in our one to one fi nal project meetings/reviews).
