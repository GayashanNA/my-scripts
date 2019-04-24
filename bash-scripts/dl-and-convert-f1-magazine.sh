key=$1
pages=$2
gp=$3

mkdir /tmp/f1/
cd /tmp/f1/
i=1
while [ "$i" -le "$pages" ];do 
    wget https://secure.viewer.zmags.com/services/resource/pub/$key/pg1697x2400/58/$i -O $i.jpg; 
    i=$(($i + 1))
done
FILES=$(ls -v | xargs echo)
mkdir temp && cd temp 
for file in $FILES; do 
    convert ../$file $file.pdf; 
done && 
FILES=$(ls -v | xargs echo)
pdftk $FILES cat output ../f1-$gp.pdf && 
cd ..
rm -rf temp
