# scripts/create_project.tcl

# Set project variables
set project_name "rv32i"
set project_dir "./build"
set src_dir "./src"
set sim_dir "./sim"
set constraints_dir "./constraints"

# Create the project
create_project $project_name $project_dir -part xc7a35tcpg236-1

set_property target_language VHDL [current_project]

# Add VHDL sources
set vhdl_files [glob -nocomplain -directory $src_dir *.vhd]
foreach file $vhdl_files {
    add_files -fileset sources_1 $file
}

# Add simulation sources
set sim_files [glob -nocomplain -directory $sim_dir *.vhd]
foreach file $sim_files {
    add_files -fileset sim_1 $file
}

# Add constraints
set xdc_files [glob -nocomplain -directory $constraints_dir *.xdc]
foreach file $xdc_files {
    add_files -fileset constrs_1 $file
}

close_project
