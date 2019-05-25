#!/bin/bash
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
script_dir=$(dirname $0)
cur=$(pwd)

cd "$script_dir"


rm Packages.bz2

i=0
for deb in *.deb
do
  i=`expr $i + 1`
	echo "$deb を処理中！";
  dpkg-deb -f "$deb" >> Packages
  md5sum "$deb" | echo "MD5sum: $(awk '{ print $1 }')" >> Packages
  sha1sum "$deb" | echo "SHA1: $(awk '{ print $1 }')" >> Packages
  sha256sum  "$deb" | echo "SHA256: $(awk '{ print $1 }')" >> Packages
  wc -c "$deb" | echo "Size: $(awk '{ print $1 }')" >> Packages
  echo "Filename: $deb" >> Packages
  dpkg-deb -f "$deb" Package | echo "Depiction: https://chikuwajb.github.io/repository_description/#$(xargs -0)" >> Packages
  echo "" >> Packages
done

echo "" >> Packages; ## Add extra new line
echo "圧縮中。。。"
cp Packages Packages.txt
bzip2 Packages
echo "完了！"

if [ $MODE == "auto" ]; then
git config user.email "chikuwajb@gmail.com"
git config user.name "Auto"

git init
git add .
git commit -m "Auto generated Packages.bz2"
git push "https://${Github_TOKEN}@github.com/ChikuwaJB/repo.git"
fi
