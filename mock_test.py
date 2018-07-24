import exasol as E
import os

C = E.connect(Driver = os.environ['EXAODBC'], EXAHOST = os.environ['ODBC_HOST'], EXAUID = os.environ['EXAUSER'], EXAPWD = os.environ['EXAPW'])
R = C.readData("SELECT 'connection works' FROM dual")
print(R)