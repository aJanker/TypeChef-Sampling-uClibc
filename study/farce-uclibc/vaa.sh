#!/bin/bash

ABSPATH=$(cd "$(dirname "$0")"; pwd)

if [ $# -lt 1 ]; then
  echo "Not enough arguments!" >&2
  exit 1
fi
inp=$1
shift

if [ -z "$inp" ]; then
  echo "inp not defined!" >&2
  exit 1
fi

cd $(dirname $inp)

outBase="$(dirname $inp)/$(basename $inp .c)"
copyBase=$(echo $outBase | sed s/local/scratch/g)


outBase="$(dirname $inp)/$(basename $inp .c)"
outDbg="$outBase.dbg"
outErr="$outBase.err"
outTime="$outBase.time"
outStmtDegree="$outBase.stmt.degree"
outErrorStmtDegree="$outBase.stmt.error.degree"

copyStmtDegree="$copyBase.stmt.degree.gz"
copyErrorStmtDegree="$copyBase.stmt.error.degree.gz"

# Beware: the embedded for loop requotes the passed argument. That's dark magic,
# don't ever try to touch it. It simplifies your life as a user of this program
# though!
echo "==Partially preprocessing $inp"
echo $partialPreprocFlags

bash -c "time $ABSPATH/../../TypeChef/typechef.sh \
  $(for arg in "$@"; do echo -n "\"$arg\" "; done) \
  '$inp' 2> '$outErr' |tee '$outDbg'" \
  2> "$outTime" || true

cat "$outErr" 1>&2

gzip -c ${outBase}.err > ${copyBase}_vaa.err.gz
gzip -c ${outBase}.dbg > ${copyBase}_vaa.dbg.gz

gzip -c $outStmtDegree > $copyStmtDegree
gzip -c $outErrorStmtDegree > $copyErrorStmtDegree


mv ${outBase}.time ${copyBase}_vaa.time
mv ${outBase}.astimes ${copyBase}_vaa.astimes
mv ${outBase}.tunit ${copyBase}.tunit

rm ${outBase}.err
rm ${outBase}.dbg
rm $outStmtDegree
rm $outErrorStmtDegree


