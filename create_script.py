import sys
import exasol as exa

filename = sys.argv[1]

C = exa.connect(Driver = 'EXAODBC', EXAHOST = os.environ['ODBC_HOST'], EXAUID = os.environ['EXAUSER'], EXAPWD = os.environ['EXAPW'])
#C = exa.connect(dsn='test_dsn')

#puts content of file into data
with open(filename, 'r') as myfile:
    data=myfile.read()

#escapes the ' character to get a conform query
data = data.replace("'","''")
query = "execute script database_migration.GENERATE_SCRIPT('" + data + "')"
print (query)
R = C.odbc.execute(query)
C.odbc.execute("commit;")