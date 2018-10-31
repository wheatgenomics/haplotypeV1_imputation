##!/bin/bash -l
##SBATCH --time=01:00:00 # Use the form DD-HH:MM:SS
##SBATCH --mem-per-cpu=15G
##SBATCH --nodes=1
##SBATCH --ntasks-per-node=10
##SBATCH --partition=killable.q
##SBATCH --mail-type=ALL # same as =BEGIN,FAIL,END
##SBATCH --mail-user=nyine@ksu.edu
module load Java/1.8.0_131

#chr1D="/homes/nyine/New_Colby_data/TEST/Colby_GBS_chr1D_Imputed.vcf.gz"
cat $1 | perl -ne 'BEGIN{$gp_cutoff=0.7; $maf_cutoff=0.03; $miss_max = 0.7 }  chomp; @t=split /\s+/,$_; if (/\#/){print join("\t", @t[2, 9..$#t]), "\n" if /\#CHROM/; print STDERR $_, "\n" if /\#CHROM/; next};   @gns=(); $miss=0; $ref=0; $alt=0;  map{ @arr=split /:/, $t[$_]; @p=split /,/, $arr[-1]; $gn="N"; if($t[$_]=~/0\|0/){$gn= $p[0]>=$gp_cutoff?$t[3]:"N"; $t[$_] = ".|." unless $p[0]>=$gp_cutoff}elsif($t[$_]=~/1\|1/){$gn= $p[2] >= $gp_cutoff?$t[4]:"N"; $t[$_]=".|." unless $p[2]>=$gp_cutoff}else{$gn="N"};push @gns, $gn;  if($gn eq $t[3]){$ref++}elsif($gn eq $t[4]){$alt++}else{$miss++}  }9..$#t;  $miss_rate = $miss/($miss + $ref + $alt); $typed = $ref+$alt; if($typed){$maf=($ref>$alt?$alt:$ref)/$typed}else{$maf=0}  print join("\t", $t[2], @gns), "\n" if $miss_rate<$miss_max and $maf > $maf_cutoff; print STDERR $_, "\n" if $miss_rate<$miss_max and $maf > $maf_cutoff; '   1>${1}_filtered_matrix.tsv     2>${1}_filtered.vcf
