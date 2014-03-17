#!/bin/sh

VAGRANT=`which vagrant`
VIRTUALBOX=`which virtualbox`
VEEWEE=`which veewee`
RUBY=`which ruby`

DEBUG=$1
DEBUG=${DEBUG:0}

if [ "${DEBUG}" == 1 ];then
    #echo "This is Debug mode."
    VAGRANT="echo ${VAGRANT}"
    VIRTUALBOX="echo ${VIRTUALBOX}"
    VEEWEE="echo ${VEEWEE}"
    #RUBY="echo ${RUBY}"
fi

WEBROOT="http://localhost:3000/"

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

#TEMPLATES=`${VEEWEE} vbox templates |cut -d ' ' -f 5|sed -e s/\'//g |grep -v "available"`
TEMPLATES=`VEEWEE vbox templates |cut -d ' ' -f 5|sed -e s/\'//g |grep -v "available"`
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


TMPDIR="./TMP"
mkdir -p ${TMPDIR}
touch ${TMPDIR}/tmpfile
DATE=`date +"%Y%m%d"`
CHEFFILE="${TMPDIR}/CHEFLIST-${DATE}.txt"
if [ ! -e ${CHEFFILE} ];then
    rm ${TMPDIR}/*
    ${RUBY} -W0 ./cheflist.rb >${CHEFFILE}    
fi
COOKBOOKS=(`cat ${CHEFFILE}`)

##インストールアプリ選択画面
echo "select install COOKBOOKS"
echo "quit to typing \"^D\""

SELECTBOOKS=()
select BOOKS in ${COOKBOOKS[@]}
do
if [ -z "${BOOKS}" ]; then
    continue;
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
VMFILEPATH=${VMNAME}.box

#既存イメージの検索 
##http://localhost:3000/vmimages.json?&q%5Bosname_eq%5D=ubuntu&q%5Bosversion_eq%5D=8.04.4-server-i386
IDLIST=(`${RUBY} -W0 search.rb ${SELECT_OS} ${SELECT_VER} ${SELECTBOOKS[@]}`)

if [ -n "${IDLIST[0]}" ]; then
    echo "This OSimage is already exists."
    echo "Download image?[Y/n]"
    read ANSWER
    case $ANSWER in
	"" | "Y" | "y" | "yes" | "Yes" | "YES" )
	    curl -o ${VMFILEPATH} ${WEBROOT}/vmimage/${IDLIST[0]}/download
	    echo "finish Download VMimage. FILENAME is ${VMFILEPATH}"
	    echo "Box add command: \"${VAGRANT} box add ${VMNAME} ${VMFILEPATH}\""
	    exit 0;;
    esac
fi


SELECT_TAG=`echo ${SELECTBOOKS[@]}|sed -e s/\ /\,/g`
if [  "${DEBUG}" == 1 ];then
    ##test mode
    echo "${VMNAME}  ${SELECT_OS}-${SELECT_VER}"> ${VMFILEPATH}
else
    #main mode
    #選択イメージのインストール
    ${VEEWEE} vbox define ${VMNAME} ${SELECT_OS}-${SELECT_VER}
    
    #イメージの初期設定
    ## 一般ユーザ パスワード
    ## 
    
    #Chef設定
    
    #cp ./config/Berksfile ./definitions/${VMNAME}/
    #for Recipe in "${SELECTBOOKS[@]}";
    #do
    #    echo "cookbook \"${Recipe}\" , git: \"https://github.com/opscode-cookbooks/${Recipe}.git\"" >> ./definitions/${VMNAME}/Berksfile
    #done
    #cp ./config/Vagrantfile ./definitions/${VMNAME}/
    #echo '$GEM install berkshelf' >> ./definitions/${VMNAME}/Chef.sh #install OK
    #echo "berks install" >> ./definitions/${VMNAME}/Chef.sh # not found and not Berksfile
    #  :postinstall_files => [
    
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
    VMFILEPATH=${VMNAME}.box
    ${VAGRANT} package --base ${VMNAME} --output ${VMFILEPATH}
    
fi

echo "Finish make VMimage."
echo "Upload This image?[Y/n]"
read ANSWER
case $ANSWER in
    "" | "Y" | "y" | "yes" | "Yes" | "YES" )
	#作成したイメージの情報をwebに転送
	SUBMIT=`curl -F vmimage\[osname\]=${SELECT_OS} -F vmimage\[osversion\]=${SELECT_VER} -F vmimage\[tag_list\]=${SELECT_TAG} -F vmimage\[file\]=\@${VMFILEPATH} "${WEBROOT}/vmimages"`
	if [ $? -ne 0 ]; then
	    echo "File Upload Error! Please Manual upload to ${WEBROOT}";
	    echo "osname:${SELECT_OS}"
	    echo "osversion:${SELECT_VER}"
	    echo "tag:${SELECT_TAG}"
	    echo "vmfile:${VMFILEPATH}"
	    exit 1;
	else	    
	    SUBMIT=`echo ${SUBMIT}| sed -e 's/<html><body>You are being <a href=\"//'`
	    SUBMIT=`echo ${SUBMIT}| sed -e 's/\">redirected<\/a>\.<\/body><\/html>//'`
	    SUBMIT=`echo ${SUBMIT}/download| sed -e 's/vmimages/vmimage/'`
	    echo "Success File Upload! Image File URL: ${SUBMIT}";
	    exit 0;
	fi
esac
