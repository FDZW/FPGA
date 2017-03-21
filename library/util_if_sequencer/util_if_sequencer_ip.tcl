# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_if_sequencer
adi_ip_files util_if_sequencer [list \
  "$ad_hdl_dir/library/common/util_if_sequencer.v" \
  "util_if_sequencer_constr.xdc" ]

adi_ip_properties_lite util_if_sequencer
adi_ip_constraints util_if_sequencer [list \
  "util_if_sequencer_constr.xdc" ]

adi_add_bus "fifo_in_0" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"fifo_in_valid_0" "TVALID"} \
		{"fifo_in_ready_0" "TREADY"} \
		{"fifo_in_data_0" "TDATA"} \
	}

adi_add_bus_clock "clk" "fifo_in_0"

adi_add_bus "fifo_in_1" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"fifo_in_valid_1" "TVALID"} \
		{"fifo_in_ready_1" "TREADY"} \
		{"fifo_in_data_1" "TDATA"} \
	}

adi_add_bus_clock "clk" "fifo_in_1"

adi_add_bus "fifo_in_2" "slave" \
	"xilinx.com:interface:axis_rtl:1.0" \
	"xilinx.com:interface:axis:1.0" \
	{
		{"fifo_in_valid_2" "TVALID"} \
		{"fifo_in_ready_2" "TREADY"} \
		{"fifo_in_data_2" "TDATA"} \
	}

adi_add_bus_clock "clk" "fifo_in_2"

adi_add_bus "fifo_wr" "master" \
	"analog.com:interface:fifo_wr_rtl:1.0" \
	"analog.com:interface:fifo_wr:1.0" \
	{
		{"fifo_out_valid" "EN"} \
		{"fifo_out_sync" "SYNC"} \
		{"fifo_out_data" "DATA"} \
		{"fifo_out_overflow" "OVERFLOW"} \
		{"fifo_out_xfer_req" "XFER_REQ"} \
	}

adi_add_bus_clock "clk" "fifo_wr"

ipx::save_core [ipx::current_core]
