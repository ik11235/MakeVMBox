#!/bin/sh

VEGRANT="vagrant"
VIRTUALBOX="virtualbox"

if [ ! `which ${VIRTUALBOX}` ] || [ ! `which ${VEGRANT}` ]; then
    echo 'Vegrant or VirtualBox not found'
    exit 1;
fi

OSLIST=("Ubuntu" "CentOS" "Debian" "fedora")
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
echo    
case "$ANS" in
    ${OSLIST[1]} ) 
	#ubuntu
	;;
    ${OSLIST[2]} )
        #CentOS
	;;
    ${OSLIST[3]} )
	#Debian
	;;
    ${OSLIST[3]} )
	#fedora
	;;
esac


#veeweeからOSイメージの一覧を確認、選択したOSのイメージ一覧を表示


#Opscode Public Cookbooksからcehfのcookbookの一覧取得
