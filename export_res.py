import sys
import exasol as exa

scriptname = sys.argv[1]
conn = sys.argv[2]
schemaFilter = sys.argv[3]
tableFilter = sys.argv[4]

C = exa.connect(Driver = 'EXAODBC', EXAHOST = os.environ['ODBC_HOST'], EXAUID = os.environ['EXAUSER'], EXAPWD = os.environ['EXAPW'])
#C = exa.connect(dsn='test_dsn')
f = open("output.sql", "w")
query = "execute script database_migration." + scriptname + "('" + conn + "', TRUE, '" + schemaFilter + "', '" + tableFilter +"')"
print(query)
R = C.odbc.execute(query)
output = R.fetchall()
nrows = R.rowcount
for i in range(0, nrows):
  print(output[i][0])
  f.write(output[i][0] + "\n")
f.close()