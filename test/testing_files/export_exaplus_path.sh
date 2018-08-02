#!/bin/bash

exaplus=$(docker exec -ti exasoldb find / -iname 'exaplus' 2> /dev/null) 
echo $exaplus
exaplus=`echo $exaplus | sed 's/\\r//g'`
export exaplus