#! /bin/bash
if [ ! -d data ]; then
    mkdir data
    cd data
    mkdir cad60_dataset
    mv data1/* cad60_dataset/
    #rm -rf data1
    cd ..
    python scripts/preprocess_cad60.py
fi
#python scripts/flic_dataset.py
#python scripts/lsp_dataset.py
python scripts/cad60_dataset.py
#python scripts/dataset.py
