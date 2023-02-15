#!/bin/bash
#SBATCH -A p30771
#SBATCH -p short
#SBATCH -t 00:30:00
#SBATCH -o ./logfiles/slurm.%x-%j.out # STDOUT
#SBATCH --job-name="mmap_to_h5py"
#SBATCH -N 1
#SBATCH -n 5
#SBATCH --mem=80G

cd ~

#add project directory to PATH
export PATH=$PATH/projects/p30771/

#load modules to use
module load python/anaconda3.6 

#need to cd to load conda environment

cd /projects/p30771/pythonenvs/CaImAn/
source activate caiman

#need to cd to module directory

cd /home/jma819/caiman_quest/demos/notebooks/caiman_analysis

#inputs are path to directory containing files, number of processors to use and length of batches to concactenate into one file

#inputs from command line
INPUT_normcorrdir=$1
C_frames_dir=$INPUT_normcorrdir'C_frames/'

#run script 
echo "creating h5 files"
python mmap_to_h5py.py $C_frames_dir 5 5

#move h5 files to new directory

cd $C_frames_dir
mkdir groupby5
mv *.h5 groupby5

#compile h5 files for cnmfe


C_frames_dir={${C_frames_dir::-1}}
groupedh5output=$(find . -name *h5* | sed 's/.//' | awk -v C_frames="$C_frames_dir" '{print "\047"C_frames$1"\047"";"}' | sort | tr -d '\n')
CNMFEformat={${groupedh5output::-1}}

echo $CNMFEformat

#start cnmfe








