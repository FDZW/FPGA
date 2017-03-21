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

// Main functionality : Merge 3 independent FIFO write interface into one single
//                      FIFO write interface
// Goal : This module assist to connect multiple ADC devices to one single DMA
// Note : The channel_enable control input port and the overflow output port
//        should be connected to a generic AXI ADC core IP (~/library/axi_generic_adc)

`timescale 1ns/100ps

module util_if_sequencer (

  input                     clk,

  input         [15:0]      fifo_in_data_0,
  input                     fifo_in_valid_0,
  output  reg               fifo_in_ready_0,

  input         [15:0]      fifo_in_data_1,
  input                     fifo_in_valid_1,
  output  reg               fifo_in_ready_1,

  input         [15:0]      fifo_in_data_2,
  input                     fifo_in_valid_2,
  output  reg               fifo_in_ready_2,

  output  reg   [15:0]      fifo_out_data,
  input                     fifo_out_ready,
  output  reg               fifo_out_valid,
  output  reg               fifo_out_sync,
  input                     fifo_out_xfer_req,
  input                     fifo_out_overflow,

  output  reg               sequencer_reset,
  output  reg               overflow,
  input         [2:0]       channel_enable

);

  reg [1:0] counter = 2'h0;

  always @(posedge clk) begin
    sequencer_reset <= fifo_out_xfer_req;
    overflow <= fifo_out_overflow;
  end

  // selection counter, the first channel has the highest priority (*_0)

  always @(posedge clk) begin
    if(sequencer_reset == 1'b0) begin
      counter <= 1'h0;
    end else begin
      case (counter)
        'h0: if ((fifo_in_valid_0 == 1'b1) && (fifo_out_ready == 1'b1)) counter <= counter + 1;
        'h1: if ((fifo_in_valid_1 == 1'b1) && (fifo_out_ready == 1'b1)) counter <= counter + 1;
        'h2: if ((fifo_in_valid_2 == 1'b1) && (fifo_out_ready == 1'b1)) counter <= 2'h0;
        default: counter <= 2'h0;
      endcase
    end
  end

  // data  multiplexing

  always @(posedge clk) begin
    case (counter)
      'h0: fifo_out_data <= fifo_in_data_0;
      'h1: fifo_out_data <= fifo_in_data_1;
      'h2: fifo_out_data <= fifo_in_data_2;
      default: fifo_out_data <= fifo_in_data_0;
    endcase
  end

  // valid generation

  always @(posedge clk) begin
    if (sequencer_reset == 1'b0 || channel_enable[counter] == 1'b0) begin
      fifo_out_valid <= 1'b0;
    end else begin
      case (counter)
        'h0: fifo_out_valid <= fifo_in_valid_0;
        'h1: fifo_out_valid <= fifo_in_valid_1;
        'h2: fifo_out_valid <= fifo_in_valid_2;
        default : fifo_out_valid <= 1'b0;
      endcase
    end
  end

  // sync generation, signal samples from the 'first' device

  always @(posedge clk) begin
    if (counter == 'h00) begin
      fifo_out_sync <= 1'b1;
    end else if (fifo_out_valid == 1'b1) begin
      fifo_out_sync = 1'b0;
    end
  end

  // ready generation for input interfaces

  always @(*) begin
    case (counter)
    'h0: fifo_in_ready_0 <= 1'b1;
    default: fifo_in_ready_0 <= 1'b0;
    endcase
  end

  always @(*) begin
    case (counter)
    'h1: fifo_in_ready_1 <= 1'b1;
    default: fifo_in_ready_1 <= 1'b0;
    endcase
  end

  always @(*) begin
    case (counter)
    'h2: fifo_in_ready_2 <= 1'b1;
    default: fifo_in_ready_2 <= 1'b0;
    endcase
  end

endmodule
