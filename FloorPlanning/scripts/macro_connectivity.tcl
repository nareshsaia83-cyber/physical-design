###########################################################################
# Macro Connectivity Report
# Cadence Innovus 20.11
#
# Reports:
#   1. Macro <-> Macro Connectivity
#   2. Macro <-> IO Port Connectivity
#
###########################################################################

set rpt [open macro_connectivity_summary.rpt w]

puts "Collecting Macros..."

#----------------------------------------------------------
# Collect all hard macros
#----------------------------------------------------------

set macro_db {}
set macro_names {}

foreach inst [get_db insts] {

    if {[get_db $inst .base_cell.base_class] == "block"} {

        lappend macro_db $inst
        lappend macro_names [get_db $inst .name]
    }
}

puts "Total Macros : [llength $macro_db]"

###########################################################################
# Process every macro
###########################################################################

foreach macro $macro_db {

    array unset macro_conn
    array unset port_conn

    set macro_name [get_db $macro .name]

    puts $rpt ""
    puts $rpt "============================================================="
    puts $rpt "Macro : $macro_name"
    puts $rpt "============================================================="

    ############################################################
    # Iterate over every pin of the macro
    ############################################################

    foreach pin [get_db $macro .pins] {

        set net [get_db $pin .net]

        if {$net == ""} {
            continue
        }

        ########################################################
        # Prevent duplicate counting on same net
        ########################################################

        array unset visited

        ########################################################
        # Driver Pins
        ########################################################

        foreach dpin [get_db $net .driver_pins] {

            set inst [get_db $dpin .inst]

            if {$inst == ""} {
                continue
            }

            set inst_name [get_db $inst .name]

            if {$inst_name == $macro_name} {
                continue
            }

            if {[info exists visited($inst_name)]} {
                continue
            }

            set visited($inst_name) 1

            if {[lsearch -exact $macro_names $inst_name] != -1} {

                if {[info exists macro_conn($inst_name)]} {
                    incr macro_conn($inst_name)
                } else {
                    set macro_conn($inst_name) 1
                }
            }
        }

        ########################################################
        # Load Pins
        ########################################################

        foreach lpin [get_db $net .load_pins] {

            set inst [get_db $lpin .inst]

            if {$inst == ""} {
                continue
            }

            set inst_name [get_db $inst .name]

            if {$inst_name == $macro_name} {
                continue
            }

            if {[info exists visited($inst_name)]} {
                continue
            }

            set visited($inst_name) 1

            if {[lsearch -exact $macro_names $inst_name] != -1} {

                if {[info exists macro_conn($inst_name)]} {
                    incr macro_conn($inst_name)
                } else {
                    set macro_conn($inst_name) 1
                }
            }
        }

        ########################################################
        # IO Ports
        ########################################################

        foreach port [get_db $net .load_ports] {

            set pname [get_db $port .name]

            if {[info exists port_conn($pname)]} {
                incr port_conn($pname)
            } else {
                set port_conn($pname) 1
            }
        }

    }

    ############################################################
    # Print Macro Connectivity
    ############################################################

    puts $rpt ""
    puts $rpt "Connected Macros"
    puts $rpt "----------------"

    set macro_list {}

    foreach m [array names macro_conn] {

        lappend macro_list [list $m $macro_conn($m)]

    }

    foreach item [lsort -decreasing -integer -index 1 $macro_list] {

        puts $rpt [format "%-55s %6d" \
            [lindex $item 0] \
            [lindex $item 1]]
    }

    ############################################################
    # Print IO Ports
    ############################################################

    puts $rpt ""

    puts $rpt "Connected IO Ports"
    puts $rpt "------------------"

    set port_list {}

    foreach p [array names port_conn] {

        lappend port_list [list $p $port_conn($p)]

    }

    foreach item [lsort -decreasing -integer -index 1 $port_list] {

        puts $rpt [format "%-55s %6d" \
            [lindex $item 0] \
            [lindex $item 1]]
    }

}

close $rpt

puts ""
puts "==============================================="
puts "Report Generated Successfully"
puts "macro_connectivity_summary.rpt"
puts "==============================================="