# bed to fasta

bedtools getfasta \
-fo ENCFF135JRM_nonpeaks.fa \
-fi ~/taylor/rotation/taylor_git/predict_dnase/hg38.fa \
-bed ENCFF135JRM_nonpeaks.bed

# Note: need to get rid of NNNNN sequences

bedtools getfasta \
-fo ENCFF135JRM_peaks_sorted.fa \
-fi ~/taylor/rotation/taylor_git/predict_dnase/hg38.fa \
-bed ENCFF135JRM_peaks_sorted.bed