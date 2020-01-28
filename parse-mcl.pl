##############################################################################
#                                TribeMCL                                    #
#    An efficient algorithm for large-scale detection of protein families    # 
##############################################################################

Please Cite:
Enright A.J., Van Dongen S., Ouzounis C.A; Nucleic Acids Res. 30(7):1575-1584 (2002)

Website:http://www.ebi.ac.uk/research/cgg/tribe/manual.txt

Abstract:
---------
      
TribeMCL is a method for clustering proteins into related groups, which are
termed 'protein families'. This clustering is achieved by analysing similarity 
patterns between proteins in a given dataset, and using these patterns to
assign proteins into related groups. In many cases, proteins in the same
protein family will have similar functional properties. TribeMCL uses a novel 
clustering method which solves problems which normally hinder protein sequence 
clustering. These problems include: multi-domain proteins, peptide fragments 
and proteins which possess domains which are very widespread (promiscuous 
domains). The efficiency of the method makes it applicable to the clustering 
of very large datasets. We routinely use the algorithm to cluster datasets 
as large as 500,000 peptides. 

Implementation:
---------------

The algorithm is composed of the core MCL algorithm (written by Stijn Van 
Dongen) and the modules for biological sequence clustering written by Anton 
Enright. Both are written in the C language, and source code is available (see
below). 

Method:
-------

Protein sequence similarities are represented as a graph where nodes represent
proteins and edges represent protein sequence similarities detected using a
method such as BLAST. This graph is weighted according to the -log(E-value)
detected by BLAST for each sequence similarity. The graph is then transformed
into a markov matrix which represents a transition probability between all
nodes of the graph based on connectivities and weights. This matrix is passed
through iterative rounds of expansion (raising the matrix to a power) and
inflation (rescaling transition probabilities after expansion). Matrix 
expansion corresponds to computing the probabilities of random walks of higher
lengths through the graph, while inflation promotes and demotes the 
probabilities of paths in the graph, allowing convergence. Iterative rounds
of expansion and inflation are carried out on the Markov matrix until
no change can be detected. The Markov matrix at this point is then interpreted
as a clustering. This clustering is used to infer protein family relationships
from the initial input set.

For more details please refer to the citation above or to learn more about
the MCL algorithm itself refer to this URL: http://micans.org/mcl/index.html


Input
-----

A parsed set of sequence similarities from BLAST. A simple Perl script is
provided to parse raw NCBI BLAST 2.0 output and produce the corresponding
input file. 

For protein sequence clustering, one needs to take a set of proteins
to be clustered, and use BLAST to detect all similarity relationships
between proteins in the set. The results from this analysis are fed into
TRIBE-MCL and a clustering results is obtained.

The example below shows the input format for TRIBE-MCL. Each line
shows a similarity between two proteins, and a BLAST E-Value for
that similarity. The first line, for example, shows that protein
HINF-KW2-000030 is similar to protein ECOL-RIM-000672 from our
initial input set with a BLAST E-value of 1x10-133.

Parsed Input Format:
--------------------

HINF-KW2-000030	ECOL-RIM-000672	1	133
HINF-KW2-000030	ECOL-EDL-000668	1	133
HINF-KW2-000030	ECOL-MG1-000624	1	133
HINF-KW2-000030	PAER-PAO-004002	1	111
HINF-KW2-000030	XFAS-9A5-001309	6	88
HINF-KW2-000030	CCRE-XXX-001538	2	81
HINF-KW2-000030	RPRO-MAD-000268	1	69
HINF-KW2-000030	AAEO-VF5-000017	1	61
HINF-KW2-000030	BHAL-C12-002566	1	53
HINF-KW2-000030	CJEJ-NCT-001206	1	51

/		/		/	/
|		|		|	|
Protein 1 	|		|	|
		Protein 2	|	|
				|	|
				Number	|
					Exponent (eg 1x10-51)

Output
------

The output file shows each protein from the initial input set
together with the cluster it has been detected in. Typically
proteins in the same protein family are in the same cluster
in this file. The output format can be described as follows:

Cluster No.
|
|	Protein ID
|	|
\	\

8926	HINF-KW2-000019
8926	HPYL-J99-000130
8926	NMEN-MC5-000452
8926	NMEN-Z24-001861
8926	P39414
8926	P75763
8926	P77405
8926	Q07252
8926	Q41364
8926	Q57048
8926	SAUR-MU5-000690
8926	SAUR-MU5-002694
8926	SAUR-MU5-002695
8926	SAUR-N13-000644
8926	SAUR-N13-002484
8927	BSUB-168-001848
8927	P80241
8928	BSUB-168-001849
8929	BSUB-168-001850
8930	BSUB-168-001856
8931	BHAL-C12-002749
8931	BSUB-168-001857

Parameter Settings:
-------------------

The main parameter setting is part of the core MCL algorithm,
and influences the granularity (or size) of the output clusters.
For very small or 'tight' protein families an inflation value
setting of 4.0 or 5.0 is fine. For larger (broader) protein families
settings of 1.1 2.0 and 3.0 can be used. This parameter will be explained
further below and more accurately at: http://micans.org/mcl/index.html

Usage:
------

To use TRIBE-MCL for protein sequence clustering the following simple
protocol is used.
##########################################################################

1) Take a set of protein sequences to be clustered, and use BLAST or some
other similarity tool to perform an all-against-all similarity search
between these proteins.


2) Parse these results into standard TRIBE-MCL format (explained above)
if you are using NCBI BLAST 2.0 then the parse-mcl perl script may be
used as follows:

parse-mcl blast.results > blast.mclparsed


3) Build a markov matrix from the parsed similarity data using the markov
binary:

markov results.mclparsed

This generates a markov-matrix file called 'matrix.mci' and an index file
called 'proteins.index'

Command Line Options for Markov:
--------------------------------

-help		-> Show some help
-ind somefile	-> output the index to 'somefile' instead of 'proteins.index'
-out somefile	-> output the markov matrix to 'somefile' not 'matrix.mci'
-chunk X	-> Set the memory allocation chunksize (default 20MB)
		This should be increased for very large jobs.


4) Run the core MCL algorithm on the markov matrix file:

mcl matrix.mci -options....

The main options here are: 
-------------------------
-I X		-> Set the inflation value to X 
		(must be a real number greater than 1.0)
-progress 100 	-> Show a progress bar with a dot for every 1% 
		complete for every iteration
-o file.out	-> Place results in the file called 'file.out'
-help		-> Show all options and some help


5) Generate the final clusters file using the index file and the results file

mclclusters file.out proteins.index > clusters

This file contains a list of protein IDs and the cluster each protein was
assigned to. It may be desirable to perform further post-processing at this
stage.
##########################################################################

