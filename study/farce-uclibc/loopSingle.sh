cat rerun|while read i; do
./analyzeSingle.sh $i x86_64
done
