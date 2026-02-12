# NYC Dog Licensing Data Pipeline

Data engineering and analytical exploration of NYC dog licensing data using Python, PostgreSQL, advanced SQL, and NoSQL performance benchmarking.

## Overview
This project builds an end-to-end data engineering and analytics pipeline using the NYC Dog Licensing dataset. It demonstrates ETL processes, relational schema design, SQL optimization, and performance comparison between PostgreSQL and MongoDB.

## Key Components
- Python-based ETL and data cleaning
- Normalized PostgreSQL schema with constraints and indexing
- Advanced SQL queries (CTEs, window functions, materialized views)
- Query performance benchmarking using EXPLAIN ANALYZE
- NoSQL replication and index comparison using MongoDB
- Role-based access control implementation

## NoSQL Component (MongoDB)
MongoDB was used in the original project to replicate a subset of the relational data using a document-oriented schema and to compare indexing and query performance against PostgreSQL. The MongoDB implementation and benchmarks are discussed in the accompanying project report; this repository focuses on the core relational pipeline and analytics artifacts.


## Technologies Used
- Python (pandas, SQLAlchemy, psycopg2)
- PostgreSQL
- MongoDB
- SQL (DDL, DML, indexing, analytics)
- Altair / Matplotlib (visualization)

## Repository Structure
notebooks/   → Python notebooks for ETL, data cleaning, analysis, and visualization  
sql/         → PostgreSQL DDL, views, indexes, and analytical queries  
reports/     → Figures, charts, and supporting screenshots  
data/        → Dataset documentation and access instructions (raw data not stored)
