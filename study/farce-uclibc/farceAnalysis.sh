farceCommand=../../farce/run.sh

#linker checks and def/use formula
$farceCommand gsd.farce.linker.GlobalLinker uclibc 2> output/Linker/linkerErrors.txt

#create type formula
$farceCommand gsd.farce.typesystem.TypeConstrExtractor uclibc > output/TypeErrors/typeSources 2> output/TypeErrors/errorGeneratorFailures.txt

#parser errors
$farceCommand gsd.farce.parser.ParserConstrExtractor uclibc > output/ParserErrors/parserSources 2> output/ParserErrors/parserErrors.dbg

#create preprocessor error formula
$farceCommand gsd.farce.preprocessor.PreprocessorConstrExtractor uclibc 2> output/PreprocessorErrors/DebugInfo.txt

#create nestedifdef formula
$farceCommand gsd.farce.featureeffect.FeatureEffectConstrExtractor uclibc openFeaturesList.txt 2> output/FeatureEffect/nestedIfDefFailures.dbg

#file pcs
$farceCommand gsd.farce.featureeffect.FilePcConstraintExtractor uclibc openFeaturesList.txt

#extract hierarchy and cross tree edges, and feature groups from feature model
$farceCommand gsd.farce.features.model.FeatureRelationshipsMain uclibc output/FeatureModel/uclibc.exconfig __ __ 2> output/FeatureModel/strangeHierCrossEdges 

$farceCommand gsd.farce.features.model.FeatureGroupsMain uclibc output/FeatureModel/uclibc.exconfig __ __

#Comparisons

./compareModels.sh
