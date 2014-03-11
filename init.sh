#!/bin/sh

VEGRANT="vagrant"
VIRTUALBOX="virtualbox"

if [ ! `which ${VIRTUALBOX}` ] || [ ! `which ${VEGRANT}` ]; then
    echo 'Vegrant or VirtualBox not found'
    exit 1;
fi

#veeweeからOSイメージの一覧を確認、選択したOSのイメージ一覧を表示
OSLIST=(`veewee vbox templates | cut -d ' ' -f 5 |cut -d '-' -f 1 |grep -v "available" |  sort |uniq |sed -e s/\'//g`)
echo "What linux distribution do you install?"
select SELECT_OS in ${OSLIST}
do
if [ -z "$SELECT_OS" ]; then
    continue
else
    break
fi
done

echo You selected $REPLY\) $SELECT_OS

##Make version list 
VARLIST=(`veewee vbox templates | grep ${SELECT_OS}| cut -d ' ' -f 5|sed -e s/\'//g|sed -e s/${SELECT_OS}-//g`)

echo "What version do you install?"
select SELECT_VER in ${VARLIST}
do
if [ -z "$SELECT_VER" ]; then
    continue
else
    break
fi
done

echo You selected $REPLY\) $SELECT_VER

echo Install image is ${SELECT_OS}-${SELECT_VER}



#Opscode Public Cookbooksからcehfのcookbookの一覧取得
