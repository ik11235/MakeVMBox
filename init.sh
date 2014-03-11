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
select ANS in ${OSLIST}
do
if [ -z "$ANS" ]; then
    continue
else
    break
fi
done

echo You selected $REPLY\) $ANS




#Opscode Public Cookbooksからcehfのcookbookの一覧取得
