filename = "data/gencode.v29.annotation.gtf"
outname = "data/gencode.v29.annotation.transcripts.gtf"

file = open(filename)
outfile = open(outname, 'w')

for l in file:

	if l[0] == '#':

		continue

	else:

		line = l.rstrip('\n')
		cols = line.split('\t')
		feature = cols[2]

		if feature == "transcript":

			outfile.write(l)

file.close()
outfile.close()