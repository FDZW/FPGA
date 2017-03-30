// ***************************************************************************
// ***************************************************************************
// Copyright 2011(c) Analog Devices, Inc.
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

`timescale 1ns/100ps

module axi_ad9963_tx #(

  // parameters

  parameter   DATAPATH_DISABLE = 0,
  parameter   ID = 0) (

  // dac interface

  input               dac_clk,
  output              dac_rst,
  output reg          dac_valid,
  output      [23:0]  dac_data,
  input       [23:0]  adc_data,

  // master/slave

  input               dac_sync_in,
  output              dac_sync_out,

  // dma interface

  output              dac_enable_i,
  output reg          dac_valid_i,
  input       [15:0]  dac_data_i,
  output              dac_enable_q,
  output reg          dac_valid_q,
  input       [15:0]  dac_data_q,
  input               dac_dovf,
  input               dac_dunf,

  // processor interface

  input               up_rstn,
  input               up_clk,
  input               up_wreq,
  input       [13:0]  up_waddr,
  input       [31:0]  up_wdata,
  output reg          up_wack,
  input               up_rreq,
  input       [13:0]  up_raddr,
  output reg  [31:0]  up_rdata,
  output reg          up_rack);

  // internal registers

  reg             dac_data_sync = 'd0;
  reg     [ 7:0]  dac_rate_cnt = 'd0;

  // internal signals

  wire            dac_data_sync_s;
  wire            dac_dds_format_s;
  wire    [ 7:0]  dac_datarate_s;
  wire    [23:0]  dac_data_int_s;
  wire    [31:0]  up_rdata_s[0:2];
  wire            up_rack_s[0:2];
  wire            up_wack_s[0:2];

  // master/slave

  assign dac_data_sync_s = (ID == 0) ? dac_sync_out : dac_sync_in;

  always @(posedge dac_clk) begin
    dac_data_sync <= dac_data_sync_s;
  end

  // rate counters and data sync signals

  always @(posedge dac_clk) begin
    if ((dac_data_sync == 1'b1) || (dac_rate_cnt == 8'd0)) begin
      dac_rate_cnt <= dac_datarate_s;
    end else begin
      dac_rate_cnt <= dac_rate_cnt - 1'b1;
    end
  end

  // dma interface

  always @(posedge dac_clk) begin
    dac_valid <= (dac_rate_cnt == 8'd0) ? 1'b1 : 1'b0;
    dac_valid_i <= dac_valid;
    dac_valid_q <= dac_valid;
  end

  // processor read interface

  always @(*) begin
    up_rdata <= up_rdata_s[0] | up_rdata_s[1] | up_rdata_s[2];
    up_rack <=  up_rack_s[0] | up_rack_s[1] | up_rack_s[2];
    up_wack <=  up_wack_s[0] | up_wack_s[1] | up_wack_s[2];
  end

  // dac channel

  axi_ad9963_tx_channel #(
    .CHANNEL_ID (0),
    .Q_OR_I_N (0),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_tx_channel_0 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid),
    .dma_data (dac_data_i),
    .adc_data (adc_data[11:0]),
    .dac_data (dac_data[11:0]),
    .dac_data_out (dac_data_int_s[11:0]),
    .dac_data_in (dac_data_int_s[23:12]),
    .dac_enable (dac_enable_i),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[0]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[0]),
    .up_rack (up_rack_s[0]));

  // dac channel

  axi_ad9963_tx_channel #(
    .CHANNEL_ID (1),
    .Q_OR_I_N (1),
    .DATAPATH_DISABLE (DATAPATH_DISABLE))
  i_tx_channel_1 (
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_valid (dac_valid),
    .dma_data (dac_data_q),
    .adc_data (adc_data[23:12]),
    .dac_data (dac_data[23:12]),
    .dac_data_out (dac_data_int_s[23:12]),
    .dac_data_in (dac_data_int_s[11:0]),
    .dac_enable (dac_enable_q),
    .dac_data_sync (dac_data_sync),
    .dac_dds_format (dac_dds_format_s),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[1]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[1]),
    .up_rack (up_rack_s[1]));

  // dac common processor interface

  up_dac_common #(
    .ID (ID),
    .DRP_DISABLE (1),
    .USERPORTS_DISABLE (1),
    .GPIO_DISABLE(1)
  ) i_up_dac_common (
    .mmcm_rst (),
    .dac_clk (dac_clk),
    .dac_rst (dac_rst),
    .dac_sync (dac_sync_out),
    .dac_frame (),
    .dac_clksel(),
    .dac_par_type (),
    .dac_par_enb (),
    .dac_r1_mode (),
    .dac_datafmt (dac_dds_format_s),
    .dac_datarate (dac_datarate_s),
    .dac_status (1'b1),
    .dac_status_ovf (dac_dovf),
    .dac_status_unf (dac_dunf),
    .dac_clk_ratio (32'd1),
    .up_drp_sel (),
    .up_drp_wr (),
    .up_drp_addr (),
    .up_drp_wdata (),
    .up_drp_rdata (16'd0),
    .up_drp_ready (1'd0),
    .up_drp_locked (1'd1),
    .up_usr_chanmax (),
    .dac_usr_chanmax (8'd2),
    .up_dac_gpio_in (32'h0),
    .up_dac_gpio_out (),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_s[2]),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_s[2]),
    .up_rack (up_rack_s[2]));

endmodule

// ***************************************************************************
// ***************************************************************************
