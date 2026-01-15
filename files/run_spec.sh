#!/bin/bash

# Ο φάκελος όπου είναι το gem5
GEM5="./build/ARM/gem5.opt"
CONFIG="configs/example/se.py"

# Δημιουργία benchmarks ως strings (με quotes)
declare -A BENCHMARKS
BENCHMARKS["specbzip"]='spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10"'
BENCHMARKS["specmcf"]='spec_cpu2006/429.mcf/src/specmcf -o "spec_cpu2006/429.mcf/data/inp.in"'
BENCHMARKS["spechmmer"]='spec_cpu2006/456.hmmer/src/spechmmer -o "--fixed 0 --mean 325 --num 45000 --sd 200 --seed 0 spec_cpu2006/456.hmmer/data/bombesin.hmm"'
BENCHMARKS["specsjeng"]='spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt"'
BENCHMARKS["speclibm"]='spec_cpu2006/470.lbm/src/speclibm -o "20 spec_cpu2006/470.lbm/data/lbm.in 0 1 spec_cpu2006/470.lbm/data/100_100_130_cf_a.of"'

    
# Default options
BASE_OPTS="--cpu-type=MinorCPU --caches --l2cache -I 100000000"

# Εκτέλεση αρχικών benchmarks
echo "=== Running benchmarks with default settings ==="
for bench in "${!BENCHMARKS[@]}"; do
    echo "Running $bench..."
    eval "$GEM5 -d spec_results/$bench $CONFIG $BASE_OPTS -c ${BENCHMARKS[$bench]}"
done

# Εκτέλεση με διαφορετικά CPU clocks
for CLOCK in 1GHz 4GHz; do
    echo "=== Running benchmarks with --cpu-clock=$CLOCK ==="
    for bench in "${!BENCHMARKS[@]}"; do
        echo "Running $bench..."
        eval "$GEM5 -d spec_results/${bench}_clock_${CLOCK} $CONFIG $BASE_OPTS --cpu-clock=$CLOCK -c ${BENCHMARKS[$bench]}"
    done
done


# Εκτέλεση με μνήμη DDR3_2133_8x8
echo "=== Running benchmarks with memory DDR3_2133_8x8 ==="
for bench in "${!BENCHMARKS[@]}"; do
    echo "Running $bench..."
    eval "$GEM5 -d spec_results/${bench}_DDR3 $CONFIG $BASE_OPTS --mem-type=DDR3_2133_8x8 -c ${BENCHMARKS[$bench]}"
done

echo "finished all done"
