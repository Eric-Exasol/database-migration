import exasol as E
import os

C = E.connect(Driver = '/home/travis/build/Eric-Exasol/database-migration/EXASOL_ODBC-6.0.2/lib/linux/x86_64/libexaodbc-uo2214lv1.so', EXAHOST = os.environ['ODBC_HOST'], EXAUID = os.environ['EXAUSER'], EXAPWD = os.environ['EXAPW'])
R = C.readData("SELECT 'connection works' FROM dual")
print(R)