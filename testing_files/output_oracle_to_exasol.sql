-- session parameter values are being taken from Oracle systemwide database_parameters and converted. However these should be confirmed before use.
-- Oracle DB's NLS_CHARACTERSET is set to : WE8MSWIN1252
-- ALTER SESSION SET NLS_DATE_LANGUAGE='AMERICAN';
-- ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YY';
-- ALTER SESSION SET NLS_TIMESTAMP_FORMAT='DD-MON-YY HH.MI.SS.FF6 AM';
create schema if not exists "ERIC";
create or replace table "ERIC"."NUMERIC_TYPES" ( 
"MY_NUMBER" double precision, 
"MY_NUMBER2" DECIMAL(36,0), 
"MY_NUMBER3" DECIMAL(36,36), 
"MY_NUMBER4" DECIMAL(10,5), 
"MY_FLOAT" double precision, 
"MY_FLOAT2" double precision, 
"MY_BINFLOAT" double precision, 
"MY_BINDOUBLE" double precision
)
;
create or replace table "ERIC"."DATE_TYPES" ( 
"MY_DATE" timestamp, 
"MY_TIMESTAMP" timestamp, 
"MY_TIMESTAMP2" timestamp, 
"MY_TIMESTAMP3" timestamp, 
"MY_TIMESTAMPWTZ" timestamp, 
"MY_TIMESTAMPWLTZ" timestamp, 
"MY_INTERVALYM" varchar(2000000) /* UNSUPPORTED DATA TYPE : INTERVAL YEAR(2) TO MONTH */ , 
"MY_INTERVALDS" varchar(2000000) /* UNSUPPORTED DATA TYPE : INTERVAL DAY(2) TO SECOND(6) */ 
)
;
create or replace table "ERIC"."STRING_TYPES" ( 
"MY_CHAR" char(50), 
"MY_NCHAR" char(99), 
"MY_VARCHAR" varchar(250), 
"MY_VARCHAR2" varchar(25), 
"MY_NVARCHAR2" varchar(50), 
"MY_RAW" varchar(2000000) /* UNSUPPORTED DATA TYPE : RAW */ , 
"MY_LONG" varchar(2000000) /* UNSUPPORTED DATA TYPE : LONG */ , 
"MY_BLOB" varchar(2000000) /* UNSUPPORTED DATA TYPE : BLOB */ , 
"MY_CLOB" varchar(2000000), 
"MY_NCLOB" varchar(2000000) /* UNSUPPORTED DATA TYPE : NCLOB */ 
)
;
create or replace table "ERIC"."DECIMAL_TYPES" ( 
"MY_DECIMAL" DECIMAL(36,36), 
"MY_DECIMAL2" DECIMAL(11,11), 
"MY_DECIMAL3" DECIMAL(36,36), 
"MY_DECIMAL4" DECIMAL(36,10), 
"MY_DECIMAL5" DECIMAL(15,10)
)
;
import into "ERIC"."STRING_TYPES"( "MY_CHAR", 
	"MY_NCHAR", 
	"MY_VARCHAR", 
	"MY_VARCHAR2", 
	"MY_NVARCHAR2", 
	"MY_CLOB") from JDBC at MY_ORACLE statement 
'select 
"MY_CHAR", 
	"MY_NCHAR", 
	"MY_VARCHAR", 
	"MY_VARCHAR2", 
	"MY_NVARCHAR2", 
	"MY_CLOB" from "ERIC"."STRING_TYPES"';
import into "ERIC"."DECIMAL_TYPES"( "MY_DECIMAL", 
	"MY_DECIMAL2", 
	"MY_DECIMAL3", 
	"MY_DECIMAL4", 
	"MY_DECIMAL5") from JDBC at MY_ORACLE statement 
'select 
"MY_DECIMAL", 
	"MY_DECIMAL2", 
	"MY_DECIMAL3", 
	"MY_DECIMAL4", 
	"MY_DECIMAL5" from "ERIC"."DECIMAL_TYPES"';
import into "ERIC"."DATE_TYPES"( "MY_DATE", 
	"MY_TIMESTAMP", 
	"MY_TIMESTAMP2", 
	"MY_TIMESTAMP3", 
	"MY_TIMESTAMPWTZ", 
	"MY_TIMESTAMPWLTZ") from JDBC at MY_ORACLE statement 
'select 
"MY_DATE", 
	"MY_TIMESTAMP", 
	"MY_TIMESTAMP2", 
	"MY_TIMESTAMP3", 
	cast("MY_TIMESTAMPWTZ" as TIMESTAMP), 
	cast("MY_TIMESTAMPWLTZ" as TIMESTAMP) from "ERIC"."DATE_TYPES"';
import into "ERIC"."NUMERIC_TYPES"( "MY_NUMBER", 
	"MY_NUMBER2", 
	"MY_NUMBER3", 
	"MY_NUMBER4", 
	"MY_FLOAT", 
	"MY_FLOAT2", 
	"MY_BINFLOAT", 
	"MY_BINDOUBLE") from JDBC at MY_ORACLE statement 
'select 
"MY_NUMBER", 
	"MY_NUMBER2", 
	"MY_NUMBER3", 
	"MY_NUMBER4", 
	cast("MY_FLOAT" as DOUBLE PRECISION), 
	cast("MY_FLOAT2" as DOUBLE PRECISION), 
	cast("MY_BINFLOAT" as DOUBLE PRECISION), 
	cast("MY_BINDOUBLE" as DOUBLE PRECISION) from "ERIC"."NUMERIC_TYPES"';