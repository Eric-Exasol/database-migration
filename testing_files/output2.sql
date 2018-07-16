EXAplus 6.0.10 (c) EXASOL AG

Thursday, July 12, 2018 at 11:22:41 AM Central European Summer Time
Connected to database EXAone as user sys.
EXASolution 6.1.beta1 (c) EXASOL AG

EXA: create schema if not exists database_migration;

Rows affected: 0

EXA: create or replace script database_migration.MYSQL_TO_EXASOL2(...

Rows affected: 0

EXA: create or replace connection mysql_conn ...

Rows affected: 0

EXA: execute script database_migration.MYSQL_TO_EXASOL2('mysql_conn' --name...

SQL_TEXT                                                                                                                                                                                                
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ### SCHEMAS ###                                                                                                                                                                                      
create schema if not exists "TESTING_DATATYPES_SCHEMA";                                                                                                                                                 
-- ### TABLES ###                                                                                                                                                                                       
create or replace table "TESTING_DATATYPES_SCHEMA"."DATE_TYPES" ("MY_DATE" DATE,"MY_DATETIME" TIMESTAMP,"MY_TIMESTAMP" TIMESTAMP,"MY_TIME" varchar(8),"MY_YEAR" varchar(4));                            
create or replace table "TESTING_DATATYPES_SCHEMA"."DECIMAL_TYPES" ("MY_DECIMAL" decimal(36,30),"MY_DECIMAL2" decimal(16,11),"MY_DECIMAL3" decimal(36,30),"MY_DECIMAL4" decimal(36,10),"MY_DECIMAL5" dec
imal(15,10));                                                                                                                                                                                           
create or replace table "TESTING_DATATYPES_SCHEMA"."NUMERIC_TYPES" ("MY_TINYINT" DECIMAL(4,0),"MY_SMALLINT" DECIMAL(5,0),"MY_MEDIUMINT" DECIMAL(9,0),"MY_INT" DECIMAL(11,0),"MY_BIGINT" DECIMAL (20,0),"
MY_DECIMAL" decimal(36,30),"MY_FLOAT" FLOAT,"MY_DOUBLE" DOUBLE);                                                                                                                                        
create or replace table "TESTING_DATATYPES_SCHEMA"."SPATIAL_TYPES" ("MY_GEOMETRY" GEOMETRY,"MY_POINT" GEOMETRY,"MY_LINESTRING" GEOMETRY,"MY_POLYGON" GEOMETRY,"MY_GC" GEOMETRY);                        
create or replace table "TESTING_DATATYPES_SCHEMA"."STRING_TYPES" ("MY_CHAR" CHAR(255),"MY_VARCHAR" VARCHAR(255),"MY_BINARY" char(255),"MY_VARBINARY" varchar(255),"MY_TINYBLOB" varchar(2000000),"MY_BL
OB" varchar(2000000),"MY_MEDIUMBLOB" varchar(2000000),"MY_LONGBLOB" varchar(2000000),"MY_TINYTEXT" varchar(2000000),"MY_TEXT" varchar(2000000),"MY_MEDIUMTEXT" varchar(2000000),"MY_LONGTEXT" varchar(20
00000),"MY_ENUM" varchar(2000000),"MY_SET" varchar(2000000));                                                                                                                                           
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_BIT" ("MY_BIT" DECIMAL(1,0));                                                                                                                  
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_JSON2" ("ID" DECIMAL(11,0));                                                                                                                   
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_JSON3" ("ID" DECIMAL(11,0),"STRING" VARCHAR(20));                                                                                              
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_JSON4" ("STRING" VARCHAR(20));                                                                                                                 
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_TIME" ("MY_TIME" varchar(8));                                                                                                                  
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_YEAR" ("MY_YEAR" varchar(4));                                                                                                                  
-- ### IMPORTS ###                                                                                                                                                                                      
import into "TESTING_DATATYPES_SCHEMA"."DATE_TYPES" from jdbc at mysql_conn statement 'select `my_date`,`my_datetime`,`my_timestamp`,cast(`my_time` as char(8)),cast(`my_year` as char(4)) from testing_
datatypes_schema.date_types';                                                                                                                                                                           
import into "TESTING_DATATYPES_SCHEMA"."DECIMAL_TYPES" from jdbc at mysql_conn statement 'select `my_decimal`,`my_decimal2`,`my_decimal3`,`my_decimal4`,`my_decimal5` from testing_datatypes_schema.deci
mal_types';                                                                                                                                                                                             
import into "TESTING_DATATYPES_SCHEMA"."NUMERIC_TYPES" from jdbc at mysql_conn statement 'select `my_tinyint`,`my_smallint`,`my_mediumint`,`my_int`,`my_bigint`,`my_decimal`,`my_float`,`my_double` from
 testing_datatypes_schema.numeric_types';                                                                                                                                                               
import into "TESTING_DATATYPES_SCHEMA"."SPATIAL_TYPES" from jdbc at mysql_conn statement 'select AsText(`my_geometry`),AsText(`my_point`),AsText(`my_linestring`),AsText(`my_polygon`),AsText(`my_gc`) f
rom testing_datatypes_schema.spatial_types';                                                                                                                                                            
import into "TESTING_DATATYPES_SCHEMA"."STRING_TYPES" from jdbc at mysql_conn statement 'select `my_char`,`my_varchar`,cast(`my_binary` as char(255)),cast(`my_varbinary` as char(255)),cast(`my_tinyblo
b` as char(2000000)),cast(`my_blob` as char(2000000)),cast(`my_mediumblob` as char(2000000)),cast(`my_longblob` as char(2000000)),`my_tinytext`,`my_text`,`my_mediumtext`,`my_longtext`,`my_enum`,`my_se
t` from testing_datatypes_schema.string_types';                                                                                                                                                         
import into "TESTING_DATATYPES_SCHEMA"."TEST_BIT" from jdbc at mysql_conn statement 'select cast(`my_bit` as DECIMAL(1,0)) from testing_datatypes_schema.test_bit';                                     
import into "TESTING_DATATYPES_SCHEMA"."TEST_JSON2" from jdbc at mysql_conn statement 'select `id` from testing_datatypes_schema.test_json2';                                                           
import into "TESTING_DATATYPES_SCHEMA"."TEST_JSON3" from jdbc at mysql_conn statement 'select `id`,`string` from testing_datatypes_schema.test_json3';                                                  
import into "TESTING_DATATYPES_SCHEMA"."TEST_JSON4" from jdbc at mysql_conn statement 'select `string` from testing_datatypes_schema.test_json4';                                                       
import into "TESTING_DATATYPES_SCHEMA"."TEST_TIME" from jdbc at mysql_conn statement 'select cast(`my_time` as char(8)) from testing_datatypes_schema.test_time';                                       
import into "TESTING_DATATYPES_SCHEMA"."TEST_YEAR" from jdbc at mysql_conn statement 'select cast(`my_year` as char(4)) from testing_datatypes_schema.test_year';                                       

26 rows in resultset.


Disconnected.
EXAplus 6.0.10 (c) EXASOL AG

Thursday, July 12, 2018 at 11:44:58 AM Central European Summer Time
Connected to database EXAone as user sys.
EXASolution 6.1.beta1 (c) EXASOL AG

EXA: create schema if not exists database_migration;

Rows affected: 0

EXA: create or replace script database_migration.MYSQL_TO_EXASOL2(...

Rows affected: 0

EXA: create or replace connection mysql_conn ...

Rows affected: 0

EXA: execute script database_migration.MYSQL_TO_EXASOL2('mysql_conn' --name...

SQL_TEXT                                                                                                                                                                                                
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ### SCHEMAS ###                                                                                                                                                                                      
create schema if not exists "TESTING_DATATYPES_SCHEMA";                                                                                                                                                 
-- ### TABLES ###                                                                                                                                                                                       
create or replace table "TESTING_DATATYPES_SCHEMA"."DATE_TYPES" ("MY_DATE" DATE,"MY_DATETIME" TIMESTAMP,"MY_TIMESTAMP" TIMESTAMP,"MY_TIME" varchar(8),"MY_YEAR" varchar(4));                            
create or replace table "TESTING_DATATYPES_SCHEMA"."DECIMAL_TYPES" ("MY_DECIMAL" decimal(36,30),"MY_DECIMAL2" decimal(16,11),"MY_DECIMAL3" decimal(36,30),"MY_DECIMAL4" decimal(36,10),"MY_DECIMAL5" dec
imal(15,10));                                                                                                                                                                                           
create or replace table "TESTING_DATATYPES_SCHEMA"."NUMERIC_TYPES" ("MY_TINYINT" DECIMAL(4,0),"MY_SMALLINT" DECIMAL(5,0),"MY_MEDIUMINT" DECIMAL(9,0),"MY_INT" DECIMAL(11,0),"MY_BIGINT" DECIMAL (20,0),"
MY_DECIMAL" decimal(36,30),"MY_FLOAT" FLOAT,"MY_DOUBLE" DOUBLE);                                                                                                                                        
create or replace table "TESTING_DATATYPES_SCHEMA"."SPATIAL_TYPES" ("MY_GEOMETRY" GEOMETRY,"MY_POINT" GEOMETRY,"MY_LINESTRING" GEOMETRY,"MY_POLYGON" GEOMETRY,"MY_GC" GEOMETRY);                        
create or replace table "TESTING_DATATYPES_SCHEMA"."STRING_TYPES" ("MY_CHAR" CHAR(255),"MY_VARCHAR" VARCHAR(255),"MY_BINARY" char(255),"MY_VARBINARY" varchar(255),"MY_TINYBLOB" varchar(2000000),"MY_BL
OB" varchar(2000000),"MY_MEDIUMBLOB" varchar(2000000),"MY_LONGBLOB" varchar(2000000),"MY_TINYTEXT" varchar(2000000),"MY_TEXT" varchar(2000000),"MY_MEDIUMTEXT" varchar(2000000),"MY_LONGTEXT" varchar(20
00000),"MY_ENUM" varchar(2000000),"MY_SET" varchar(2000000));                                                                                                                                           
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_BIT" ("MY_BIT" DECIMAL(1,0));                                                                                                                  
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_JSON2" ("ID" DECIMAL(11,0));                                                                                                                   
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_JSON3" ("ID" DECIMAL(11,0),"STRING" VARCHAR(20));                                                                                              
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_JSON4" ("STRING" VARCHAR(20));                                                                                                                 
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_TIME" ("MY_TIME" varchar(8));                                                                                                                  
create or replace table "TESTING_DATATYPES_SCHEMA"."TEST_YEAR" ("MY_YEAR" varchar(4));                                                                                                                  
-- ### IMPORTS ###                                                                                                                                                                                      
import into "TESTING_DATATYPES_SCHEMA"."DATE_TYPES" from jdbc at mysql_conn statement 'select `my_date`,`my_datetime`,`my_timestamp`,cast(`my_time` as char(8)),cast(`my_year` as char(4)) from testing_
datatypes_schema.date_types';                                                                                                                                                                           
import into "TESTING_DATATYPES_SCHEMA"."DECIMAL_TYPES" from jdbc at mysql_conn statement 'select `my_decimal`,`my_decimal2`,`my_decimal3`,`my_decimal4`,`my_decimal5` from testing_datatypes_schema.deci
mal_types';                                                                                                                                                                                             
import into "TESTING_DATATYPES_SCHEMA"."NUMERIC_TYPES" from jdbc at mysql_conn statement 'select `my_tinyint`,`my_smallint`,`my_mediumint`,`my_int`,`my_bigint`,`my_decimal`,`my_float`,`my_double` from
 testing_datatypes_schema.numeric_types';                                                                                                                                                               
import into "TESTING_DATATYPES_SCHEMA"."SPATIAL_TYPES" from jdbc at mysql_conn statement 'select AsText(`my_geometry`),AsText(`my_point`),AsText(`my_linestring`),AsText(`my_polygon`),AsText(`my_gc`) f
rom testing_datatypes_schema.spatial_types';                                                                                                                                                            
import into "TESTING_DATATYPES_SCHEMA"."STRING_TYPES" from jdbc at mysql_conn statement 'select `my_char`,`my_varchar`,cast(`my_binary` as char(255)),cast(`my_varbinary` as char(255)),cast(`my_tinyblo
b` as char(2000000)),cast(`my_blob` as char(2000000)),cast(`my_mediumblob` as char(2000000)),cast(`my_longblob` as char(2000000)),`my_tinytext`,`my_text`,`my_mediumtext`,`my_longtext`,`my_enum`,`my_se
t` from testing_datatypes_schema.string_types';                                                                                                                                                         
import into "TESTING_DATATYPES_SCHEMA"."TEST_BIT" from jdbc at mysql_conn statement 'select cast(`my_bit` as DECIMAL(1,0)) from testing_datatypes_schema.test_bit';                                     
import into "TESTING_DATATYPES_SCHEMA"."TEST_JSON2" from jdbc at mysql_conn statement 'select `id` from testing_datatypes_schema.test_json2';                                                           
import into "TESTING_DATATYPES_SCHEMA"."TEST_JSON3" from jdbc at mysql_conn statement 'select `id`,`string` from testing_datatypes_schema.test_json3';                                                  
import into "TESTING_DATATYPES_SCHEMA"."TEST_JSON4" from jdbc at mysql_conn statement 'select `string` from testing_datatypes_schema.test_json4';                                                       
import into "TESTING_DATATYPES_SCHEMA"."TEST_TIME" from jdbc at mysql_conn statement 'select cast(`my_time` as char(8)) from testing_datatypes_schema.test_time';                                       
import into "TESTING_DATATYPES_SCHEMA"."TEST_YEAR" from jdbc at mysql_conn statement 'select cast(`my_year` as char(4)) from testing_datatypes_schema.test_year';                                       

26 rows in resultset.


Disconnected.
