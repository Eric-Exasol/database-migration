-- ### SCHEMAS ###
create schema if not exists "TESTING_DATATYPES_SCHEMA";
-- ### TABLES ###
create or replace table "TESTING_DATATYPES_SCHEMA"."DATE_TYPES" ("MY_DATE" DATE,"MY_DATETIME" TIMESTAMP,"MY_TIMESTAMP" TIMESTAMP,"MY_TIME" varchar(8),"MY_YEAR" varchar(4));
create or replace table "TESTING_DATATYPES_SCHEMA"."NUMERIC_TYPES" ("MY_TINYINT" DECIMAL(4,0),"MY_SMALLINT" DECIMAL(5,0),"MY_MEDIUMINT" DECIMAL(9,0),"MY_INT" DECIMAL(11,0),"MY_BIGINT" DECIMAL (20,0),"MY_DECIMAL" DOUBLE,"MY_FLOAT" FLOAT,"MY_DOUBLE" DOUBLE);
create or replace table "TESTING_DATATYPES_SCHEMA"."SPATIAL_TYPES" ("MY_GEOMETRY" GEOMETRY,"MY_POINT" GEOMETRY,"MY_LINESTRING" GEOMETRY,"MY_POLYGON" GEOMETRY,"MY_GC" GEOMETRY);
create or replace table "TESTING_DATATYPES_SCHEMA"."STRING_TYPES" ("MY_CHAR" CHAR(255),"MY_VARCHAR" VARCHAR(255),"MY_BINARY" char(255),"MY_VARBINARY" varchar(255),"MY_TINYBLOB" varchar(2000000),"MY_BLOB" varchar(2000000),"MY_MEDIUMBLOB" varchar(2000000),"MY_LONGBLOB" varchar(2000000),"MY_TINYTEXT" varchar(2000000),"MY_TEXT" varchar(2000000),"MY_MEDIUMTEXT" varchar(2000000),"MY_LONGTEXT" varchar(2000000),"MY_ENUM" varchar(2000000),"MY_SET" varchar(2000000));
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_BIT" ("MY_BIT" DECIMAL(1,0));
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_JSON" ("MY_JSON" /*UNKNOWN_DATATYPE:json*/ varchar(2000000));
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_TIME" ("MY_TIME" varchar(8));
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_YEAR" ("MY_YEAR" varchar(4));
-- ### IMPORTS ###
import into "TESTING_DATATYPES_SCHEMA"."DATE_TYPES" from jdbc at mysql_conn statement 'select `my_date`,`my_datetime`,`my_timestamp`,cast(`my_time` as char(8)),cast(`my_year` as char(4)) from testing_datatypes_schema.date_types';
import into "TESTING_DATATYPES_SCHEMA"."NUMERIC_TYPES" from jdbc at mysql_conn statement 'select `my_tinyint`,`my_smallint`,`my_mediumint`,`my_int`,`my_bigint`,`my_decimal`,`my_float`,`my_double` from testing_datatypes_schema.numeric_types';
import into "TESTING_DATATYPES_SCHEMA"."SPATIAL_TYPES" from jdbc at mysql_conn statement 'select AsText(`my_geometry`),AsText(`my_point`),AsText(`my_linestring`),AsText(`my_polygon`),AsText(`my_gc`) from testing_datatypes_schema.spatial_types';
import into "TESTING_DATATYPES_SCHEMA"."STRING_TYPES" from jdbc at mysql_conn statement 'select `my_char`,`my_varchar`,cast(`my_binary` as char(255)),cast(`my_varbinary` as char(255)),cast(`my_tinyblob` as char(2000000)),cast(`my_blob` as char(2000000)),cast(`my_mediumblob` as char(2000000)),cast(`my_longblob` as char(2000000)),`my_tinytext`,`my_text`,`my_mediumtext`,`my_longtext`,`my_enum`,`my_set` from testing_datatypes_schema.string_types';
import into "TESTING_DATATYPES_SCHEMA"."TEST_BIT" from jdbc at mysql_conn statement 'select cast(`my_bit` as DECIMAL(1,0)) from testing_datatypes_schema.test_bit';
import into "TESTING_DATATYPES_SCHEMA"."TEST_JSON" from jdbc at mysql_conn statement 'select `my_json` from testing_datatypes_schema.test_json';
import into "TESTING_DATATYPES_SCHEMA"."TEST_TIME" from jdbc at mysql_conn statement 'select cast(`my_time` as char(8)) from testing_datatypes_schema.test_time';
import into "TESTING_DATATYPES_SCHEMA"."TEST_YEAR" from jdbc at mysql_conn statement 'select cast(`my_year` as char(4)) from testing_datatypes_schema.test_year';



SELECT * FROM TESTING_DATATYPES_SCHEMA."TEST_TIME";
SELECT * FROM TESTING_DATATYPES_SCHEMA."TEST_YEAR";
SELECT * FROM TESTING_DATATYPES_SCHEMA."TEST_BIT";
SELECT * FROM TESTING_DATATYPES_SCHEMA."DATE_TYPES";
SELECT * FROM TESTING_DATATYPES_SCHEMA."STRING_TYPES";
SELECT * FROM TESTING_DATATYPES_SCHEMA."SPATIAL_TYPES";
SELECT * FROM TESTING_DATATYPES_SCHEMA."TEST_JSON";



