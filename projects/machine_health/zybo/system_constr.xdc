# TMP4

set_property -dict  {PACKAGE_PIN J15 IOSTANDARD LVCMOS33}    [get_ports  iic_scl]  ; ## JE3
set_property -dict  {PACKAGE_PIN H15 IOSTANDARD LVCMOS33}    [get_ports  iic_sda]  ; ## JE4

# AD7980_0

set_property -dict  {PACKAGE_PIN T20 IOSTANDARD LVCMOS33}    [get_ports  spi_0_cnv]  ; ## JB1_P
set_property -dict  {PACKAGE_PIN V20 IOSTANDARD LVCMOS33}    [get_ports  spi_0_miso] ; ## JB2_P
set_property -dict  {PACKAGE_PIN W20 IOSTANDARD LVCMOS33}    [get_ports  spi_0_sclk] ; ## JB2_N

# AD7980_1

set_property -dict  {PACKAGE_PIN V15 IOSTANDARD LVCMOS33}    [get_ports  spi_1_cnv]  ; ## JC1_P
set_property -dict  {PACKAGE_PIN T11 IOSTANDARD LVCMOS33}    [get_ports  spi_1_miso] ; ## JC2_P
set_property -dict  {PACKAGE_PIN T10 IOSTANDARD LVCMOS33}    [get_ports  spi_1_sclk] ; ## JC2_N

# AD7980_2

set_property -dict  {PACKAGE_PIN T14 IOSTANDARD LVCMOS33}    [get_ports  spi_2_cnv]  ; ## JD1_P
set_property -dict  {PACKAGE_PIN P14 IOSTANDARD LVCMOS33}    [get_ports  spi_2_miso] ; ## JD2_P
set_property -dict  {PACKAGE_PIN R14 IOSTANDARD LVCMOS33}    [get_ports  spi_2_sclk] ; ## JD2_N

