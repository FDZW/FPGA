# IIC for TMP4_PMOD

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_tmp4

# I2C for TMP4

set axi_iic_tmp4 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_tmp4]

# AD7980 SPI interface

create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi_adc_0
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi_adc_1
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 spi_adc_2

create_bd_port -dir O spi_cnv_0
create_bd_port -dir O spi_cnv_1
create_bd_port -dir O spi_cnv_2

# Create SPI engine controller with offload

for {set i 0} {$i < 3} {incr i} {

  # instantiate the spi engine

  create_bd_cell -type hier spi_$i
  current_bd_instance /spi_$i

    set axi "axi_$i"
    set execution "execution_$i"
    set offload "offload_$i"
    set interconnect "interconnect_$i"
    set axis_dwidth_converter "axis_dwidth_converter_$i"

    create_bd_pin -dir I -type clk clk
    create_bd_pin -dir I -type rst resetn
    create_bd_pin -dir O conv_start
    create_bd_pin -dir O irq
    create_bd_intf_pin -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 m_spi
    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_SAMPLE

    set spi_engine [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_execution:1.0 $execution]
    set_property -dict [list CONFIG.NUM_OF_CS {1}] $spi_engine

    set axi_spi_engine [create_bd_cell -type ip -vlnv analog.com:user:axi_spi_engine:1.0 $axi]
    set spi_engine_offload [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_offload:1.0 $offload]
    set spi_engine_interconnect [create_bd_cell -type ip -vlnv analog.com:user:spi_engine_interconnect:1.0 $interconnect]

    set util_cnvst_gen [create_bd_cell -type ip -vlnv analog.com:user:util_pulse_gen:1.0 util_cnvst_gen]
    set_property -dict [list CONFIG.PULSE_PERIOD  {1000}] $util_cnvst_gen
    set_property -dict [list CONFIG.PULSE_WIDTH  {7}] $util_cnvst_gen

    set axis_width_conv [create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 $axis_dwidth_converter]

    ad_connect $axi/spi_engine_offload_ctrl0 $offload/spi_engine_offload_ctrl
    ad_connect $offload/spi_engine_ctrl $interconnect/s0_ctrl
    ad_connect $axi/spi_engine_ctrl $interconnect/s1_ctrl
    ad_connect $interconnect/m_ctrl $execution/ctrl
    ad_connect $offload/offload_sdi $axis_dwidth_converter/S_AXIS
    ad_connect $axis_dwidth_converter/M_AXIS M_AXIS_SAMPLE

    ad_connect util_cnvst_gen/end_of_pulse $offload/trigger

    ad_connect $execution/spi m_spi

    ad_connect clk $offload/spi_clk
    ad_connect clk $offload/ctrl_clk
    ad_connect clk $execution/clk
    ad_connect clk $axi/s_axi_aclk
    ad_connect clk $axi/spi_clk
    ad_connect clk $interconnect/clk
    ad_connect clk $axis_dwidth_converter/aclk
    ad_connect clk util_cnvst_gen/clk

    ad_connect resetn $axi/s_axi_aresetn
    ad_connect $axi/spi_resetn $offload/spi_resetn
    ad_connect $axi/spi_resetn $axis_dwidth_converter/aresetn
    ad_connect $axi/spi_resetn $execution/resetn
    ad_connect $axi/spi_resetn $interconnect/resetn
    ad_connect $axi/spi_resetn util_cnvst_gen/rstn

    ad_connect conv_start util_cnvst_gen/pulse

    ad_connect irq $axi/irq

  current_bd_instance /

  # instantiate the dma

  set axi_dma  [create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_dma_$i]
  set_property -dict [list CONFIG.FIFO_SIZE {1}] $axi_dma
  set_property -dict [list CONFIG.DMA_TYPE_SRC {1}]  $axi_dma
  set_property -dict [list CONFIG.DMA_TYPE_DEST {0}] $axi_dma
  set_property -dict [list CONFIG.CYCLIC {0}]  $axi_dma
  set_property -dict [list CONFIG.SYNC_TRANSFER_START {1}] $axi_dma
  set_property -dict [list CONFIG.AXI_SLICE_SRC {0}] $axi_dma
  set_property -dict [list CONFIG.AXI_SLICE_DEST {0}]  $axi_dma
  set_property -dict [list CONFIG.DMA_2D_TRANSFER {0}] $axi_dma
  set_property -dict [list CONFIG.DMA_DATA_WIDTH_SRC {16}] $axi_dma
  set_property -dict [list CONFIG.DMA_DATA_WIDTH_DEST {64}]  $axi_dma
  set_property -dict [list CONFIG.DMA_AXI_PROTOCOL_DEST {1}] $axi_dma

}

# clock and resets

ad_connect  sys_cpu_clk spi_0/clk
ad_connect  sys_cpu_clk spi_1/clk
ad_connect  sys_cpu_clk spi_2/clk
ad_connect  sys_cpu_clk axi_dma_0/s_axis_aclk
ad_connect  sys_cpu_clk axi_dma_1/s_axis_aclk
ad_connect  sys_cpu_clk axi_dma_2/s_axis_aclk
ad_connect  sys_cpu_resetn spi_0/resetn
ad_connect  sys_cpu_resetn spi_1/resetn
ad_connect  sys_cpu_resetn spi_2/resetn

ad_connect  spi_adc_0 spi_0/m_spi
ad_connect  spi_adc_1 spi_1/m_spi
ad_connect  spi_adc_2 spi_2/m_spi
ad_connect  spi_cnv_0 spi_0/conv_start
ad_connect  spi_cnv_1 spi_1/conv_start
ad_connect  spi_cnv_2 spi_2/conv_start

# interface connections

ad_connect  iic_tmp4 axi_iic_tmp4/iic
ad_connect  axi_dma_0/s_axis spi_0/M_AXIS_SAMPLE
ad_connect  axi_dma_1/s_axis spi_1/M_AXIS_SAMPLE
ad_connect  axi_dma_2/s_axis spi_2/M_AXIS_SAMPLE

# address assignments

ad_cpu_interconnect 0x43C00000 axi_iic_tmp4
ad_cpu_interconnect 0x43C10000 axi_dma_0
ad_cpu_interconnect 0x43C20000 axi_dma_1
ad_cpu_interconnect 0x43C30000 axi_dma_2
ad_cpu_interconnect 0x43C40000 spi_0/axi_0
ad_cpu_interconnect 0x43C50000 spi_1/axi_1
ad_cpu_interconnect 0x43C60000 spi_2/axi_2

ad_mem_hp0_interconnect sys_cpu_clk sys_ps7/S_AXI_HP0
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_0/m_dest_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_1/m_dest_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_dma_2/m_dest_axi

ad_connect sys_cpu_resetn axi_dma_0/m_dest_axi_aresetn
ad_connect sys_cpu_resetn axi_dma_1/m_dest_axi_aresetn
ad_connect sys_cpu_resetn axi_dma_2/m_dest_axi_aresetn

# interrupts

ad_cpu_interrupt ps-12 mb-13 axi_iic_tmp4/iic2intc_irpt
ad_cpu_interrupt ps-11 mb-14 spi_0/irq
ad_cpu_interrupt ps-10 mb-15 spi_1/irq
ad_cpu_interrupt ps-9 mb-16 spi_2/irq
ad_cpu_interrupt ps-8 mb-17 axi_dma_0/irq
ad_cpu_interrupt ps-7 mb-18 axi_dma_1/irq
ad_cpu_interrupt ps-6 mb-19 axi_dma_2/irq

