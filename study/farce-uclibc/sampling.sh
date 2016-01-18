#!/bin/bash
# Brute argument parsing
# The right thing to do would be to be a gcc replacement, parse its flags and
# select the ones we care about.
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


outBase="$(dirname $inp)/$(basename $inp .c)"
copyBase=$(echo $outBase | sed s/local/scratch/g)



# variability-aware analysis
#    export partialPreprocFlags="$partialPreprocFlagsBase --reuseAST --family"
#    ./jcpp.sh "$@" $extraFlags
#    mv ${srcPath}/${i}.err ${srcPath}/${i}_family.err
#    mv ${srcPath}/${i}.dbg ${srcPath}/${i}_family.dbg


# single conf
    extraFlagsSC="--singleconf --rootfolder /local/janker/openssl"
    ./jcpp_sampling.sh $inp "$@" $extraFlagsSC
    gzip -c ${outBase}.err > ${copyBase}_singleconf.err.gz
    gzip -c ${outBase}.dbg > ${copyBase}_singleconf.dbg.gz
    mv ${outBase}.time ${copyBase}_singleconf.time
    mv ${outBase}.astimes ${copyBase}_singleconf.astimes
    mv ${outBase}.errreport ${outBase}_singleconf.errreport	

 # pairwise
    extraFlagsPW="--pairwise --rootfolder /local/janker/openssl"
    ./jcpp_sampling.sh $inp "$@" $extraFlagsPW
    gzip -c ${outBase}.err > ${copyBase}_pairwise.err.gz
    gzip -c ${outBase}.dbg > ${copyBase}_pairwise.dbg.gz
    mv ${outBase}.time ${copyBase}_pairwise.time
    mv ${outBase}.astimes ${copyBase}_pairwise.astimes
    mv ${outBase}.errreport ${outBase}_pairwise.errreport 

 # code coverage nh
    extraFlagsCC="--rootfolder /local/janker/openssl --codecoveragenh"
    ./jcpp_sampling.sh $inp "$@" $extraFlagsCC
    gzip -c ${outBase}.err > ${copyBase}_codecoveragenh.err.gz
    gzip -c ${outBase}.dbg > ${copyBase}_codecoveragenh.dbg.gz
    mv ${outBase}.time ${copyBase}_codecoveragenh.time
    mv ${outBase}.astimes ${copyBase}_codecoveragenh.astimes
    mv ${outBase}.errreport ${outBase}_codecoveragenh.errreport 	

# create condensed report
    
    touch ${outBase}.errreportall
 
    cat ${outBase}_singleconf.errreport >> ${outBase}.errreportall
    cat ${outBase}_pairwise.errreport >> ${outBase}.errreportall	 
    cat ${outBase}_codecoveragenh.errreport >> ${outBase}.errreportall

    gzip -c ${outBase}.errreportall > ${copyBase}.errreportall.gz    	
    gzip -c ${outBase}_codecoveragenh.errreport > ${copyBase}_codecoveragenh.errreport.gz
    gzip -c ${outBase}_pairwise.errreport > ${copyBase}_pairwise.errreport.gz
    gzip -c ${outBase}_singleconf.errreport > ${copyBase}_singleconf.errreport.gz
#cleanup 

   rm ${outBase}.err
   rm ${outBase}.dbg
   rm ${outBase}_codecoveragenh.errreport
   rm ${outBase}_pairwise.errreport
   rm ${outBase}_singleconf.errreport
   rm ${outBase}.errreportall


#mv to scratch
