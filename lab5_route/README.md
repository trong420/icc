<div align="center">

<h1>LAB 5: Routing</h1>
</div>


**1. Load the Design and Common Settings** 

- Change to the lab5_route directory, then invoke IC Compiler. Make a working copy of the CEL named clock_opt_route from the library orca_lib.mw, then open the copy:

```bash
open_mw_lib orca_lib.mw 
copy_mw_cel -from clock_opt_route -to signal_route 
open_mw_cel signal_route 
start_gui
```

![image](https://github.com/trong420/icc/assets/90754954/8cb0414b-d239-4bfe-ae95-d9317f73b1d9)

- Load the common settings which were used during the placement and CTS phases of this design, and which are also required for the routing phase:
  
```bash
source scripts/common_optimization_settings_icc.tcl 
source scripts/common_placement_settings.tcl 
source scripts/common_post_cts_timing_settings.tcl 
source scripts/common_route_si_settings_zrt_icc.tcl
```



**2. Placement and Optimization** 

- Invoke placement and optimization using the appropriate options - congestion was not an issue during design planning:
```bash
place_opt -area_recovery -optimize_dft -power
```



- See this report: [report_qor](https://github.com/trong420/icc/blob/main/lab3_placement/report_qor.txt)



**3. Incremental Optimization** 

- Enable gate-level dynamic power optimization (GLPO):
```bash
set_optimize_pre_cts_power_options
```


- See this report: [report_power](https://github.com/trong420/icc/blob/main/lab3_placement/power.txt)



---
NEXT
- LAB6: [Chip Finishing](https://github.com/trong420/icc/tree/main/lab6_chip_finishing)
