# gpio

set_property  -dict   {PACKAGE_PIN  R18 IOSTANDARD LVCMOS33}  [get_ports gpio_bd[0]]   ;   ##  btns_4bits_tri_i[0]
set_property  -dict   {PACKAGE_PIN  P16 IOSTANDARD LVCMOS33}  [get_ports gpio_bd[1]]   ;   ##  btns_4bits_tri_i[1]
set_property  -dict   {PACKAGE_PIN  V16 IOSTANDARD LVCMOS33}  [get_ports gpio_bd[2]]   ;   ##  btns_4bits_tri_i[2]
set_property  -dict   {PACKAGE_PIN  Y16 IOSTANDARD LVCMOS33}  [get_ports gpio_bd[3]]   ;   ##  btns_4bits_tri_i[4]

set_property -dict    {PACKAGE_PIN M14  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[4]]   ;   ## leds_4bits_tri_o[0]
set_property -dict    {PACKAGE_PIN M15  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[5]]   ;   ## leds_4bits_tri_o[1]
set_property -dict    {PACKAGE_PIN G14  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[6]]   ;   ## leds_4bits_tri_o[2]
set_property -dict    {PACKAGE_PIN D18  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[7]]   ;   ## leds_4bits_tri_o[3]

set_property -dict    {PACKAGE_PIN G15  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[8]]   ;   ## sws_4bits_tri_i[0]
set_property -dict    {PACKAGE_PIN P15  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[9]]   ;   ## sws_4bits_tri_i[1]
set_property -dict    {PACKAGE_PIN W13  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[10]]  ;   ## sws_4bits_tri_i[2]
set_property -dict    {PACKAGE_PIN T16  IOSTANDARD LVCMOS33}  [get_ports gpio_bd[11]]  ;   ## sws_4bits_tri_i[3]

# otg

set_property -dict    {PACKAGE_PIN U13  IOSTANDARD LVCMOS33}  [get_ports otg_vbusoc]

