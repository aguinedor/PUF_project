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

In order to use the open source script, you can access it in :
```
PUF_project/flow_puf/flow_FPGA
```
The script is composed of three parts :  
- **Variables Declaration** with different paths *$TOP* *$INPUT_DIR* *$STORE_DIR*  

The *Top* should correspond to the top of the design.  
The *Input_dir* is the directory with all the .vhdl files.  
The *Store_dir* is the directory with temporary files such as logs.

- **Args parsing** is used to support both three tools :

*--ghdl*  *--yosys*  *--nextpnr*
  
- **Script execution** performs the different commands.
