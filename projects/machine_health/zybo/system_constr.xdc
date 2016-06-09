# TMP4

set_property -dict  {PACKAGE_PIN H15 IOSTANDARD LVCMOS33}    [get_ports  iic_scl]  ; ## JE3
set_property -dict  {PACKAGE_PIN V13 IOSTANDARD LVCMOS33}    [get_ports  iic_sda]  ; ## JE4

# AD7980_0

set_property -dict  {PACKAGE_PIN T20 IOSTANDARD LVCMOS33}    [get_ports  spi_0_cnv]  ; ## JB1
set_property -dict  {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33}    [get_ports  spi_0_miso] ; ## JB3
set_property -dict  {PACKAGE_PIN W18 IOSTANDARD LVCMOS33}    [get_ports  spi_0_sclk] ; ## JB4

# AD7980_1

set_property -dict  {PACKAGE_PIN V15 IOSTANDARD LVCMOS33}    [get_ports  spi_1_cnv]  ; ## JC1
set_property -dict  {PACKAGE_PIN W14 IOSTANDARD LVCMOS33}    [get_ports  spi_1_miso] ; ## JC3
set_property -dict  {PACKAGE_PIN T12 IOSTANDARD LVCMOS33}    [get_ports  spi_1_sclk] ; ## JC4

# AD7980_2

set_property -dict  {PACKAGE_PIN T14 IOSTANDARD LVCMOS33}    [get_ports  spi_2_cnv]  ; ## JD1
set_property -dict  {PACKAGE_PIN U14 IOSTANDARD LVCMOS33}    [get_ports  spi_2_miso] ; ## JD3
set_property -dict  {PACKAGE_PIN V17 IOSTANDARD LVCMOS33}    [get_ports  spi_2_sclk] ; ## JD4

