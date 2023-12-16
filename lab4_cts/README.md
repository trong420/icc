<div align="center">

<h1>LAB 4: Clock Tree Synthesis</h1>
</div>


**1. Copy and Load the Working CEL** 

- Open the design library orca_lib.mw

```bash
open_mw_lib orca_lib.mw
```

- Copy the CEL place_opt and name it as clock_opt.
```bash
copy_mw_cel -from place_opt -to clock_opt
```


- Open the clock_opt CEL.
```bash
open_mw_cel clock_opt
```


![image](https://github.com/trong420/icc/assets/90754954/f1fa6c2e-0889-490d-a84b-acb67fe1589d)




**2. Examine the Clock Trees** 

- Use the following commands

```bash
report_clock -skew -attributes
```
- See this report: [report_pnet](https://github.com/trong420/icc/blob/main/lab3_placement/pnet.txt)

```bash
report_clock_tree -summary
```
- See this report: [report_pnet](https://github.com/trong420/icc/blob/main/lab3_placement/pnet.txt)

```bash
report_constraint -all
```
- See this report: [report_pnet](https://github.com/trong420/icc/blob/main/lab3_placement/pnet.txt)

- Open an InteractiveCTSWindow by selecting ClockNew Interactive CTS Window. Perform closer analysis of SDRAM_CLK by selecting it from the list, then clicking on the button that became selectable: “Show clock tree browser of selected clock”.

![image](https://github.com/trong420/icc/assets/90754954/c5bc6996-0d95-44f8-a917-30800b14e753)

-  New sub-window opens. Maximize it by double-clicking on its title bar. 

- Select the “+” next to SDRAM_CLK, then select sdram_clk, which is the name of the start point (an input port) of the SDRAM_CLK clock. On the right you should see a long list of all the sinks (end-points) connected to this clock. Use the right panel (NextLevelFanout) to analyze the sinks.

![image](https://github.com/trong420/icc/assets/90754954/c0b3bfb9-29f2-42d9-9258-4b38cefef366)


**3. Incremental Optimization** 

- Use the GUI or the shell to set the clock target skew to 0.1 for all clocks. 
Relaxing the skew target from the default of 0 will speed up clock tree 
synthesis

```bash
clock_opt -only_cts -no_clock_route
```
- For this design, a skew of 0 is not needed.
  
![image](https://github.com/trong420/icc/assets/90754954/955702a7-ba88-4e9e-a688-cd282cb1ffa5)

- Adjust the clock uncertainties for post-CTS timing analysis and optimization 

```bash
clock_opt -only_psyn -no_clock_route
```

- For this design, to account for clock jitter, issue commands that will set the setup and hold uncertainties for all clocks to 0.1.

![image](https://github.com/trong420/icc/assets/90754954/ebbb53f1-52d2-4090-bba1-2907ca5ffbb6)

- Configure CTS to use non-default routing. You can either explicitly execute each of the A-B-C steps below, or you may instead execute a pre-written script (scripts/ndr.tcl) for all of three steps: 

- A. Define an NDR rule called CLOCK_DOUBLE_SPACING with these 
spacing values: 
METAL3 0.42 METAL4 0.63 
METAL5 0.82 

- B. Report the defined NDR rule and verify that the spacing values are 
specified correctly: 
report_routing_rule CLOCK_DOUBLE_SPACING 

- C. Direct CTS to use CLOCK_DOUBLE_SPACING NDRs on all clock route 
segements, except for the “first level” (level 1) sinks, which should use default 
routing rules; Restrict the clock routes to metal layers METAL3 – METAL5.  

```bash
set_optimize_pre_cts_power_options
```

**4. Incremental Optimization**

**5. Incremental Optimization**

**6. Incremental Optimization**

- See this report: [report_power](https://github.com/trong420/icc/blob/main/lab3_placement/power.txt)


---
NEXT
- LAB5: [Routing](https://github.com/trong420/icc/tree/main/lab5_route)
