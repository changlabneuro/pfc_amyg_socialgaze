import os, itertools, time
import sys

n = int(sys.argv[1])

for i in range(1, n+1):
    os.system('sbatch cluster_scripts/cluster_run_%d.sh' % i)