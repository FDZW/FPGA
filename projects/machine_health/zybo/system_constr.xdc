# TMP4

set_property -dict  {PACKAGE_PIN U14 IOSTANDARD LVCMOS33}    [get_ports  iic_scl]  ; ## JE3
set_property -dict  {PACKAGE_PIN V17 IOSTANDARD LVCMOS33}    [get_ports  iic_sda]  ; ## JE4

# AD7980

set_property -dict  {PACKAGE_PIN T20 IOSTANDARD LVCMOS33}    [get_ports  spi_cnv]  ; ## JB1
set_property -dict  {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33}    [get_ports  spi_miso] ; ## JB3
set_property -dict  {PACKAGE_PIN W18 IOSTANDARD LVCMOS33}    [get_ports  spi_sclk] ; ## JB4

