#!/bin/sh

#SBATCH --job-name=decoding
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-type=NONE
#SBATCH --partition=week
#SBATCH --time=7-00:00:00
module load MATLAB/2020a
matlab -nodisplay -nosplash -r "run('/gpfs/milgram/scratch60/chun/mz456/chang_neural_decoding/scripts/%s');"