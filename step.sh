#!/bin/bash
set -ex

###
# Dev purpose only
#export BITRISE_DEPLOY_DIR="./build"
#export black_list="google.com;yolo.com;apple-mapkit.com"
#export ssl_labs_scan="yes"
#rm -rf $BITRISE_DEPLOY_DIR/urls-scanner
#rm -rf $BITRISE_DEPLOY_DIR/urls-scanner/urls-found
#rm -rf $BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans
###

mkdir $BITRISE_DEPLOY_DIR/urls-scanner
mkdir $BITRISE_DEPLOY_DIR/urls-scanner/urls-found
mkdir $BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans

#Find all domains used in the code
#Rules for iOS/Android/React native application
grep -RHIEo --exclude=.gitignore --exclude=\*.sh --exclude=\*.yml --exclude=\*-lock.json --exclude=\*.lock --exclude=\*.md --exclude=\*.gradle --exclude-dir=git --exclude-dir=build --exclude-dir=buildscripts --exclude-dir=mocks --exclude-dir=node_modules --exclude-dir=__mocks__ --exclude-dir=__tests__ --exclude-dir=__snapshots__ --exclude-dir=Carthage --exclude=cartfile --exclude-dir=Pods --exclude=Podfile --exclude-dir=\*.framework --exclude=gradlew --exclude=\*.resolved --exclude-dir=idea '(https)://[^/"]+.(com|net|org|uk|fr|nl|be|de|se|io)' . | sort -u | uniq > $BITRISE_DEPLOY_DIR/urls-scanner/urls-found/domains-https-with-filesname.txt
grep -RHIEo --exclude=.gitignore --exclude=\*.sh --exclude=\*.yml --exclude=\*-lock.json --exclude=\*.lock --exclude=\*.md --exclude=\*.gradle --exclude-dir=git --exclude-dir=build --exclude-dir=buildscripts --exclude-dir=mocks --exclude-dir=node_modules --exclude-dir=__mocks__ --exclude-dir=__tests__ --exclude-dir=__snapshots__ --exclude-dir=Carthage --exclude=cartfile --exclude-dir=Pods --exclude=Podfile --exclude-dir=\*.framework --exclude=gradlew --exclude=\*.resolved --exclude-dir=idea '(http)://[^/"]+.(com|net|org|uk|fr|nl|be|de|se|io)' . | sort -u | uniq > $BITRISE_DEPLOY_DIR/urls-scanner/urls-found/domains-http-with-filesname.txt

grep -RhIEo --exclude=.gitignore --exclude=\*.sh --exclude=\*.yml --exclude=\*-lock.json --exclude=\*.lock --exclude=\*.md --exclude=\*.gradle --exclude-dir=git --exclude-dir=build --exclude-dir=buildscripts --exclude-dir=mocks --exclude-dir=node_modules --exclude-dir=__mocks__ --exclude-dir=__tests__ --exclude-dir=__snapshots__ --exclude-dir=Carthage --exclude=cartfile --exclude-dir=Pods --exclude=Podfile --exclude-dir=\*.framework --exclude=gradlew --exclude=\*.resolved --exclude-dir=idea '(https)://[^/"]+.(com|net|org|uk|fr|nl|be|de|se|io)' . | sort -u | uniq > $BITRISE_DEPLOY_DIR/urls-scanner/urls-found/domains-https.txt
grep -RhIEo --exclude=.gitignore --exclude=\*.sh --exclude=\*.yml --exclude=\*-lock.json --exclude=\*.lock --exclude=\*.md --exclude=\*.gradle --exclude-dir=git --exclude-dir=build --exclude-dir=buildscripts --exclude-dir=mocks --exclude-dir=node_modules --exclude-dir=__mocks__ --exclude-dir=__tests__ --exclude-dir=__snapshots__ --exclude-dir=Carthage --exclude=cartfile --exclude-dir=Pods --exclude=Podfile --exclude-dir=\*.framework --exclude=gradlew --exclude=\*.resolved --exclude-dir=idea '(http)://[^/"]+.(com|net|org|uk|fr|nl|be|de|se|io)' . | sort -u | uniq > $BITRISE_DEPLOY_DIR/urls-scanner/urls-found/domains-http.txt

if [ "$ssl_labs_scan" = true ] ; then
    #Transform result to be compliant with ssllabs -hostfile command
    cp $BITRISE_DEPLOY_DIR/urls-scanner/urls-found/domains-https.txt $BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans/domains-https-ssllabs.txt
    sed -i '' 's#https://##g' $BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans/domains-https-ssllabs.txt

    while read -r website; do
        echo "$website" | cut -f1 -d"/"
        clean_url=$(echo "$website" | cut -f1 -d "/")
        clean_url="${clean_url#*.}"
        clean_url="${clean_url#www.}"

        echo "clean url is $clean_url"
        #https://github.com/ssllabs/ssllabs-scan/blob/a7f3d492cc1d025fcb268763ed8909cace1e7d14/ssllabs-api-docs-v3.md
        #https://formulae.brew.sh/formula/ssllabs-scan

        if echo "$black_list" | grep -q "$clean_url"
        then
            echo "$website is blacklisted and will be not analyzed by SSLLabs"
        else 
            #hostcheck to false for invalid urls
            RESULT=$(ssllabs-scan -usecache=true -quiet=true -hostcheck=false $clean_url)
            echo $RESULT > $BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans/$clean_url.json
        fi
        
    done < "$BITRISE_DEPLOY_DIR/urls-scanner/ssllabs-scans/domains-https-ssllabs.txt"
fi

zip -r $BITRISE_DEPLOY_DIR/urls-scanner.zip $BITRISE_DEPLOY_DIR/urls-scanner/*
