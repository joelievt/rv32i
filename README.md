# RV32I FPGA Implementation

This repository implements the RV32I instruction set of the RISC-V family.

## How to build

To create the Vivado project, run the following command from the root of the repo:

```
vivado -mode batch -source scripts/create_project.tcl
```

This will generate a Vivado project inside of the `build` folder.
