CREATE SCHEMA IF NOT EXISTS DATABASE_MIGRATION;

CREATE OR REPLACE PYTHON SCALAR SCRIPT DATABASE_MIGRATION."S3_GET_FILENAMES" ("force_http" BOOLEAN, "connection_name" VARCHAR(1024), "folder_name" VARCHAR(1024) UTF8, "generate_urls" BOOLEAN, "filter_string" VARCHAR(1024)) 
EMITS ("BUCKET_NAME" VARCHAR(1024) UTF8, "URL" VARCHAR(4096) UTF8, "LAST_MODIFIED" TIMESTAMP) AS
import sys
import glob
# the package boto needs to be installed via EXAoperation first
sys.path.extend(glob.glob('/buckets/bucketfs1/python/*'))
import boto
import boto.s3.connection


#####################################################################################
def s3_connection_helper(connection_name):
    con = exa.get_connection(connection_name)
    aws_key = con.user
    aws_secret = con.password
    address = con.address

    bucket_pos = address.find('://') + 3
    host_pos = address.find('.s3.') + 1

    bucket_name = address[bucket_pos:host_pos-1]
    host_address = address[host_pos:]

    # use sigv4: modify the connection to use the credentials provided below
    if not boto.config.get('s3', 'use-sigv4'):
        boto.config.add_section('s3')
        boto.config.set('s3', 'use-sigv4' , 'True')
    
    if aws_key == '':
        s3conn = boto.s3.connection.S3Connection(host=host_address)
    else:
        s3conn = boto.s3.connection.S3Connection(aws_access_key_id=aws_key, aws_secret_access_key=aws_secret, host=host_address)
    return s3conn, bucket_name;



#####################################################################################

def run(ctx):
    
    s3conn, bucket_name = s3_connection_helper(ctx.connection_name)
    bucket = s3conn.get_bucket(bucket_name,validate=False)
    rs = bucket.list(prefix=ctx.folder_name)
    for key in rs:
      # if not ctx.filter_string checks for empty string
      if not ctx.filter_string or ctx.filter_string in key.name:
        # http://stackoverflow.com/questions/9954521/s3-boto-list-keys-sometimes-returns-directory-key
        if not key.name.endswith('/'):
            if ctx.generate_urls:
                # expires_in: defines the expiry of the url in seconds. It has only an effect if query_auth=True. With value True, a signature is created.
                # query_auth: can also be set to False, if it is not required. Then, no signature is created.
                protocol, filepath = key.generate_url(expires_in=3600,force_http=ctx.force_http,query_auth=True).split('://', 1)
                s3_bucket, localpath = filepath.split('/', 1)
            else:
                localpath = key.name
            
            ctx.emit(bucket_name, localpath, boto.utils.parse_ts(key.last_modified))
/

-- select DATABASE_MIGRATION.s3_get_filenames(true, 'S3_DEST', '', false, '');

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE LUA SCALAR SCRIPT DATABASE_MIGRATION.GET_CONNECTION_NAME(connection_name VARCHAR(2000))
			RETURNS VARCHAR(20000) AS
			function run(ctx)
				url = exa.get_connection(ctx.connection_name).address
				return url
			end
/

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- # parallel_connections: number of parallel files imported in one import statement
-- # file_opts:			 search EXASolution_User_Manual for 'file_opts' to see all possible options
CREATE OR REPLACE LUA SCRIPT DATABASE_MIGRATION.S3_PARALLEL_READ(execute_statements, force_reload, logging_schema, schema_name, table_name, connection_name, folder_name, filter_string, parallel_connections, file_opts) RETURNS TABLE AS

------------------------------------------------------------------------------------------------------------------------
-- returns the string between the two defined strings
-- example: get_string_between('abcdef', 'ab', 'f') --> 'cde'
function get_string_between(str, str_before, str_after)
	_, start_pos = string.find(str, str_before)
	end_pos = string.find(str, str_after)
	return url.sub(str, start_pos+1, end_pos-1)
end

------------------------------------------------------------------------------------------------------------------------

-- function for debugging, prints table
function debug(table)
	if table == nil or table[1] == nil or table[1][1] == nil then
		return
	end

	output(string.rep('-',50))
	for i = 1,#table do
		tmp = ''
		for j = 1,#table[i] do
			tmp = tmp .. table[i][j] ..'	'
		end
		output(tmp)
	end
	output(string.rep('-',50))
end

------------------------------------------------------------------------------------------------------------------------
-- type: 'table' or 'schema'
-- name: name of the table/ schema you want to check
-- returns true if object exists, false if it doesn't exist, second return parameter is error message you can output
function check_exists(type,name)

	-- schema
	if type == 'schema' or type == 's' then
		res = query([[select current_schema]])
		curr_schem = res[1][1]
		suc_schem, res = pquery([[open schema ::s]], {s=name})
		-- restore old schema
		if curr_schem == null then
			query([[close schema]])
		else
			query([[open schema ::cs]],{cs=curr_schem})
		end
		-- check if schema named 'name' existed
		if suc_schem then 
			return true, 'Schema '..name..' already exists'
		else
		 	return false, 'Schema '..name..' does not exist'
		end
	end
	-- table  for table names you should add the schema
	-- like this: check_name('table', 'my_schema.my_table')
	if type == 'table' or type == 't' then
		suc, res = pquery([[desc ::t]],{t=name})
		if suc then 
			return true, 'Table '..name..' already exists'
		else
		 	return false, 'Table '..name..' does not exist'
		end
	end
end

------------------------------------------------------------------------------------------------------------------------

	-- additional parameters that won't need to be modified normally
	generate_urls = false
	force_http = false
	script_schema = quote(exa.meta.script_schema)

	-- quote everything to handle case sensitivity
	logging_schema = quote(logging_schema)
	schema_name = quote(schema_name)
	table_name = quote(table_name)

	ex, msg = check_exists('schema', logging_schema)
	if not ex then error(msg) end

	ex, msg = check_exists('table', schema_name..'.'..table_name)
	if not ex then error(msg) end


	status_done				='done'
	waiting_for_update 		= 'waiting for update'
	waiting_for_insertion 	= 'waiting for insertion'

	-- acquire write lock on the table to prevent transactioin conflicts
	query([[DELETE FROM ::s.::t WHERE FALSE]], {s=schema_name, t=table_name})


	res = query([[select ::ss.GET_CONNECTION_NAME(:c)]], {ss=script_schema, c=connection_name})
	url = res[1][1]

	bucket_name = get_string_between(url, '://', '.s3.')
	-- create a regular name by removing special characters
	logging_table = [["LOG_]].. string.gsub(schema_name, "[^a-zA-Z0-9]", "") .. [[_]] .. string.gsub(table_name, "[^a-zA-Z0-9]", "")..[["]]

	
	query([[CREATE TABLE IF NOT EXISTS ::s.::t (bucket_name varchar(20000), file_name varchar(20000), last_modified timestamp, status varchar(20000))]],
		{s=logging_schema, t=logging_table})

	if(force_reload) then
		query([[TRUNCATE TABLE ::ls.::lt]],{ls= logging_schema, lt= logging_table})
		query([[TRUNCATE TABLE ::s.::t]],{s= schema_name, t= table_name})
	end


	-- update logging table: for all new files, add an entry
	-- for all existing files, update last_modified column and status column
	query([[
		merge into ::ls.::lt as l using 
		( select ::ss.s3_get_filenames(:fh,:c,:fn, :gu, :fi) order by 1) as p
		on p.url = l.file_name and p.bucket_name = l.bucket_name
		WHEN MATCHED THEN UPDATE SET l.status = :wu, l.last_modified = p.last_modified where p.last_modified > l.last_modified or status not = :sd
		WHEN NOT MATCHED THEN INSERT (bucket_name, file_name, last_modified, status) VALUES (p.bucket_name, p.url, p.last_modified, :wi);
	]], {ss=script_schema, fh=force_http, c=connection_name, fn=folder_name, fi=filter_string, gu=generate_urls, ls=logging_schema, lt=logging_table, sd=status_done, wu=waiting_for_update, wi=waiting_for_insertion})


	-- get the bucket name and the file names of the files that should be modified
    local res = query([[
			select * from ::ls.::lt where status like 'waiting%'   
    ]], {ls=logging_schema, lt=logging_table})


	if(#res == 0) then
		exit({{'No queries generated, either bucket is empty or files have already been imported'}}, "message varchar(2000000)") 
	end
	

	-- generate query text for parallel import
    local queries = {}
    local stmt = ''
	local s3_keys = ''
    local pre = "IMPORT INTO ".. schema_name.. ".".. table_name .. " FROM CSV AT "..connection_name

    for i = 1, #res do
		local curr_bucket_name = res[i][1]
		local curr_file_name 	= "'"..res[i][2].."'"
		local curr_last_modified = res[i][3]
		

        if math.fmod(i,parallel_connections) == 1 or parallel_connections == 1 then
            stmt = pre
        end
        stmt = stmt .. "\n\tFILE " .. curr_file_name
		s3_keys = s3_keys ..curr_file_name..", "
        if (math.fmod(i,parallel_connections) == 0 or i == #res) then
            stmt = stmt .. "\n\t"..file_opts..";"
			-- remove the last comma from s3_keys
			s3_keys = string.sub(s3_keys, 0, #s3_keys -2)
            table.insert(queries,{stmt, bucket_name, s3_keys})
			s3_keys = ''
        end
    end

	-- if statements should be only generated, end program here
	if not execute_statements then
		exit(queries, "queries varchar(2000000)")
	end


	local log_tbl = {}
	for i = 1, #queries do
		-- execute query
		curr_query = queries[i][1]
		curr_bucket = queries[i][2]
		curr_files = queries[i][3]
		suc, res = pquery(curr_query)
		if not suc then
			output(res.statement_text)
			status_error = 'Error: '.. res.error_message
			query([[
				update ::ls.::lt set status = :se
				where file_name in (]]..curr_files..[[) and bucket_name = :b
			]],{ls=logging_schema, lt=logging_table, se=status_error, b=curr_bucket})
			table.insert(log_tbl,{'Error while inserting: '.. res.error_message,curr_query, curr_files})
		else	
			query([[
				update ::ls.::lt set status = :sd
				where file_name in (]]..curr_files..[[) and bucket_name = :b
			]],{ls=logging_schema, lt=logging_table, sd = status_done, b=curr_bucket})
			table.insert(log_tbl,{'Inserted',curr_query, curr_files})
		end
		
	end

	exit(log_tbl, "status varchar(20000),executed_queries varchar(2000000),files  varchar(2000000)")
/

CREATE CONNECTION S3_MY_BUCKETNAME
    TO 'http://my_bucketname.s3.my_region.amazonaws.com' -- my_region could e.g. be eu-west-1
    USER 'my_access_key' -- optional, if you don't need user and password, just delete these two lines
    IDENTIFIED BY 'my_secret_key';

execute script DATABASE_MIGRATION.s3_parallel_read(
true						-- if true, statements are executed immediately, if false only statements are generated
, true						-- force reload: if true, table and logging table will be truncated, all files in bucket will be loaded again
, 'S3_IMPORT_LOGGING'		-- schema you want to use for the logging tables
,'PRODUCT'					-- name of the schema that holds the table you want to import into
,'test' 					-- name of the table you want to import into
,'S3_MY_BUCKETNAME'			-- connection name ( see statement above)
,'my_project/' 				-- folder name, if you want to import everything, leave blank
, ''					    -- filter for file-names, to include all files, put empty string, for using only files that include the word banana, put: 'banana'
,2 							-- number of parallel connections you want to use
,'ENCODING=''ASCII'' SKIP=1  ROW SEPARATOR = ''CRLF''' -- file options, see manual, section 'import' for further information
)
;

