FTP_HOST='oplab9.parqtec.unicamp.br'
LOCALPATH=$GOPATH/src/github.com/Masterminds/glide
REMOTEPATH='/ppc64el/glide'
ROOTPATH="~/rpmbuild/RPMS/ppc64le"
REPO1="/repository/debian/ppc64el/glide"
REPO2="/repository/rpm/ppc64le/glide"
github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    cd $GOPATH/src/github.com
    mkdir Masterminds
    cd Masterminds
    wget https://github.com/Masterminds/glide/archive/v$github_version.zip
    unzip v$github_version.zip
    mv glide-$github_version glide
    cd glide
    make build
    mv glide glide-$github_version
    ./glide-$github_version --version
    git clone https://$USERNAME:$TOKEN@github.com/Unicamp-OpenPower/repository-scrips.git
    cd repository-scrips/
    chmod +x empacotar-deb.sh
    chmod +x empacotar-rpm.sh
    sudo mv empacotar-deb.sh $LOCALPATH
    sudo mv empacotar-rpm.sh $LOCALPATH
    cd $LOCALPATH
    sudo ./empacotar-deb.sh glide glide-$github_version $github_version " "
    sudo ./empacotar-rpm.sh glide glide-$github_version $github_version " " "Package Management for Go"
    if [[ $github_version > $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/glide/latest glide-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/glide/latest/glide-$ftp_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O $REPO1 $LOCALPATH/glide-$github_version-ppc64le.deb"
        sudo lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O $REPO2 $ROOTPATH/glide-$github_version-1.ppc64le.rpm"
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/glide/ glide-$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/glide/glide-$del_version" 
fi
