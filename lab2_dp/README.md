<div align="center">

<h1>LAB 2: Design Planning</h1>
</div>


**1. Load the design** 

- Change to the lab2_dp directory, invoke IC Compiler and start the GUI:
```bash
UNIX% cd lab2_dp
UNIX% icc_shell -gui
```
- Open the orca_setup cell from the orca_lib.mw design library
![image](https://github.com/trong420/icc/assets/90754954/b4ba1cbf-77b9-462c-8fff-39ea39cea014)

- Apply timing and optimization controls which are specified

```bash
source scripts/opt_ctrl.tcl
```


**2. Initialize the floorplan** 

- Create the corner and P/G cells and define all pad cell positions using a provided script:
```bash
source -echo scripts/pad_cell_cons.tcl 
```
- Initialize the floorplan: 
Select Floorplan -> Initialize Floorplan… 
Change the Core utilization to 0.8 (80%). 
Change the Core to left/right/bottom/top spacing to 30. 
Click OK.

![image](https://github.com/trong420/icc/assets/90754954/11422fd5-7079-4434-8d19-5fa14ac57e04)
![image](https://github.com/trong420/icc/assets/90754954/8d44358c-e10e-4376-9b58-d42539aef249)



- Insert the pad fillers to fill the gaps between the pads.

```bash
scripts/insert_pad_filler.tcl
```
![image](https://github.com/trong420/icc/assets/90754954/affdee1f-9559-4167-92be-f85783eab96c)


- After insert pad filler

![image](https://github.com/trong420/icc/assets/90754954/5025e9f4-9723-402d-910a-d1e40359453b)

- Make the “logical” connection (no physical routing) between the power/ground signals and all power/ground pins of the I/O pads, macros and standard cells
```bash
source -echo scripts/connect_pg.tcl 
```


- Build the PAD area power supply ring: 
```bash
create_pad_rings 
```
![image](https://github.com/trong420/icc/assets/90754954/0bcadc31-3106-4bf8-ac6e-3be40ea362cf)

- Save the design as “floorplan_init”:
```bash
save_mw_cel –as floorplan_init 
```

**3. Preplace the macros connected to I/O pads** 

- In this task you will identify the macros that are connected to I/O pad cells and you 
will manually place them in the core area such that their connections to the I/O pads 
are as short as possible

- To ensure that the macros are placed as expected, you can source the following script:
```bash
source -echo scripts/preplace_macros.tcl
```
- Picture of Macro:
  
![image](https://github.com/trong420/icc/assets/90754954/0b61cc45-e82c-4c2c-b4a0-3a58fd630ab7)


- After Preplace with Script above:
  
![image](https://github.com/trong420/icc/assets/90754954/35289c74-a290-4ed1-8961-03e0d2627a4c)



**4. Perform Virtual Flat Placement**

- Apply a sliver size of 10 to prevent standard cells from being placed in narrow channels (< 10 um) between macros:
  
```bash
set_fp_placement_strategy -sliver_size 10
```

- Execute a timing-driven VF placement with “no hierarchy gravity” (to ensure that the “logical hierarchy” does not affect placement of this non-hierarchical or flat layout): 
```bash
create_fp_placement -timing_driven \-no_hierarchy_gravity
```
![image](https://github.com/trong420/icc/assets/90754954/ced5d645-3844-42f5-af6d-c22d861fcedf)

- Examine the global route congestion map: 
```bash
report_congestion -grc_based -by_layer \-routing_stage global 
```


- Routing of power and ground straps and macro rings for this design can be 
made easier if we turn some of the macros into arrays. 
```bash
source -echo scripts/macro_place_cons.tcl
```

- Double check your settings. Suggestion: Use the up-arrow in the icc_shell window to find and re-execute the “strategy” command:
```bash
report_fp_placement_strategy 
report_fp_macro_options 
```
- Source the following script to set a hard keepout margin of 10 microns around 
all macros. This will make it easier to create P/G rings around the macros and 
avoid congestion as well as signal routing DRCs around the macros:
```bash
source -echo scripts/keepout.tcl 
```

- Take one last look at the macro placement before running the VF placer again: 
```bash
create_fp_placement -timing_driven \-no_hierarchy_gravity
```

![image](https://github.com/trong420/icc/assets/90754954/5f21c673-3939-42e3-a491-a006e653c871)




**5. Create P/G Ring Around Macros Groups**

- We have created a script to create P/G rings around six groups of macros.

```bash
source ./scripts/macro_pg_rings.tcl
```
- 

![image](https://github.com/trong420/icc/assets/90754954/e734e1e1-d497-4c3c-b4dc-cc1a1085a7c2)



**6. Incremental Optimization**

- Apply the strap constraints: 
Preroute -> Power Network Constraints -> Strap Layers Constraints... 
Note: 
If you don‟t see this menu switch the task menu to Design 
Planning: File -> Task -> Design Planning 
Select the METAL5 Layer and set the Direction to Horizontal. 
Set the “By strap number” Max to 24 and Min to 2. 
Set the Width Max to 4 and the Min to 2. 
Set the PG Spacing to Microns and enter 0.6. 
Click the Set button. 
Repeat the steps for METAL4 with direction Vertical, with the same 
min/max number of straps, min/max widths, and spacing. 
Set then Close the dialog.

![image](https://github.com/trong420/icc/assets/90754954/81ec0884-972c-461e-80f9-20bb5bd801ef)


- To complete power plan we need to hook up the power pins on all macros, and create the standard cell power rails. Execute the following commands to accomplish this:

```bash
preroute_instances 
preroute_standard_cells -fill_empty_rows \-remove_floating_pieces
```

![image](https://github.com/trong420/icc/assets/90754954/b0038ee0-df32-4aa6-8d12-7d7c41dfdbc2)

 - Now analyze the completed power plan using PrerouteAnalyze Power 
Network… 
Enter the same values for Power Ground nets (VDD VSS), Power budget 
(350 mW), Supply voltage (1.32 V), and Specified pad masters (pv0i pvdi) 
that were used previously for Power Network Synthesis, then press OK. 
You will see another heat map.

![image](https://github.com/trong420/icc/assets/90754954/9dd70b8d-fe87-4232-91da-80c25d58f8a1)



**7. Check the timing**

- PNS created many straps on METAL4 and METAL5, which were placed over the standard cells
  
```bash
set_pnet_options -complete "METAL4 METAL5" 
create_fp_placement -timing_driven \-no_hierarchy_gravity
```


- Since we are about to check timing, perform actual global routing by running the following command:

```bash
route_zrt_global
```
![image](https://github.com/trong420/icc/assets/90754954/d31d4fca-f5bf-447c-b104-1a46e79b3227)

- Bring up the global route congestion map (no need to “Reload).
![image](https://github.com/trong420/icc/assets/90754954/357fd7cc-a87e-4029-8de7-119017e1789f)

- Generate a maximum-delay (setup) timing report using the “view” procedure (it will take a few seconds to update the timing and generate the report):
```bash
report_timing
```

- To fix any timing violations (and design rule violations),
```bash
optimize_fp_timing -fix_design_rule
```
- Save the cell as floorplan_complete.


**8. Write out the DEF Floorplan File**

- Remove all the placed standard cells then write out the floorplan file in DEF format.

```bash
remove_placement -object_type standard_cell 
write_def -version 5.6 -placed -all_vias -blockages \-routed_nets -rows_tracks_gcells -specialnets \-output design_data/ORCA.def 
```

![image](https://github.com/trong420/icc/assets/90754954/a83b9f2c-ef95-4bcf-a2d4-21e24981276b)


![image](https://github.com/trong420/icc/assets/90754954/da2e1ab4-77be-41fd-99ca-ce993bd5ee3d)


- See this report: [report_qor](https://github.com/trong420/icc/blob/main/lab3_placement/report_qor.txt)
---
NEXT
- LAB3: [Design Planning](https://github.com/trong420/icc/tree/main/lab3_placement)
