#!/usr/bin/perl -w
use strict;

my $hmp_file = shift or die "perl $0 hmp_file\n";
my @arr;
open(IN, $hmp_file) or die $!;
while(<IN>){
	chomp;
	my @t = split /\s+/, $_;
	
	if(/^rs/){
		print '##fileformat=VCFv4.1', "\n";
		print join("\t", "\#CHROM",  qw(POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT) )
		      ,"\t", join("\t", @t[11..$#t]), "\n";
		next
	}
	my %allele_cnt;
	map{
		unless(/N/){
		  my @p = split //, $_;
		  map{$allele_cnt{$_}++ }@p;
		}
	}@t[11..$#t];
        my @alleles;
        if($t[1] =~/N/){
	  @alleles = sort {$allele_cnt{$b} <=> $allele_cnt{$a}} keys %allele_cnt;
        }
        else{
          @alleles = split /\//, $t[1];
        }
	next unless (keys %allele_cnt) == 2;
        
        my %called = map{$_, 1}keys %allele_cnt;
        
	my @geno = ();
        
        if(exists $called{$alleles[0]} and exists $called{$alleles[1]}){
	  map{if(/N/){push @geno, "./."}elsif(/$alleles[0]/){push @geno, "0/0:1,0,0"}elsif(/$alleles[1]/){push @geno, "1/1:0,0,1"}else{push @geno, "./."} }@t[11..$#t];
	  ##$t[3] = 1 if $t[3] <= 0;
	  ##$t[3] = int($t[3] * 100000);
	  ##print join("\t", @t[2,3,0], @alleles, ".", ".", ".", "GT:PL", @geno), "\n";
        }
	else{
	  my @arr = map{my $p = $_; $p=~tr/[ATGC]/[TACG]/; $p}@alleles;
          if(exists $called{$arr[0]} and exists $called{$arr[1]}){
	     map{if(/N/){push @geno, "./."}elsif(/$arr[0]/){push @geno, "0/0:1,0,0"}elsif(/$arr[1]/){push @geno, "1/1:0,0,1"}else{push @geno, "./."} }@t[11..$#t];
	  }
	}
	push @arr, [ @t[2,3,0], @alleles, ".", ".", ".", "GT:PL", @geno ] if @geno > 0;
}
close IN;

@arr = sort{$a->[0] cmp $b->[0] || $a->[1] <=> $b->[1]}@arr;
my ($chr, $pre_pos) = ("", "");
map{
  my @p = @$_;
  if($p[0] eq $chr){
    if($p[1] <= $pre_pos){$p[1] = $pre_pos + 1;}
    $pre_pos = $p[1];
  }
  else
  {
    $chr = $p[0];
    $pre_pos = $p[1];
  }
  print join("\t", @p), "\n";
}@arr;
