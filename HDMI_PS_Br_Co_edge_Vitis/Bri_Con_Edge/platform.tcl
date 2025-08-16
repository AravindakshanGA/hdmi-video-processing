# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct F:\Analog_Digital_Hackathons_2025\PS_Solutions\HDMI_PS_Br_Co_edge_Vitis\Bri_Con_Edge\platform.tcl
# 
# OR launch xsct and run below command.
# source F:\Analog_Digital_Hackathons_2025\PS_Solutions\HDMI_PS_Br_Co_edge_Vitis\Bri_Con_Edge\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {Bri_Con_Edge}\
-hw {F:\Analog_Digital_Hackathons_2025\PS_Solutions\HDMI_PS_Br_Co_edge\design_1_wrapper.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -out {F:/Analog_Digital_Hackathons_2025/PS_Solutions/HDMI_PS_Br_Co_edge_Vitis}

platform write
platform generate -domains 
platform active {Bri_Con_Edge}
platform generate
