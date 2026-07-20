#------------------------------------------
# Ring DB Settings
#------------------------------------------

set_db add_rings_target default
set_db add_rings_extend_over_row 0
set_db add_rings_ignore_rows 0
set_db add_rings_avoid_short 0
set_db add_rings_skip_shared_inner_ring none

set_db add_rings_stacked_via_top_layer M9
set_db add_rings_stacked_via_bottom_layer M1

set_db add_rings_via_using_exact_crossover_size 1
set_db add_rings_orthogonal_only true
set_db add_rings_skip_via_on_pin {standardcell}
set_db add_rings_skip_via_on_wire_shape {noshape}

add_rings \
    -nets {VDD VSS} \
    -type core_rings \
    -follow core \
    -layer {top M9 bottom M9 left M8 right M8} \
    -width {top 5 bottom 5 left 5 right 5} \
    -spacing {top 2 bottom 2 left 2 right 2} \
    -offset {top 5 bottom 5 left 5 right 5} \
    -center 0 \
    -threshold 0 \
    -snap_wire_center_to_grid none

# stripes setting

set_db add_stripes_ignore_block_check false
set_db add_stripes_break_at {block_ring}

set_db add_stripes_route_over_rows_only false
set_db add_stripes_rows_without_stripes_only false

set_db add_stripes_extend_to_closest_target none

set_db add_stripes_stop_at_last_wire_for_area false
set_db add_stripes_partial_set_through_domain false
set_db add_stripes_ignore_non_default_domains false

set_db add_stripes_trim_antenna_back_to_shape none

set_db add_stripes_spacing_type edge_to_edge
set_db add_stripes_spacing_from_block 0

set_db add_stripes_stripe_min_length stripe_width

set_db add_stripes_stacked_via_top_layer M9
set_db add_stripes_stacked_via_bottom_layer M1

set_db add_stripes_via_using_exact_crossover_size false
set_db add_stripes_split_vias false
set_db add_stripes_orthogonal_only true

set_db add_stripes_allow_jog {padcore_ring}

set_db add_stripes_skip_via_on_pin {standardcell}
set_db add_stripes_skip_via_on_wire_shape {noshape}

# Horizontal stripe M9 settings

add_stripes \
    -nets {VDD VSS} \
    -layer M9 \
    -direction horizontal \
    -width 6 \
    -spacing 12 \
    -set_to_set_distance 100 \
    -start_from bottom \
    -start_offset 80 \
    -stop_offset 80 \
    -switch_layer_over_obs false \
    -max_same_layer_jog_length 2 \
    -pad_core_ring_top_layer_limit M9 \
    -pad_core_ring_bottom_layer_limit M1 \
    -block_ring_top_layer_limit M9 \
    -block_ring_bottom_layer_limit M1 \
    -use_wire_group 0 \
    -snap_wire_center_to_grid none
	
# Verical stripe M8 settings 

add_stripes \
    -nets {VDD VSS} \
    -layer M8 \
    -direction vertical \
    -width 6 \
    -spacing 12 \
    -set_to_set_distance 100 \
    -start_from bottom \
    -start_offset 80 \
    -stop_offset 80 \
    -switch_layer_over_obs false \
    -max_same_layer_jog_length 2 \
    -pad_core_ring_top_layer_limit M9 \
    -pad_core_ring_bottom_layer_limit M1 \
    -block_ring_top_layer_limit M9 \
    -block_ring_bottom_layer_limit M1 \
    -use_wire_group 0 \
    -snap_wire_center_to_grid none

# route special 

set_db route_special_via_connect_to_shape {noshape}

route_special \
    -connect {block_pin pad_pin core_pin} \
    -layer_change_range {M1 M9} \
    -block_pin_target {nearest_target} \
    -allow_jogging 1 \
    -crossover_via_layer_range {M1 M9} \
    -nets {VDD VSS} \
    -allow_layer_change 1 \
    -block_pin_use_lef \
    -target_via_layer_range {M1 M9}