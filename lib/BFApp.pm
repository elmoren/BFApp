package BFApp;

use strict;
use warnings;
use Carp;

sub blastDBs {
    my $files = get_files('public/blastdb');
    my %dbs;
    foreach my $file (@{$files}) {
	next if not ($file =~ m/\.nin$/); # this file IDs the source fasta
	my $name = (split /\./, $file)[0];
	$dbs{$name} = 1 if not exists $dbs{$name};
    }
    return [keys %dbs];
};

sub get_files {
    my $directory = shift;
    opendir (DIR, $directory) or die "Cannot find $!";

    my @dbs;
    while (my $file = readdir(DIR)) {
	next if $file =~ m/^\.*$/;
	push @dbs, $file;
    }
    return \@dbs;
};

sub to_aa {

    my $nt = shift;
    my $aa = "";
    # Must be divisible by three
    croak if length($nt) % 3;

    for(my $i=0; $i < (length( $nt ) - 2); $i += 3) {
	my $codon = substr( $nt, $i, 3);
	$aa .= _aa ($codon);
    }
    
    return $aa;

};

sub _aa {
    my $codon = shift;
 
       if ( $codon =~ /GC./i)        { return 'A' }    # Alanine
    elsif ( $codon =~ /TG[TC]/i)     { return 'C' }    # Cysteine
    elsif ( $codon =~ /GA[TC]/i)     { return 'D' }    # Aspartic Acid
    elsif ( $codon =~ /GA[AG]/i)     { return 'E' }    # Glutamic Acid
    elsif ( $codon =~ /TT[TC]/i)     { return 'F' }    # Phenylalanine
    elsif ( $codon =~ /GG./i)        { return 'G' }    # Glycine
    elsif ( $codon =~ /CA[TC]/i)     { return 'H' }    # Histidine
    elsif ( $codon =~ /AT[TCA]/i)    { return 'I' }    # Isoleucine
    elsif ( $codon =~ /AA[AG]/i)     { return 'K' }    # Lysine
    elsif ( $codon =~ /TT[AG]|CT./i) { return 'L' }    # Leucine
    elsif ( $codon =~ /ATG/i)        { return 'M' }    # Methionine
    elsif ( $codon =~ /AA[TC]/i)     { return 'N' }    # Asparagine
    elsif ( $codon =~ /CC./i)        { return 'P' }    # Proline
    elsif ( $codon =~ /CA[AG]/i)     { return 'Q' }    # Glutamine
    elsif ( $codon =~ /CG.|AG[AG]/i) { return 'R' }    # Arginine
    elsif ( $codon =~ /TC.|AG[TC]/i) { return 'S' }    # Serine
    elsif ( $codon =~ /AC./i)        { return 'T' }    # Threonine
    elsif ( $codon =~ /GT./i)        { return 'V' }    # Valine
    elsif ( $codon =~ /TGG/i)        { return 'W' }    # Tryptophan
    elsif ( $codon =~ /TA[TC]/i)     { return 'Y' }    # Tyrosine
    elsif ( $codon =~ /TA[AG]|TGA/i) { return '_' }    # Stop
    elsif ( $codon =~ /N/g)          { return 'X' }    # If contains "N", Use N 
    else { croak "Unkown codon : \"$codon\"\n";   }    # Anything else is error
};

1;
