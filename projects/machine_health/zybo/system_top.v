// ***************************************************************************
// ***************************************************************************
// Copyright 2016(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  ddr_addr,
  ddr_ba,
  ddr_cas_n,
  ddr_ck_n,
  ddr_ck_p,
  ddr_cke,
  ddr_cs_n,
  ddr_dm,
  ddr_dq,
  ddr_dqs_n,
  ddr_dqs_p,
  ddr_odt,
  ddr_ras_n,
  ddr_reset_n,
  ddr_we_n,

  fixed_io_ddr_vrn,
  fixed_io_ddr_vrp,
  fixed_io_mio,
  fixed_io_ps_clk,
  fixed_io_ps_porb,
  fixed_io_ps_srstb,

  gpio_bd,

  iic_scl,
  iic_sda,

  spi_0_cnv,
  spi_0_miso,
  spi_0_sclk,
  spi_0_self_test,
  spi_0_standby,
  spi_0_over_range,

  spi_1_cnv,
  spi_1_miso,
  spi_1_sclk,
  spi_1_self_test,
  spi_1_standby,
  spi_1_over_range,

  spi_2_cnv,
  spi_2_miso,
  spi_2_sclk,
  spi_2_self_test,
  spi_2_standby,
  spi_2_over_range,

  otg_vbusoc);

  inout   [14:0]  ddr_addr;
  inout   [ 2:0]  ddr_ba;
  inout           ddr_cas_n;
  inout           ddr_ck_n;
  inout           ddr_ck_p;
  inout           ddr_cke;
  inout           ddr_cs_n;
  inout   [ 3:0]  ddr_dm;
  inout   [31:0]  ddr_dq;
  inout   [ 3:0]  ddr_dqs_n;
  inout   [ 3:0]  ddr_dqs_p;
  inout           ddr_odt;
  inout           ddr_ras_n;
  inout           ddr_reset_n;
  inout           ddr_we_n;

  inout           fixed_io_ddr_vrn;
  inout           fixed_io_ddr_vrp;
  inout   [53:0]  fixed_io_mio;
  inout           fixed_io_ps_clk;
  inout           fixed_io_ps_porb;
  inout           fixed_io_ps_srstb;

  inout   [31:0]  gpio_bd;

  inout           iic_scl;
  inout           iic_sda;

  output          spi_0_cnv;
  input           spi_0_miso;
  output          spi_0_sclk;
  output          spi_0_self_test;
  output          spi_0_standby;
  input           spi_0_over_range;

  output          spi_1_cnv;
  input           spi_1_miso;
  output          spi_1_sclk;
  output          spi_1_self_test;
  output          spi_1_standby;
  input           spi_1_over_range;

  output          spi_2_cnv;
  input           spi_2_miso;
  output          spi_2_sclk;
  output          spi_2_self_test;
  output          spi_2_standby;
  input           spi_2_over_range;

  input           otg_vbusoc;

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  // instantiations

  assign gpio_i[32] = gpio_o[32];
  assign gpio_i[33] = gpio_o[33];
  assign gpio_i[34] = spi_0_over_range;
  assign gpio_i[35] = gpio_o[35];
  assign gpio_i[36] = gpio_o[36];
  assign gpio_i[37] = spi_1_over_range;
  assign gpio_i[38] = gpio_o[38];
  assign gpio_i[39] = gpio_o[39];
  assign gpio_i[40] = spi_2_over_range;

  assign spi_0_self_test = gpio_o[32];
  assign spi_0_standby = gpio_o[33];
  assign spi_1_self_test = gpio_o[35];
  assign spi_1_standby = gpio_o[36];
  assign spi_2_self_test = gpio_o[38];
  assign spi_2_standby = gpio_o[39];

  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .iic_tmp4_scl_io (iic_scl),
    .iic_tmp4_sda_io (iic_sda),
    .ps_intr_00 (1'b0),
    .ps_intr_01 (1'b0),
    .ps_intr_02 (1'b0),
    .ps_intr_03 (1'b0),
    .ps_intr_04 (1'b0),
    .ps_intr_05 (1'b0),
    .ps_intr_13 (1'b0),
    .ps_intr_14 (1'b0),
    .ps_intr_15 (1'b0),
    .otg_vbusoc (otg_vbusoc),
    .spi_adc_0_cs (),
    .spi_adc_0_sclk (spi_0_sclk),
    .spi_adc_0_sdi (spi_0_miso),
    .spi_adc_0_sdo (),
    .spi_adc_0_sdo_t (),
    .spi_cnv_0 (spi_0_cnv),
    .spi_adc_1_cs (),
    .spi_adc_1_sclk (spi_1_sclk),
    .spi_adc_1_sdi (spi_1_miso),
    .spi_adc_1_sdo (),
    .spi_adc_1_sdo_t (),
    .spi_cnv_1 (spi_1_cnv),
    .spi_adc_2_cs (),
    .spi_adc_2_sclk (spi_2_sclk),
    .spi_adc_2_sdi (spi_2_miso),
    .spi_adc_2_sdo (),
    .spi_adc_2_sdo_t (),
    .spi_cnv_2 (spi_2_cnv));


endmodule

// ***************************************************************************
// ***************************************************************************
