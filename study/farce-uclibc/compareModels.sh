farceCommand=../../farce/run.sh

################################ Feature Model vs Code ############################################
#model vs code comparison: hierarchy edges and cross tree edges

#combined now does both single and combined, must give output directory to use
$farceCommand gsd.farce.comparisons.FeatureModelComparer uclibc output/FeatureModel/hierarchy.constraints output/Comparison/FeatureModelVsCode combined

$farceCommand gsd.farce.comparisons.FeatureModelComparer uclibc output/FeatureModel/crosstree.constraints output/Comparison/FeatureModelVsCode combined
############################# Code vs Feature Model ###################################################

#one command will do all comparisons now

$farceCommand gsd.farce.comparisons.CodeToVMComparer uclibc output/Comparison/CodeVsFeatureModel/

