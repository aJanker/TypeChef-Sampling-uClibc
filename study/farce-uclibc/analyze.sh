#!/bin/bash -e
#!/bin/bash -vxe

#SBATCH -D /scratch/janker/uclibc/study/farce-uclibc
#SBATCH --job-name=uclibc-typechef-vaa
#SBATCH -p chimaira
#SBATCH -A spl
#SBATCH --qos=lopri
#SBATCH --get-user-env
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=janker@fim.uni-passau.de
#SBATCH --mem_bind=local
#SBATCH --output=/dev/null 
#SBATCH --error=/dev/null
#SBATCH --time=10:00:00
#SBATCH --array=0-1623
#SBATCH --exclude=chimaira17

filesToProcess() {
  local listFile=filelist
  cat $listFile
  #awk -F: '$1 ~ /.c$/ {print gensub(/\.c$/, "", "", $1)}' < linux_2.6.33.3_pcs.txt
}

configId=${SLURM_ARRAY_TASK_ID}
i=`cat filelist | head -n $((configId + 1)) | tail -n1`

flags=""
srcPath=$PWD/uClibc
target=x86_64

#--openFeat $srcPath/openFeaturesList.txt
export partialPreprocFlags="--bdd --openFeat $srcPath/../openFeaturesList.txt --featureModelDimacs $srcPath/../uclibc.dimacs  --include header.h --include builtin.h --include $srcPath/include/libc-symbols.h  -I $srcPath -I $srcPath/include -I $srcPath/include/sys -I /usr/include/ -I /usr/lib/gcc/x86_64-linux-gnu/4.8.4/include-fixed -I /usr/lib/gcc/x86_64-linux-gnu/4.8.4/include  -A cfginnonvoidfunction -A doublefree -A xfree -A uninitializedmemory -A casetermination -A danglingswitchcode -A checkstdlibfuncreturn -A deadstore -A interactiondegree --serializeAST  --recordTiming --parserstatistics  --openFeat=openFeaturesList.txt --adjustLines"

flags() {
  	name="$1"
  	base="$(basename "$1")"


	extraFlag="-I $srcPath/libc/sysdeps/linux -I $srcPath/libc/sysdeps/linux/common -I $srcPath/libc/sysdeps/linux/common/bits"	
	#define __SSP__ in general then undefine it for specific files
	extraFlag="$extraFlag -I $srcPath/libc/sysdeps/linux/$target -I $srcPath/libc/sysdeps/linux/$target/bits -D__SSP__"
	
	if grep -q "extra/locale/" <<< "$name"; then
		extraFlag="$extraFlag -D__UCLIBC_GEN_LOCALE"
	elif grep -q "libc/" <<< "$name"; then		
		extraFlag="$extraFlag -I $srcPath/libpthread -I $srcPath/ldso/include -I $srcPath/ldso/ldso/$target" 		
		
		if grep -q "libc/inet/" <<< "$name"; then		
			extraFlag="$extraFlag -DRESOLVER=\"resolv.c\""
		fi

		if grep -q "libc/misc/internals/__uClibc_main" <<< "$name"; then		
			extraFlag="$extraFlag -U__SSP__"
		fi	


	elif grep -q "librt/" <<< "$name"; then	
		extraFlag="$extraFlag  -DNOT_IN_libc -DIS_IN_librt -I $srcPath/ldso/include -I $srcPath/libpthread"	
		#extraFlag="$extraFlag  -I $srcPath/ldso/ldso/$target -I $srcPath/ldso/include -I $srcPath/libpthread/nptl/sysdeps/$target -I $srcPath/libpthread/nptl -I $srcPath/libpthread/nptl/sysdeps/pthread -I $srcPath/libpthread/nptl/sysdeps/unix/sysv/linux/$target -I $srcPath/libpthread/nptl/sysdeps/unix/sysv/linux -DNOT_IN_libc -DIS_IN_librt"
	elif grep -q "libintl/" <<< "$name"; then
		extraFlag="$extraFlag  -DNOT_IN_libc -DIS_IN_libintl"
	elif grep -q "libm/" <<< "$name"; then
		extraFlag="$extraFlag -DNOT_IN_libc -DIS_IN_libm -D_IEEE_LIBM"
	elif grep -q "libcrypt/" <<< "$name"; then
		extraFlag="$extraFlag -DNOT_IN_libc -DIS_IN_libcrypt"
	elif grep -q "libresolv/" <<< "$name"; then
		extraFlag="$extraFlag -DNOT_IN_libc -DIS_IN_libresolv"
	elif grep -q "libutil/" <<< "$name"; then
		extraFlag="$extraFlag -DNOT_IN_libc -DIS_IN_libutil"
	elif grep -q "ldso/ldso/" <<< "$name"; then
		extraFlag="$extraFlag -DNOT_IN_libc -DIS_IN_rtld -I $srcPath/ldso/include -I $srcPath/ldso/ldso/$target"
	elif grep -q "ldso/libdl/" <<< "$name"; then
		 extraFlag="$extraFlag -DNOT_IN_libc -DIS_IN_libdl"
	elif grep -q "libnsl/" <<< "$name"; then
		extraFlag="$extraFlag -DNOT_IN_libc -DIS_IN_libnsl"
	elif grep -q "libubacktrace/" <<< "$name"; then		
		extraFlag="$extraFlag -I $srcPath/libpthread -I $srcPath/ldso/include -I $srcPath/librt -DNOT_IN_libc -DIS_IN_libubacktrace"
	elif grep -q "utils/" <<< "$name"; then
		extraFlag="$extraFlag -I $srcPath/ldso/include -I $srcPath/libc/misc/wchar --include $srcPath/include/elf.h -DL_iconv_main"
	elif grep -q "libpthread/" <<< "$name"; then
		extraFlag="$extraFlag -I $srcPath/libpthread -DIS_IN_libpthread -DNOT_IN_libc "

		if grep -q "libpthread/nptl" <<< "$name"; then
			
			extraFlag="$extraFlag -I $srcPath/ldso/include -I $srcPath/ldso/ldso/$target -I $srcPath/libc/stdlib -I $srcPath/libpthread/nptl -I $srcPath/libpthread/nptl/sysdeps/pthread -I $srcPath/libpthread/nptl/sysdeps/$target -I $srcPath/libpthread/nptl/sysdeps/unix/sysv/linux -I $srcPath/libpthread/nptl/sysdeps/unix/sysv/linux/$target -D_GNU_SOURCE" 

			if grep -q "libpthread/nptl/sysdeps/unix/sysv/linux/" <<< "$name"; then
				extraFlag="$extraFlag -I $srcPath/librt"
	
				if grep -q "pt-pread_pwrite.c" <<< "$name"; then
					extraFlag="$extraFlag -I $srcPath/libc/sysdeps/linux/$target -I $srcPath/libc/sysdeps/linux/common"
				elif grep -q "mq_notify.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				elif grep -q "timer_create.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				elif grep -q "timer_delete.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				elif grep -q "timer_getoverr.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				elif grep -q "timer_gettime.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				elif grep -q "timer_routines.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				elif grep -q "timer_settime.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"			
				elif grep -q "librt-cancellation.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				elif grep -q "rt-unwind-resume.c" <<< "$name"; then
					extraFlag="$extraFlag -DIS_IN_librt"
				fi
		
			fi
			if grep -q "libpthread/nptl_db" <<< "$name"; then								
				extraFlag="$extraFlag -DIS_IN_libthread_db=1 "
			fi
		elif grep -q "libpthread/linuxthreads.old" <<< "$name"; then
			dummy="dummy"
			#extraFlag="$extraFlag -I $srcPath/libpthread/linuxthreads.old -I $srcPath/libpthread/linuxthreads.old/sysdeps/pthread -I $srcPath/libpthread/linuxthreads.old/sysdeps/$target -I $srcPath/libpthread/nptl/sysdeps/unix/sysv/linux/$target -I $srcPath/libpthread/linuxthreads.old/sysdeps/sparc -I $srcPath/libc/sysdeps/linux/$target -I $srcPath/librt"
					

		elif grep -q "libpthread/linuxthreads" <<< "$name"; then
				
			extraFlag="$extraFlag -I $srcPath/libpthread/linuxthreads -I $srcPath/libpthread/linuxthreads/sysdeps/pthread -I $srcPath/libpthread/linuxthreads/sysdeps/$target -I $srcPath/libc/sysdeps/linux/$target -I $srcPath/libpthread/linuxthreads/sysdeps/unix/sysv/linux -I $srcPath/libpthread/linuxthreads/sysdeps/unix/sysv/linux/$target -I $srcPath/librt"

		fi
		

	fi

	
		
	echo "$extraFlag"	 
}

#cat filelist | parallel -j 30 ./jcpp.sh $srcPath/{}.c $extraFlags

## Reset output
outDbg="$srcPath/$i.dbg"
outErr="$srcPath/$i.err"
extraFlags="$(flags "$i")"
echo " $srcPath/$i.c $partialPreprocFlags $extraFlags"
/scratch/janker/TypeChef/typechef.sh $srcPath/$i.c $partialPreprocFlags $extraFlags 2> $outErr |tee $outDbg

cat $outErr 1>&2

 gzip -c ${outErr} > ${outErr}.gz
 gzip -c ${outDbg} > ${outDbg}.gz

 rm ${outErr}
 rm ${outDbg}
