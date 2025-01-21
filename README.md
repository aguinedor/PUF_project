# PUF Project

## Dependencies : 

In this section bellow we will explain how to install the tools ghdl, yosys and nextpnr-Xilinx.

### GHDL Dependencies :
Before installing all tools, it can be good to update and upgrade the library manager
```
sudo apt update
sudo apt upgrade
sudo apt install ghdl-mcode 
```

### Yosys Dependencies :
In order to use Yosys correctly, it requires some python dependencies which are **libboost** and **libeigen3-dev** 
```
sudo apt install python3-dev
sudo apt install libboost-all-dev
sudo apt install libeigen3-dev
```
Then you can install yosys
```
sudo apt install yosys
```

### Nextpnr-Xilinx Dependencies :
The last step requires to clone the nextpnr-Xilinx at https://github.com/gatecat/nextpnr-xilinx.git
```
git clone https://github.com/gatecat/nextpnr-xilinx.git
cd nextpnr-xilinx
git submodule update --recursive --init
```

### Generate the bin file from prj-xray :
In order to generate a specific FPGA target database, you have to run two scripts located inside Nextpnr-Xilinx.  
With **xc7a35tcsg324-1** target here is the example: 
```
python3 xilinx/python/bbaexport.py --device xc7a35tcsg324-1 --bba xilinx/xc7a35t.bba
./bba/bbasm --l xilinx/xc7a35t.bba xilinx/xc7a35t.bin
```

## Get Started : 
