#!/bin/sh

VEGRANT="vagrant"
VIRTUALBOX="virtualbox"
VEEWEE="veewee"
if [ ! `which ${VIRTUALBOX}` ] || [ ! `which ${VEGRANT}` ]; then
    echo 'Vegrant or VirtualBox not found'
    exit 1;
fi
if [ ! `which ${VEEWEE}` ]; then
    echo 'veewee not found'
    exit 1;
fi

#veeweeからOSイメージの一覧を確認、選択したOSのイメージ一覧を表示
##OSLIST=(`veewee vbox templates | cut -d ' ' -f 5 |cut -d '-' -f 1 |grep -v "available" |  sort |uniq |sed -e s/\'//g`)

TEMPLATES=`veewee vbox templates |cut -d ' ' -f 5|sed -e s/\'//g |grep -v "available"`
OSLIST=(`echo ${TEMPLATES} | perl -pe 's/ /\n/g'|cut -d '-' -f 1|sort|uniq`)

echo "What linux distribution do you install?"
select SELECT_OS in ${OSLIST[@]}
do
if [ -z "${SELECT_OS}" ]; then
    continue
else
    break
fi
done

echo You selected ${REPLY}\) ${SELECT_OS}

#テンプレートの一覧からバージョンリストを作成
##VARLIST=(`veewee vbox templates | grep ${SELECT_OS}| cut -d ' ' -f 5|sed -e s/\'//g|sed -e s/${SELECT_OS}-//g`)
VARLIST=(`echo ${TEMPLATES} | perl -pe 's/ /\n/g'| grep ${SELECT_OS}|sed -e s/${SELECT_OS}-//g`)

echo "What version do you install?"
select SELECT_VER in ${VARLIST[@]}
do
if [ -z "${SELECT_VER}" ]; then
    continue
else
    break
fi
done

echo You selected ${REPLY}\) ${SELECT_VER}

echo Install image is ${SELECT_OS}-${SELECT_VER}

#イメージ名の指定
echo 'Please input VM image name : '
read VMNAME

#選択イメージのインストール
veewee vbox define ${VMNAME} ${SELECT_OS}-${SELECT_VER}

#イメージの初期設定
## 一般ユーザ パスワード
## 

#イメージのビルド
veewee vbox build ${VMNAME}


#Opscode Public Cookbooksからcehfのcookbookの一覧取得
