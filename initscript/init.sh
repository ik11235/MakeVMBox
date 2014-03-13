#!/bin/sh

VAGRANT=`which vagrant`
VIRTUALBOX=`which virtualbox`
VEEWEE=`which veewee`
RUBY=`which ruby`

if [ -z "${VIRTUALBOX}" ];then
    echo 'VirtualBox not found'
    exit 1;
fi
if  [ -z "${VAGRANT}" ]; then
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

#Opscode Public Cookbooksからcehfのcookbookの一覧取得
##一覧作成->(1)->インストールアプリ選択->exitまで1へループ?

###cookbook一覧を作成
####https://github.com/opscode-cookbooksを解析
####https://api.github.com/users/opscode-cookbooks/repos
COOKBOOKS=(`${RUBY} ./cheflist.rb`)
#COOKBOOKS+=("exit")


##インストールアプリ選択画面
echo "select install COOKBOOKS"
echo "quit to typing \"^D\""

SELECTBOOKS=()
select BOOKS in ${COOKBOOKS[@]}
do
if [ -z "${BOOKS}" ]; then
    continue;
#elif [ "${BOOKS}" = "exit" ]; then
#    echo "input exit"
#    break;
else
    SELECTBOOKS+=(${BOOKS});
fi

echo "select install COOKBOOKS"
echo "quit to typing \"^D\""
echo "Now select package : ${SELECTBOOKS[@]}"

done


#イメージ名の指定
echo 'Please input VM image name : '
read VMNAME

#選択イメージのインストール
${VEEWEE} vbox define ${VMNAME} ${SELECT_OS}-${SELECT_VER}

#イメージの初期設定
## 一般ユーザ パスワード
## 


#Chef設定

cp ./config/Berksfile ./definitions/${VMNAME}/
for Recipe in "${SELECTBOOKS[@]}";
do
    echo "cookbook \"${Recipe}\" , git: \"https://github.com/opscode-cookbooks/${Recipe}.git\"" >> ./definitions/${VMNAME}/Berksfile
done
##cp ./config/Vagrantfile ./definitions/${VMNAME}/
echo '$GEM install berkshelf' >> ./definitions/${VMNAME}/Chef.sh #install OK
echo "berks install" >> ./definitions/${VMNAME}/Chef.sh # not found and not Berksfile
  :postinstall_files => [

#cat ./definitions/${VMNAME}/Berksfile
#cat ./definitions/${VMNAME}/Chef.sh
#exit 1;

##echo "config.berkshelf.enabled = true">Vagrantfile
##echo "config.vm.provision :chef_solo do |chef|">>Vagrantfile
##echo "chef.run_list = [">>Vagrantfile
##for Recipe in "${SELECTBOOKS[@]}";
##do
##    echo "\"recipe[${Recipe}]\"" >>Vagrantfile
##done
##echo "] end" >>Vagrantfile




#イメージのビルド
${VEEWEE} vbox build ${VMNAME}

#chef設定を行う?
##もしくはdefine直後に.shに追記する?


#boxのシャットダウン
${VEEWEE} vbox halt ${VMNAME}

#boxのイメージ化
${VAGRANT} package --base ${VMNAME} --output ${VMNAME}.vbox