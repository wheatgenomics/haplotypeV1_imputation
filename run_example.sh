#!/bin/sh 
module load Java/1.8.0_131

## "/.../filename means that you have to provide a full directory path to the file 
beagle="/.../beagle.r1399.jar"
input="/.../chr1D.vcf"
ref="/.../Reference_panel.vcf"

## run imputation for chr1D SNP, the output will be imputed_chr1D.vcf.gz
date
output_prefix=imputed_chr1D
echo "Start running beagle v4.0" 
echo "imputation"

## Newer versions of beagle can be used but make sure you specify the parameter names correctly

## beagle v4.0
java -Xmx150g -jar $beagle ref=$ref gt=$input impute=true chrom=chr1D gprobs=true  out=$output_prefix nthreads=10 burnin-its=10 phase-its=10 window=5000  overlap=500 2>&1 >${output_prefix}.log

## filtering the VCF; the output would be imputed_chr1D.vcf_filtered.vcf
gunzip ${output_prefix}.vcf.gz

date
echo "Filtering imputed vcf"
sh /.../filter_vcf.sh ${output_prefix}.vcf

## covnert vcf to hmp
date
echo "Converting VCf to hmp"
perl /.../vcf_to_hmp.pl  ${output_prefix}.vcf_filtered.vcf  >${output_prefix}.vcf_filtered.hmp.txt

