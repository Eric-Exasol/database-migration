import exasol as E
import os

C = E.connect(dsn='EXAODBC_TEST')
R = C.readData("SELECT 'connection works' FROM dual")
print(R)