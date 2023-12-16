<div align="center">

<h1>LAB 4: Clock Tree Synthesis</h1>
</div>


**1. Pre-placement Setting and Checks** 

- Open the design library, open the ORCA_floorplanned design cell:

```bash
open_mw_lib orca_lib.mw 
open_mw_cel ORCA_floorplanned
```

- See this report: [report_pnet](https://github.com/trong420/icc/blob/main/lab3_placement/pnet.txt)



![image](https://github.com/trong420/icc/assets/90754954/edb2a5bb-31b0-435e-96ff-274ad91698a7)




**2. Placement and Optimization** 

- Invoke placement and optimization using the appropriate options - congestion was not an issue during design planning:
```bash
place_opt -area_recovery -optimize_dft -power
```



**3. Incremental Optimization** 

- Enable gate-level dynamic power optimization (GLPO):
```bash
set_optimize_pre_cts_power_options
```


- See this report: [report_power](https://github.com/trong420/icc/blob/main/lab3_placement/power.txt)


---
NEXT
- LAB5: [Routing](https://github.com/trong420/icc/tree/main/lab5_route)
