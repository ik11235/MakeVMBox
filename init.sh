#!/bin/sh

VEGRANT=`which vagrant`
VIRTUALBOX=`which virtualbox`
VEEWEE=`which veewee`
RUBY=`which ruby`

if [ -z "${VIRTUALBOX}" ];then
    echo 'VirtualBox not found'
    exit 1;
fi
if  [ -z "${VEGRANT}" ]; then
    echo 'Vegrant not found'
    exit 1;
fi
if [ -z "${VEEWEE}" ]; then
    echo 'veewee not found'
    exit 1;
fi
if [ -z "${RUBY}" ]; then
    echo 'ruby not found'
    exit 1;
fi

#veeweeからOSイメージの一覧を確認、選択したOSのイメージ一覧を表示
##OSLIST=(`veewee vbox templates | cut -d ' ' -f 5 |cut -d '-' -f 1 |grep -v "available" |  sort |uniq |sed -e s/\'//g`)

TEMPLATES=`${VEEWEE} vbox templates |cut -d ' ' -f 5|sed -e s/\'//g |grep -v "available"`
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
${VEEWEE} vbox define ${VMNAME} ${SELECT_OS}-${SELECT_VER}

#イメージの初期設定
## 一般ユーザ パスワード
## 

#イメージのビルド
echo ${VEEWEE} vbox build ${VMNAME}

#boxのシャットダウン
echo ${VEEWEE} vbox halt ${VMNAME}

#boxのイメージ化
echo ${VAGRANT} package --base ${VMNAME} --output veewee.vbox


#Opscode Public Cookbooksからcehfのcookbookの一覧取得
##一覧作成->(1)->インストールアプリ選択->exitまで1へループ?

###cookbook一覧を作成
####https://github.com/opscode-cookbooksを解析
####https://api.github.com/users/opscode-cookbooks/repos
COOKBOOKS=(`${RUBY} ./cheflist.rb`)
COOKBOOKS+=("exit")


##インストールアプリ選択画面
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
