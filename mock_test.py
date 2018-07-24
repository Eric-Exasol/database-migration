import exasol as E
import os

print(os.environ['EXAODBC'] + os.environ['ODBC_HOST']
C = E.connect(Driver = os.environ['EXAODBC'], EXAHOST = '127.0.0.1:8888', EXAUID = 'sys', EXAPWD = 'exasol')
R = C.readData("SELECT 'connection works' FROM dual")
print(R)