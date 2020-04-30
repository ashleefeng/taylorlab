file = open("OnTheFly_2014_Drosophila.meme")
out = open("OnTheFly_2014_Drosophila_motif_IDs.txt", 'w')

for line in file:

    line = line.rstrip('\n')
    tokens = line.split(' ')

    if tokens[0] == "MOTIF":
        out.write(line + '\n')


file.close()
out.close()