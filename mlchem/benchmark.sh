#!/bin/bash
# This is a benchmark script used for checking the performance on several host systems

WORKDIR=/tmp/benchmark
rm -rf $WORKDIR && mkdir -p $WORKDIR && cd $WORKDIR


echo "Part 1. OpenMM benchmark"
git clone --depth 1 https://github.com/openmm/openmm.git >/dev/null 2>&1
cd openmm/examples/
echo "Testing CPU performance"
python benchmark.py --test apoa1pme --seconds 10 --platform CPU --precision single --outfile ../openmm-cpu.json >/dev/null 2>&1

# Probing CUDA platform
python -c "import openmm; openmm.Platform.getPlatformByName('CUDA')" >/dev/null 2>&1
if [[ $? -eq 0 ]]
then
    echo "Testing CUDA performance"
    python benchmark.py --test apoa1pme --seconds 10 --platform CUDA --precision single --outfile ../openmm-cuda.json >/dev/null 2>&1
else
    echo "No cuda platform found. Skip test"
fi

cd $WORKDIR
echo "Part 2. GPAW benchmark"
mkdir -p gpaw-fullerene && cd gpaw-fullerene
echo "Download test set"
wget https://raw.githubusercontent.com/mlouhivu/gpaw-benchmarks/master/single-fullerene/POSCAR >/dev/null 2>&1
cat >input-cpu.py <<EOF
from __future__ import print_function
from gpaw.mpi import size, rank
from gpaw import GPAW, Mixer, ConvergenceError
from gpaw.occupations import FermiDirac
from ase.io import read

args = {'h': 0.25,
        'nbands': -180,
        'occupations': FermiDirac(0.2),
        'kpts': (2, 2, 1),
        'xc': 'PBE',
        'mixer': Mixer(0.1, 5, 100),
        'eigensolver': 'rmm-diis',
        'maxiter': 10,
        'txt': 'output-cpu.txt',
        'parallel': {'sl_default': (2, 2, 64)}
        }
atoms = read('POSCAR')
calc = GPAW(**args)
atoms.calc = calc

# execute the run
try:
    atoms.get_potential_energy()
except ConvergenceError:
    pass
EOF

echo "Testing PBE on Fullerene"
NP=8
mpirun -np $NP python input-cpu.py 2>/dev/null

cd $WORKDIR
echo "Part 3. OCP Training and Inference"
