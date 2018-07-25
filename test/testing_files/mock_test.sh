#!/bin/bash
MY_MESSAGE="Starting mock test installing python-exasol!"
echo $MY_MESSAGE

PYTHONPATH=$HOME/exa_py/lib/python2.7/site-packages python test/mock_test.py

#to test locally
#python_path="C:\Users\erll\AppData\Local\Continuum\anaconda2\python.exe"
#$python_path mock_test.py