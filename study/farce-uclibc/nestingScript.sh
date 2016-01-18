cat filelist|while read i; do
if [ -f "uClibc/$i.nested" ]
then
cat uClibc/$i.nested
fi
done

