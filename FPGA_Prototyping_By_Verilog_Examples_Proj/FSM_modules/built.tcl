read verilog "Parking_Lot_Counter.v"

read_xdc "Master.xdc"

synth_desgin -top "Parking_Lot_Counter" -part "XC7A35T-1CPG236C"

opt_design
place_design
route_design

write_bitstream -force "Parking_Lot_Counter.bit"
