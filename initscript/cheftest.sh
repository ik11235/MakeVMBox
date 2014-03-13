#!/bin/sh


COOKBOOKS=(`ruby ./cheflist.rb`)
COOKBOOKS+=("exit")


echo "select install COOKBOOKS"
echo "quit to typing \"exit-num(${#COOKBOOKS[*]})\""


SELECTBOOKS=();
select BOOKS in ${COOKBOOKS[@]}
do
if [ -z "${BOOKS}" ]; then    
    continue;
elif [ "${BOOKS}" = "exit" ]; then
    echo "in exit"
    break;
else
    SELECTBOOKS+=(${BOOKS});    
fi

echo "select install COOKBOOKS"
echo 'quit to typing "exit-num(${#COOKBOOKS[*]})"'
echo "Now select package : ${SELECTBOOKS[@]}"

done
