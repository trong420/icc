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



**2. Ensure That The Design Is Ready For Routing** 

- Analyze the design for setup and hold timing, as well as logical DRCs:
```bash
report_constraint -all 
```


- Verify that there are no ideal nets and no high fanout nets: 
```bash
all_ideal_nets 
all_high_fanout -nets -threshold 501
```


- If the commands return nothing then the design doesn’t have ideal nets or nets with a fanout that is greater than 500. You can rerun the all_high_fanout command with lower threshold values if your HFN (high fanout net) strategy allows unbuffered HFNs at lower levels

  ![image](https://github.com/trong420/icc/assets/90754954/acdf43a6-52f5-4f70-b70d-fe4fb8b5f41c)


- Verify that the preferred routing directions are as expected, and that TLUPlus files are loaded:

```bash
report_preferred_routing_direction 
report_tlu_plus_files
```
- See this report: [report_preferred_routing_direction](https://github.com/trong420/icc/blob/main/lab5_route/report_preferred_routing_direction.txt)

- See this report: [report_tlu_plus_files](https://github.com/trong420/icc/blob/main/lab5_route/report_tlu_plus_files.txt)

  
- Verify that all placements are legal:
```bash
check_legality
```
  ![image](https://github.com/trong420/icc/assets/90754954/5d14dba1-cd44-4b71-b093-2ccdbe2a2536)

 


- Verify that all power and ground pins are physically connected to P/G nets:
```bash
verify_pg_nets
```
  
 ![image](https://github.com/trong420/icc/assets/90754954/c2f29546-370b-40a0-8de3-35af0954a12b)

- We will use the error browser to locate the problem:

- In the LayoutWindow select Verification -> Error Browser … to open the “Error Browser” dialog window. Check the “Rail” box (since this is a P/G problem). 

- To the right of the empty rail field click on the icon. There should be one error cell highlighted. Click OK to select it. Click OK at the bottom of the “Load Error Cell” dialog. The Error Browser dialog re-appears. In the top pane select the “Rail” error type. A detailed list of errors appears in the second pane, with the first one automatically selected. In the LayoutWindow you should notice that the layout has automatically zoomed to the selected error location.

![image](https://github.com/trong420/icc/assets/90754954/2421fd1b-05bf-462f-9fcd-7b70d69dc7bb)

- Fix the P/G connection problem by routing the standard cell P/G rails:
```bash
preroute_standard_cells -remove_floating_pieces 
verify_pg_nets
```

![image](https://github.com/trong420/icc/assets/90754954/4c23ce53-5f51-4d09-bdd1-1736c4f58157)


**3. Incremental Optimization** 

- Enable “concurrent” redundant via insertion:

```bash
set_route_zrt_common_options \-post_detail_route_redundant_via_insertion medium 
set_route_zrt_detail_options \-optimize_wire_via_effort_level medium
```
  ![image](https://github.com/trong420/icc/assets/90754954/506c8159-bad3-445d-b155-b9461f6a6ef9)

- Run the following report commands to check non-default routing rules and 
routing setup: 


```bash
report_routing_rules 
report_route_opt_strategy 
report_route_zrt_common_options 
report_route_zrt_global_options 
report_route_zrt_track_options
report_route_zrt_detail_options
```

- See this report: [report_routing_rules](https://github.com/trong420/icc/blob/main/lab5_route/report_routing_rules.txt)
- See this report: [report_route_opt_strategy](https://github.com/trong420/icc/blob/main/lab5_route/report_route_opt_strategy.txt)
- See this report: [report_route_zrt_common_options](https://github.com/trong420/icc/blob/main/lab5_route/report_route_zrt_common_options%20.txt)
- See this report: [report_route_zrt_global_options](https://github.com/trong420/icc/blob/main/lab5_route/report_route_zrt_global_options.txt)
- See this report: [report_route_zrt_detail_options](https://github.com/trong420/icc/blob/main/lab5_route/report_route_zrt_detail_options.txt)
  
![image](https://github.com/trong420/icc/assets/90754954/0fd11546-8102-4857-8a8c-33ace0432e1f)

- Perform initial routing, which includes global routing, track assignment and detail routing: 

```bash
route_opt -initial_route_only
```

![image](https://github.com/trong420/icc/assets/90754954/b762b0df-3e35-4204-bc6a-19a2aaa09032)

- Generate post-initial-route reports: 

```bash
report_clock_tree -summary 
report_clock_timing -type skew 
report_qor 
report_constraints -all
```

- See this report folder: [post-initial-route reports](https://github.com/trong420/icc/tree/main/lab5_route/post-initial-route%20reports)

- Perform post-initial route optimization with -power to optimize for power. The -skip_initial_route option prevents the initial route from being completely ripped up and re-routed:

```bash
route_opt -skip_initial_route -power
```

![image](https://github.com/trong420/icc/assets/90754954/d6232afc-f5b2-44b5-9f68-b01e93c5a611)

- Ensure that the logical P/G connections are up to date after routing:
  
```bash
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS 
derive_pg_connection -power_net VDD -ground_net VSS \-tie
```

![image](https://github.com/trong420/icc/assets/90754954/2e5a0cfb-a05f-4256-9016-035206947097)

**4. DRC and LVS Error Checking and Fixing** 

- Run the signal route verification tools: 
```bash
verify_zrt_route
verify_lvs
```

![image](https://github.com/trong420/icc/assets/90754954/8c54ff4a-2ab2-4fc8-b44d-4ab2103b1ba3)

- There are shorts in the routed design.
  
  ![image](https://github.com/trong420/icc/assets/90754954/b1504817-765b-4e78-8e00-de0df7131df6)

- The next step is to run incremental route_opt to see if that will fix the shorts. 

```bash
route_opt -incremental
```
- But it hasn't been fixed yet.

![image](https://github.com/trong420/icc/assets/90754954/083f0154-5167-47a1-ae0a-77d31a7c818b)

- Try running ECO route.

```bash
route_zrt_eco
```

![image](https://github.com/trong420/icc/assets/90754954/53e6423a-d064-4a5f-ac3e-b5195edea568)

- Examine the layout for redundant via insertion. Also, generate the following report and look for this statement near the end: 
“Double Via rate for all layers:”

```bash
report_design_physical -route
```

- Save the design as route_opt_final:
```bash
save_mw_cel -as route_opt_final
```
![image](https://github.com/trong420/icc/assets/90754954/ad4007f7-1001-4e1e-819e-af972788167f)

**5. GUI Analysis Tools**

- Color the display by net capacitance values. Click the down arrow next to the snapshot button.

- Select “Net Capacitance”. Click “Reload”. Click OK when the “Net Capacitance” dialog pops up. Nets with different capacitance values are highlighted with different color codes

![image](https://github.com/trong420/icc/assets/90754954/93b0c0fd-93d3-4d09-b935-f7e72e89de0f)

- Highlight cells according to their timing slack.

![image](https://github.com/trong420/icc/assets/90754954/34403adf-a1a5-4884-b9e0-ee093e828e40)

- At the top of the “Visual Mode” dialog, pull down the menu reading “Net Capacitance” and select “Cell Slack”. Click “Reload”, then press OK in the new dialog to accept the defaults.

![image](https://github.com/trong420/icc/assets/90754954/dc7736d5-7b91-4311-b121-59cf7e4e446f)

- In a similar manner, you can highlight cells by logical hierarchy. Give it a try to look at the location of various Verilog module’s cells.

![image](https://github.com/trong420/icc/assets/90754954/6593b80a-f61a-480c-b8cb-785250542700)


- See this report: [report_power](https://github.com/trong420/icc/blob/main/lab3_placement/power.txt)



---
NEXT
- LAB6: [Chip Finishing](https://github.com/trong420/icc/tree/main/lab6_chip_finishing)
