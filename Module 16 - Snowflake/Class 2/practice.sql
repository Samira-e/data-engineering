CREATE DATABASE DATAXSNOWFLAKE;
CREATE SCHEMA bronze;
USE SCHEMA bronze;

-- Create the File 
CREATE OR REPLACE FILE FORMAT ff_csv
TYPE=CSV
SKIP_HEADER=1
FIELD_DELIMITER=',' 
TRIM_SPACE=TRUE;

-- Create Stage Files
CREATE OR REPLACE STAGE stg_orders 
FILE_FORMAT=ff_csv;

CREATE OR REPLACE STAGE stg_customers
FILE_FORMAT=ff_csv;


-- Create Table orders_raw
CREATE OR REPLACE TABLE orders_raw (
  order_id NUMBER,
  customer_id STRING,
  product_id STRING,
  order_ts TIMESTAMP_NTZ,
  order_amount NUMBER(10,2),
  order_status STRING
);


-- Create Table customers_raw
CREATE OR REPLACE TABLE customers_raw (
  customer_id STRING,
  customer_name STRING,
  email STRING,
  city STRING,
  updated_at TIMESTAMP_NTZ
);

SELECT * FROM @STG_ORDERS
---- Copy Into Table bronze layers from STAGING
COPY INTO orders_raw FROM @STG_ORDERS ON_ERROR = 'CONTINUE'
COPY INTO CUSTOMERS_RAW FROM @STG_CUSTOMERS ON_ERROR= 'CONTINUE'


SELECT * FROM ORDERS_RAW

SELECT * FROM CUSTOMERS_RAW

SELECT * FROM INFORMATION_SCHEMA.LOAD_HISTORY
ORDER BY LAST_LOAD_TIME






