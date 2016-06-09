
# ip

source ../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create util_pulse_gen
adi_ip_files util_pulse_gen [list \
  "$ad_hdl_dir/library/common/util_pulse_gen.v"]

adi_ip_properties_lite util_pulse_gen


ipx::save_core [ipx::current_core]

