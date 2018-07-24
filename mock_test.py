import exasol as E
C = E.connect(dsn='test_dsn')
R = C.readData("SELECT 'connection works' FROM dual")
print(R)