Files:
b4.r1399.jar            The jar file of Beagle
scripts:
	filter_hmp.sh   A script to filter the hmp file based on MAF and proportion of missing
	filter_vcf.sh   A script to filter the output of Beagle (VCF), based on the Genotype Probability (GP), MAF and proportion of missing
	hmp_to_vcf.pl   Transform hmp to vcf
	vcf_to_hmp.pl   Transfrom vcf to hmp
	run_example.sh  A script that conbines the imputation step, beagle output vcf filtering and conversion of filtered vcf to hmp

Example_data:
Reference_panel.vcf	Sample data for chromosome 1D, used as the reference in Beagle
chr1D.vcf		Sample data for target population chr1D SNP to be imputed, it should be sorted using congorm-gt


readme.txt              This file itself

Running the scripts:
1. Download all the files to a directory of your choice.
2. Edit the run_example.sh file to specify the directory path to your files.
3. Run the script on your terminal or modify it for batch submission depending on your platform that is, [user@server]$ sh run_example.sh or [user@server]$ sbatch run_example.sh
4. Each script can be run independently by supplying the appropriate file at the command line such as [user@server]$ sh filter_vcf.sh filename.vcf
5. The perl scripts can be also run on the terminal as [user@server]$ perl vcf_to_hmp.pl input_file.vcf > output_file.vcf.hmp.txt

Note:
1. The input file for filter_vcf.sh should be unzipped vcf. However, if you do not wish to unzip the vcf.gz file, then change the first part of filter_vcf.sh to zcat.
2. Scripts are generic and amenable with custom data provided the files are correctly formated.
3. SNP for the reference panel and the target population should be based on same reference genome coordinates.

