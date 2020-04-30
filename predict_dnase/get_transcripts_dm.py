filename = "dmel-all-no-analysis-r5.57.gff"
outname = "dmel-all-no-analysis-r5.57.transcripts.gff"

file = open(filename)
outfile = open(outname, 'w')

prev_chr = ''
prev_start = 0

for l in file:

	if l[0] == '#' or l[0] == '>':
		
		continue

	else:

		line = l.rstrip('\n')
		cols = line.split('\t')

		if len(cols) > 3:

			feature = cols[2]

			if feature == "mRNA":

				chrom = cols[0]
				start = int(cols[3])

				if (chrom != prev_chr) or (start != prev_start):

					outfile.write(l)
					prev_chr = chrom
					prev_start = start

file.close()
outfile.close()