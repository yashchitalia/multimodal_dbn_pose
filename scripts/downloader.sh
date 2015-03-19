#! /bin/bash
if [ ! -d data ]; then
    mkdir data
    cd data
    #wget http://vision.grasp.upenn.edu/video/FLIC-full.zip
    #unzip FLIC-full.zip
    #rm -rf FLIC-full.zip
    wget http://www.comp.leeds.ac.uk/mat4saj/lspet_dataset.zip
    unzip lspet_dataset.zip
    rm -rf lspet_dataset.zip
    mkdir lspet_dataset
    mv images lspet_dataset/
    mv joints.mat lspet_dataset/
    mv README.txt lspet_dataset/
    mkdir cad60_dataset
    mv data1/* cad60_dataset/
    rm -rf data1
    cd ..
    python scripts/preprocess_cad60.py
fi
#python scripts/flic_dataset.py
#python scripts/lsp_dataset.py
python scripts/cad60_dataset.py
#python scripts/dataset.py
