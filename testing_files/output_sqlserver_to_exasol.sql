--This SQL Server is system-wide NOT CASE SENSITIVE. There might be exceptions on table or column level.
create schema if not exists "testing";
create or replace table "testing"."dbo_approx_numerics"  ( "my_float" DOUBLE, 
"my_real" DOUBLE
);
create or replace table "testing"."dbo_bin2_string_types"  ( "string" VARCHAR(10)
);
create or replace table "testing"."dbo_bin_string_types"  ( 
);
create or replace table "testing"."dbo_date_types"  ( "my_date" DATE, 
"my_datetime" TIMESTAMP, 
"my_datetime2" TIMESTAMP, 
"my_datetimeOff" TIMESTAMP, 
"my_smalldt" TIMESTAMP, 
"my_time" TIMESTAMP
);
create or replace table "testing"."dbo_datetimeoffset"  ( "dto" TIMESTAMP
);
create or replace table "testing"."dbo_exact_numerics"  ( "my_bigint" DECIMAL(19,0), 
"my_int" DECIMAL(10,0), 
"my_smallint" DECIMAL(5,0), 
"my_tinyint" DECIMAL(3,0), 
"my_money" DECIMAL(19,4), 
"my_smallmoney" DECIMAL(10,4), 
"my_bit" DECIMAL(1,0), 
"my_decimal" DECIMAL(18,0), 
"my_numeric" DECIMAL(18,0)
);
create or replace table "testing"."dbo_long_decimal"  ( "my_long" DECIMAL(36,0)
);
create or replace table "testing"."dbo_long_numeric"  ( "my_long" DECIMAL(36,36)
);
create or replace table "testing"."dbo_other_types"  ( "my_hierarchyid" VARCHAR(2000000), 
"my_xml" VARCHAR(2000000)
);
create or replace table "testing"."dbo_spatial_types"  ( "my_geom" GEOMETRY, 
"my_geog" GEOMETRY
);
create or replace table "testing"."dbo_string_types"  ( "my_char" CHAR(15), 
"my_varchar" VARCHAR(15), 
"my_varchar2" VARCHAR(2000000), 
"my_text" VARCHAR(2000000), 
"my_nchar" CHAR(20), 
"my_nvarchar" VARCHAR(2000000), 
"my_ntext" VARCHAR(2000000)
);
import into "testing"."dbo_approx_numerics" ( "my_float",
"my_real"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_float],
[my_real]

from [testing].[dbo].[approx_numerics]'
;
import into "testing"."dbo_bin2_string_types" ( "string"
) 
from jdbc at sqlserver_connection statement 
'select 
[string]

from [testing].[dbo].[bin2_string_types]'
;
import into "testing"."dbo_bin_string_types" ( 
) 
from jdbc at sqlserver_connection statement 
'select 


from [testing].[dbo].[bin_string_types]'
;
import into "testing"."dbo_date_types" ( "my_date",
"my_datetime",
"my_datetime2",
"my_datetimeOff",
"my_smalldt",
"my_time"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_date],
[my_datetime],
[my_datetime2],
CONVERT(datetime2, [my_datetimeOff], 1),
[my_smalldt],
cast([my_time] as DateTime)

from [testing].[dbo].[date_types]'
;
import into "testing"."dbo_datetimeoffset" ( "dto"
) 
from jdbc at sqlserver_connection statement 
'select 
CONVERT(datetime2, [dto], 1)

from [testing].[dbo].[datetimeoffset]'
;
import into "testing"."dbo_exact_numerics" ( "my_bigint",
"my_int",
"my_smallint",
"my_tinyint",
"my_money",
"my_smallmoney",
"my_bit",
"my_decimal",
"my_numeric"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_bigint],
[my_int],
[my_smallint],
[my_tinyint],
[my_money],
[my_smallmoney],
[my_bit],
[my_decimal],
[my_numeric]

from [testing].[dbo].[exact_numerics]'
;
import into "testing"."dbo_long_decimal" ( "my_long"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_long]

from [testing].[dbo].[long_decimal]'
;
import into "testing"."dbo_long_numeric" ( "my_long"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_long]

from [testing].[dbo].[long_numeric]'
;
import into "testing"."dbo_other_types" ( "my_hierarchyid",
"my_xml"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_hierarchyid].ToString(),
[my_xml]

from [testing].[dbo].[other_types]'
;
import into "testing"."dbo_spatial_types" ( "my_geom",
"my_geog"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_geom].ToString(),
[my_geog].ToString()

from [testing].[dbo].[spatial_types]'
;
import into "testing"."dbo_string_types" ( "my_char",
"my_varchar",
"my_varchar2",
"my_text",
"my_nchar",
"my_nvarchar",
"my_ntext"
) 
from jdbc at sqlserver_connection statement 
'select 
[my_char],
[my_varchar],
[my_varchar2],
[my_text],
[my_nchar],
[my_nvarchar],
[my_ntext]

from [testing].[dbo].[string_types]'
;