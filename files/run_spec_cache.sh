#!/bin/bash

# Ο φάκελος όπου είναι το gem5
GEM5="./build/ARM/gem5.opt"
CONFIG="configs/example/se.py"

# Δημιουργία benchmarks ως strings
declare -A BENCHMARKS
BENCHMARKS["specbzip"]='spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10"'
BENCHMARKS["specmcf"]='spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in"'
BENCHMARKS["spechmmer"]='spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm"'
BENCHMARKS["specsjeng"]='spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt"'
BENCHMARKS["speclibm"]='spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of"'

# Σταθερές επιλογές CPU
CPU_TYPE="MinorCPU"
CPU_CLOCK="1GHz"

# Ορίζουμε παραλλαγές caches με διαφορετικά sizes, associativities και cacheline size
declare -A CACHE_CONFIGS
CACHE_CONFIGS["test_1"]="--l1d_size=128kB --l1i_size=64kB --l2_size=1MB --l1d_assoc=4 --l1i_assoc=2 --l2_assoc=16 --cacheline_size=32"
CACHE_CONFIGS["test_2"]="--l1d_size=128kB --l1i_size=32kB --l2_size=512kB --l1d_assoc=4 --l1i_assoc=4 --l2_assoc=16 --cacheline_size=64"
CACHE_CONFIGS["test_3"]="--l1d_size=64kB --l1i_size=64kB --l2_size=1MB --l1d_assoc=8 --l1i_assoc=2 --l2_assoc=16 --cacheline_size=64"
CACHE_CONFIGS["test_4"]="--l1d_size=128kB --l1i_size=64kB --l2_size=2MB --l1d_assoc=4 --l1i_assoc=4 --l2_assoc=16 --cacheline_size=64"
CACHE_CONFIGS["test_5"]="--l1d_size=128kB --l1i_size=128kB --l2_size=4MB --l1d_assoc=8 --l1i_assoc=4 --l2_assoc=32 --cacheline_size=64"
CACHE_CONFIGS["test_6"]="--l1d_size=128kB --l1i_size=64kB --l2_size=1MB --l1d_assoc=4 --l1i_assoc=2 --l2_assoc=16 --cacheline_size=128"
CACHE_CONFIGS["test_7"]="--l1d_size=128kB --l1i_size=32kB --l2_size=2MB --l1d_assoc=8 --l1i_assoc=2 --l2_assoc=32 --cacheline_size=128"
CACHE_CONFIGS["test_8"]="--l1d_size=128kB --l1i_size=32kB --l2_size=2MB --l1d_assoc=8 --l1i_assoc=8 --l2_assoc=16 --cacheline_size=128"
CACHE_CONFIGS["test_9"]="--l1d_size=128kB --l1i_size=64kB --l2_size=4MB --l1d_assoc=8 --l1i_assoc=8 --l2_assoc=32 --cacheline_size=128"
CACHE_CONFIGS["test_10"]="--l1d_size=128kB --l1i_size=128kB --l2_size=4MB --l1d_assoc=8 --l1i_assoc=8 --l2_assoc=64 --cacheline_size=256"

# Εκτέλεση benchmarks για κάθε cache configuration
for size in "${!CACHE_CONFIGS[@]}"; do
    echo "=== Running benchmarks with $size cache configuration ==="
    for bench in "${!BENCHMARKS[@]}"; do
        echo "Running $bench with $size caches..."
        BASE_OPTS="--cpu-type=$CPU_TYPE --caches --l2cache --cpu-clock=$CPU_CLOCK -I 100000000"
        eval "$GEM5 -d spec_results_caches/${bench}_cache_$size $CONFIG $BASE_OPTS ${CACHE_CONFIGS[$size]} -c ${BENCHMARKS[$bench]}"
    done
done

echo "Finished all benchmarks."
