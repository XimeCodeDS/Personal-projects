USE ROLE accountadmin;

USE WAREHOUSE compute_wh;

---> create the Tasty Bytes Database
CREATE OR REPLACE DATABASE tasty_bytes_sample_data;

---> create the Raw POS (Point-of-Sale) Schema
CREATE OR REPLACE SCHEMA tasty_bytes_sample_data.raw_pos;

---> create the Raw Menu Table
CREATE OR REPLACE TABLE tasty_bytes_sample_data.raw_pos.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
);

---> create the Stage referencing the Blob location and CSV File Format
CREATE OR REPLACE STAGE tasty_bytes_sample_data.public.blob_stage
url = 's3://sfquickstarts/tastybytes/'
file_format = (type = csv);

---> query the Stage to find the Menu CSV file
LIST @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

---> copy the Menu file into the Menu table
COPY INTO tasty_bytes_sample_data.raw_pos.menu
FROM @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

SELECT COUNT(*)
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE item_category= 'Snack' AND item_subcategory = 'Warm Option';

SELECT DISTINCT item_subcategory FROM tasty_bytes_sample_data.raw_pos.menu

SELECT item_subcategory,
       MAX(sale_price_usd) AS max_price
FROM tasty_bytes_sample_data.raw_pos.menu
GROUP BY 1
ORDER BY 2 DESC;

CREATE WAREHOUSE warehouse_Alex;

SHOW WAREHOUSES;


---> set warehouse size to medium
ALTER WAREHOUSE warehouse_Alex SET warehouse_size=MEDIUM;

USE WAREHOUSE warehouse_Alex;

SELECT
    menu_item_name,
   (sale_price_usd - cost_of_goods_usd) AS profit_usd
FROM tasty_bytes_sample_data.raw_pos.menu
ORDER BY 2 DESC;

---> set warehouse size to xsmall
ALTER WAREHOUSE warehouse_dash SET warehouse_size=XSMALL;

---> drop warehouse
DROP WAREHOUSE warehouse_vino;

SHOW WAREHOUSES;

---> create a multi-cluster warehouse (max clusters = 3)
CREATE WAREHOUSE warehouse_vino MAX_CLUSTER_COUNT = 3;

SHOW WAREHOUSES;

---> set the auto_suspend and auto_resume parameters
ALTER WAREHOUSE warehouse_Alex SET AUTO_SUSPEND = 180 AUTO_RESUME = FALSE;

SHOW WAREHOUSES;


CREATE WAREHOUSE w_one;
CREATE WAREHOUSE w_two;

USE WAREHOUSE w_two;
SHOW WAREHOUSES;

DROP WAREHOUSE w_two;

ALTER WAREHOUSE w_one SET warehouse_size=SMALL;
SHOW WAREHOUSES;

ALTER WAREHOUSE w_one SET AUTO_SUSPEND = 120 AUTO_RESUME = FALSE;
SHOW WAREHOUSES;



-- Databases and schemas

SELECT * FROM TASTY_BYTES.RAW_POS.MENU;

---> see table metadata
SELECT * FROM TASTY_BYTES.INFORMATION_SCHEMA.TABLES;



CREATE DATABASE test_database;

SHOW DATABASES;

---> drop the database
DROP DATABASE test_database;

---> undrop the database
UNDROP DATABASE test_database;

SHOW DATABASES;

---> use a particular database
USE DATABASE test_database;

---> create a schema
CREATE SCHEMA test_schema;

SHOW SCHEMAS;

---> see metadata about your database
DESCRIBE DATABASE TEST_DATABASE;

---> drop a schema
DROP SCHEMA test_schema;

SHOW SCHEMAS;

---> undrop a schema
UNDROP SCHEMA test_schema;

SHOW SCHEMAS;


CREATE DATABASE test_database2;
USE DATABASE test_database2;

USE DATABASE test_database;

CREATE SCHEMA test_schema;

SHOW SCHEMAS;

DESCRIBE DATABASE test_database;

DROP SCHEMA test_schema;
UNDROP SCHEMA test_schema;