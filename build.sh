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
    ls
    make build
    mv glide glide-$github_version
   
    if [[ $github_version > $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/glide/latest glide-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/glide/latest/glide-$ftp_version" 
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/glide/ glide-$github_version"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/glide/glide-$del_version" 
fi
