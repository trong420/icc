# reset
set_fp_rail_constraints -remove_all_layers
remove_fp_virtual_pad -all              
set_fp_rail_strategy -reset             
set_fp_block_ring_constraints -remove_all
set_fp_rail_region_constraints  -remove 
# global constraints
set_fp_rail_constraints -set_global -no_routing_over_hard_macros 

# layer constraints
set_fp_rail_constraints -add_layer  -layer METAL5 -direction horizontal -max_strap 24 -min_strap 2 -max_width 4.000000 -min_width 2.000000 -spacing 0.600000 
set_fp_rail_constraints -add_layer  -layer METAL4 -direction vertical -max_strap 24 -min_strap 2 -max_width 4.000000 -min_width 2.000000 -spacing 0.600000 

# ring and strap constraints
set_fp_rail_constraints  -set_ring -nets { VDD VSS } -horizontal_ring_layer { METAL3 } -vertical_ring_layer { METAL2 } -ring_max_width 12.000000 -ring_min_width 10.000000 -extend_strap core_ring 

# strategies
set_fp_rail_strategy  -use_tluplus true 

# block ring constraints
set_fp_block_ring_constraints -add -horizontal_layer METAL5 -horizontal_width 3.000000 -horizontal_offset 0.600000 -vertical_layer METAL4 -vertical_width 3.000000 -vertical_offset 0.600000 -spacing 0.000000 -block_type instance -block { I_CLOCK_GEN/I_PLL_PCI } -net { VDD VSS } 

# regions

# virtual pads

# synthesize_fp_rail 
synthesize_fp_rail -nets { VDD VSS } -voltage_supply 1.320000 -power_budget 350.000000   
