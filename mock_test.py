import exasol as E
import os

C = E.connect(Driver = os.environ['EXAODBC'], EXAHOST = os.environ['ODBC_HOST'], EXAUID = 'sys', EXAPWD = 'exasol')
R = C.readData("SELECT 'connection works' FROM dual")
print(R)