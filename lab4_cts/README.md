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
- See this report: [report_clock_skew](https://github.com/trong420/icc/blob/main/lab4_cts/report-clock-skew.txt)

```bash
report_clock_tree -summary
```
- See this report: [report_clock_tree_summary](https://github.com/trong420/icc/blob/main/lab4_cts/report-clock-tree-summary.txt)

```bash
report_constraint -all
```
- See this report: [report_constraint](https://github.com/trong420/icc/blob/main/lab4_cts/report_constraint.txt)

- Open an InteractiveCTSWindow by selecting Clock -> New Interactive CTS Window. Perform closer analysis of SDRAM_CLK by selecting it from the list, then clicking on the button that became selectable: “Show clock tree browser of selected clock”.

![image](https://github.com/trong420/icc/assets/90754954/c5bc6996-0d95-44f8-a917-30800b14e753)

-  New sub-window opens. Maximize it by double-clicking on its title bar. 

- Select the “+” next to SDRAM_CLK, then select sdram_clk, which is the name of the start point (an input port) of the SDRAM_CLK clock. On the right you should see a long list of all the sinks (end-points) connected to this clock. Use the right panel (NextLevelFanout) to analyze the sinks.

![image](https://github.com/trong420/icc/assets/90754954/c0b3bfb9-29f2-42d9-9258-4b38cefef366)


**3. Preparing for Clock Tree Synthesis** 

- Use the GUI or the shell to set the clock target skew to 0.1 for all clocks.Relaxing the skew target from the default of 0 will speed up clock tree synthesis.

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

  A. Define an NDR rule called CLOCK_DOUBLE_SPACING with these 
spacing values: 
METAL3 0.42 METAL4 0.63 
METAL5 0.82 

  B. Report the defined NDR rule and verify that the spacing values are 
specified correctly: 
report_routing_rule CLOCK_DOUBLE_SPACING 

  C. Direct CTS to use CLOCK_DOUBLE_SPACING NDRs on all clock route segements, except for the “first level” (level 1) sinks, which should use default routing rules; Restrict the clock routes to metal layers METAL3 – METAL5.

- Verify that the “Layers Available for Clock Routing” and “Buffers Available for Clock Tree Synthesis” have been 
correctly defined.

```bash
report_clock_tree -settings
```
- See this report: [report_clock_tree_setting](https://github.com/trong420/icc/blob/main/lab4_cts/report_clock_tree_setting.txt)
  
- Perform the following check prior to running CTS: 

```bash
check_physical_design -stage pre_clock_opt -display
```

![image](https://github.com/trong420/icc/assets/90754954/c80dbb68-5aa5-4140-8494-0be36f2007c0)

- Set the clock delay calculator to Arnoldi. This causes the delay calculation to use the more accurate Arnoldi-based delay models on clock nets in a post CTS design (instead of the default Elmore-based delay model).
```bash
set_delay_calculation -arnoldi 
```


- Use the following command to check for any clock tree issue: 
```bash
check_clock_tree
```


**4. Perform Clock Tree Synthesis**

- Synthesize all clock trees, without any timing optimization or routing: 
```bash
clock_opt -only_cts -no_clock_route 
```

- Review the global skew summary after CTS: 
```bash
report_clock_tree -summary
```
- See this report: [report_clock_tree_summary_2](https://github.com/trong420/icc/blob/main/lab4_cts/report-clock-tree-summary_2.txt)

- Generate a different skew report using clock timing command:
```bash
report_clock_timing -type skew -significant_digits 3
```
- See this report: [report_clock_timing-type skew](https://github.com/trong420/icc/blob/main/lab4_cts/report_clock_timing-type%20skew.txt)

- Generate a timing report: 
```bash
report_timing
```
- See this report: [report_timing](https://github.com/trong420/icc/blob/main/lab4_cts/report_timing.txt)


**5. Perform Hold Time Optimization**

- Enable hold time fixing:
```bash
set_fix_hold [all_clocks] 
```

- Generate a QoR report:
```bash
report_qor
```

- See this report: [report_qor](https://github.com/trong420/icc/blob/main/lab4_cts/report_qor.txt)

- You could also use the report_area command. 

- Area recovery is done by down-sizing, and thereby slowing down paths with positive timing slack. This down-sizing happens up to a point when the timing slack reaches 0.0 ns, by default. By applying an “area critical range” of 0.2, for example, we are preserving 0.2ns of timing margin (at the expense of a little less area recovery).
  
```bash
set_max_area 0 ;# This is already set previously 
set physopt_area_critical_range 0.2
```

- Ensure that current RC extraction data is available to capture the more accurate “integrated clock global router” (ICGR) data for clock nets (as opposed to virtual-route based data). 

```bash
extract_rc
```

- Perform post-CTS timing, area and scan chain optimization, without clock 
routing: 

```bash
clock_opt -only_psyn -area_recovery -optimize_dft \-no_clock_route
```

![image](https://github.com/trong420/icc/assets/90754954/2752ae35-b9fa-49fc-addc-87126178358c)

- Save the cell as clock_opt_psyn
  
  
**6. Route the Clocks**

- Route the clocks: 
```bash
route_zrt_group -all_clock_nets \-reuse_existing_global_route true
```

- This will perform global routing, track assign and detail routing on all the clock nets in the design. Analyze all constraints one last time to ensure there are no timing/DRC violations.

- Save the cell as clock_opt_route.

- To obtain actual wiring statistics:

```bash
report_design -physical
```

- See this report: [report_design_physical](https://github.com/trong420/icc/blob/main/lab4_cts/report_design_physical.txt)

- To analyze the clock net level topology, select “Clock Trees” visual mode to display the clock tree type and level information. In the panel that opens, select “Reload”

![image](https://github.com/trong420/icc/assets/90754954/ff4a49bc-34cf-45c6-b9fc-14111b9828a5)


---
NEXT
- LAB5: [Routing](https://github.com/trong420/icc/tree/main/lab5_route)
