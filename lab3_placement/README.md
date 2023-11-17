<div align="center">

<h1>LAB 3: Placement</h1>
</div>

**1. Pre-placement Setting and Checks** 

- Open the design library, open the ORCA_floorplanned design cell:

open_mw_lib orca_lib.mw 
open_mw_cel ORCA_floorplanned

![image](https://github.com/trong420/icc/assets/90754954/b5ece38c-e73b-4298-901a-51ffd46b3d19)

- Apply timing and optimization controls: 
source scripts/opt_ctrl.tcl

- Macro placement is usually defined and “fixed” during design planning
set_dont_touch_placement [all_macro_cells] 

- Verify that all process metal layers are available for routing - there should be no ignored layers:
report_ignored_layers
![image](https://github.com/trong420/icc/assets/90754954/24d1c682-39d7-4a8e-9ffa-261d74514201)

- Verify that standard cells are allowed to be placed under the METAL2 – METAL4 power nets, as long as no DRC violations occur (partial blockage): 
report_pnet_options

- During design planning both soft and hard placement keepouts were applied. Verify that these variables are still set and are not the default value of zero: 
printvar physopt_hard_keepout_distance 
printvar placer_soft_keepout_channel_width 
![image](https://github.com/trong420/icc/assets/90754954/729362f3-be7c-465b-b0d4-b013d630e514)

- The clock nets will be constrained to be routed on METAL3 – METAL6, with double-spacing rules. Non-default routing (NDR) rules affect congestion, which can affect placement. Apply the non-default routing rules for all clock nets, as shown below, by sourcing the ndr.tcl file
source scripts/ndr.tcl

![image](https://github.com/trong420/icc/assets/90754954/edb2a5bb-31b0-435e-96ff-274ad91698a7)

Verify that the floorplanned design is ready for placement:
check_physical_design -stage pre_place_opt
How to fix

- Execute a different pre-placement check: 
check_physical_constraints

- Execute the following command to confirm that no scan chain information exists: 
report_scan_chain 
The report is empty, which means that no scan chain annotation exists.

- Load the SCANDEF file (which was generated during synthesis, after scan insertion): 
read_def design_data/ORCA_TOP.scandef 

- Generate another scan chain report. Use the “view” TCL procedure:
report_scan_chain


We do not have a simulator-generated SAIF file, which is preferred, so instead 
we will read in a user-generated toggle-rate file.
 
source scripts/inputs_toggle_rate.tcl 
report_saif

![image](https://github.com/trong420/icc/assets/90754954/7f321005-f5f4-43f2-874c-4511b19834be)

- We do not have multi-Vth libraries, so there is no need to modify the logical and physical library settings. Even without the multi-Vth libraries IC Compiler can still achieve some leakage power reduction by cell down-sizing and buffer removal. Leakage power optimization is enabled by default. You can confirm this with: 

report_power

- Enable low-power placement (LPP) dynamic power optimization. Gate-level dynamic power optimization (GLPO) will be enabled after place_opt, just before psynopt:
set_power_options -low_power_placement true 
report_power

- Save the current design with its pre-placement settings:
save_mw_cel -as ORCA_preplace_setup

**2. Placement and Optimization** 

- Invoke placement and optimization using the appropriate options - congestion was not an issue during design planning:
place_opt -area_recovery -optimize_dft -power
![image](https://github.com/trong420/icc/assets/90754954/b8d5ffbd-50d6-45d5-b567-1acf18121cd0)

- Save the current design: 
save_mw_cel -as ORCA_place_opt 

- Generate a congestion map from the LayoutWindow: 
Global Route Congestion -> Reload -> OK 
The GUI step is the same as executing the following command: 
report_congestion -grc_based -by_layer \-routing_stage global 

![image](https://github.com/trong420/icc/assets/90754954/b31f9630-662e-4604-89fa-163c7045b269)

- Generate a physical design report and scroll to the top of the output: 
report_design -physical

- Generate a QoR (quality of results) report: 
report_qor 

- Report the power dissipation: 
report_power 

**3. Incremental Optimization** 

- Enable gate-level dynamic power optimization (GLPO):
set_optimize_pre_cts_power_options

- Perform incremental logic optimization, using appropriate options:
psynopt -area_recovery -power

- Generate a congestion map and verify that it is about the same as before: 
Global Route Congestion -> Reload -> OK

![image](https://github.com/trong420/icc/assets/90754954/5059ede8-ecdc-49d2-9944-086859663326)


- Generate a physical design report and scroll to the top of the output: 
report_design -physical

- Report the power dissipation:
report_power

- Save the design and exit IC Compiler: 
save_mw_cel -as ORCA_placed 

---
NEXT
- LAB4: [Clock Tree Synthesis](https://github.com/trong420/icc/tree/main/lab4_cts)
