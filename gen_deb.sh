#!/bin/bash

if [ $EUID -ne 0 ]
then
    echo "Please run this script as root"
    exit
fi

mkdir -p debs
mkdir -p pkgs

dew_it()
{
    for var in "$@"
    do
        dpkg-deb --build packages/$var
    done
}

echo "Warning: this resets permissions in the packages folder to the current user."

if [ -z $1 ]
    then
        choice="all"
elif [ -n $1 ]
    then
        choice=$1
fi

chown -R root:root ./packages

case $choice in
   "all") dew_it spicy makemask iquesdk n64sdk u64assets root-compatibility-environment rsp-tools vadpcm-tools n64-conv-tools n64graphics libhvq libhvqm libnusys libnustd libnaudio libmus n64manual n64-demos nusys-demos kantan-demos mus-demos tutorial-demos n64sdk-common;;
   "spicy") dew_it spicy;;
   "makemask") dew_it makemask;;
   "ique") dew_it iquesdk;;
   "n64") dew_it n64sdk;;
   "assets") dew_it u64assets;;
   "demos") dew_it n64-demos;;
   "root") dew_it root-compatibility-environment;;
   "rsp") dew_it rsp-tools;;
   "pcm") dew_it vadpcm-tools;;
   "conv") dew_it n64-conv-tools;;
   "n64gfx") dew_it n64graphics;;
   "hvq") dew_it libhvq;;
   "hvqm") dew_it libhvqm;;
   "naudio") dew_it libnaudio;;
   "mus") dew_it libmus;;
   "nusys") dew_it libnusys;;
   "nustd") dew_it libnustd;;
   "man") dew_it n64manual;;
   "demos") dew_it n64-demos;;
   "kantan") dew_it kantan-demos;;
   "musdem") dew_it mus-demos;;
   "tutorial") dew_it tutorial-demos;;
   "nudemos") dew_it nusys-demos;;
   "common") dew_it n64sdk-common;;
   *) echo "Sorry nothing";;
esac

cp loose-debs/*.deb debs
mv packages/*.deb debs

for file in debs/*.deb
do
    debtap -Q $file
done

mv debs/*.pkg.tar.zst pkgs

if [[ $choice == "all" ]]
    then
        echo "Creating Packages.gz for APT archive"

        cd debs
        dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
        cd ..
fi

