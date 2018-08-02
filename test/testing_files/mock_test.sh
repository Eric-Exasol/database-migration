#!/bin/bash
MY_MESSAGE="Starting mock test installing python-exasol!"
echo $MY_MESSAGE

$PYTHONPATH python test/mock_test.py
