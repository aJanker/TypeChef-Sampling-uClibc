srcPath="uClibc"
farceCommand=../../farce/run.sh

#../../run.sh gsd.farce.features.KConfigReader $srcPath/extra/Configs/ featureModel header.h openTest.txt

#cd $srcPath
#../../variability-analysis/exconf-i386 config/Config.in > config.exconfig

#java -cp ../../variability-analysis/fm-translation-0.5-SNAPSHOT-jar-with-dependencies.jar gsd.linux.tools.BooleanTranslationMain config.exconfig config.bool

#java -cp ../../variability-analysis/fm-translation-0.5-SNAPSHOT-jar-with-dependencies.jar gsd.linux.tools.CNFMain config.bool config.dimacs

#find -type f -name '*Config.in*' -exec egrep '^\s*(menu)?config\s+' {} \; | sed 's/^.*config\s*//;' > $srcPath/openFeaturesList.txt

#cd ..



$farceCommand gsd.farce.filepcs.ProcessFileListUclibc filepcMan.txt $srcPath/

#patchesPath=uClibc_0.9.33.2_patches
#while read i; do
 # patch -p0 -i $patchesPath/$i
#done < $patchesPath/series


