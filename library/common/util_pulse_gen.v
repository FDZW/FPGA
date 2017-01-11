// ***************************************************************************
// ***************************************************************************
// Copyright 2015(c) Analog Devices, Inc.
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
`timescale 1ns/1ps

module util_pulse_gen #(

  parameter   PULSE_WIDTH = 7,
  parameter   PULSE_PERIOD = 100000000)(         // t_period * clk_freq

  input               clk,
  input               rstn,

  input       [31:0]  pulse_period,
  input               pulse_period_en,

  output  reg         pulse
);

  // internal registers

  reg     [(PULSE_WIDTH-1):0]  pulse_width_cnt = {PULSE_WIDTH{1'b1}};
  reg     [31:0]               pulse_period_cnt = 32'h0;
  reg     [31:0]               pulse_period_d = 32'b0;

  wire                         end_of_period_s;

  // flop the desired period

  always @(posedge clk) begin
    pulse_period_d <= (pulse_period_en) ? pulse_period : PULSE_PERIOD;
  end

  // a free running pulse generator

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      pulse_period_cnt <= 32'h0;
    end else begin
      pulse_period_cnt <= (pulse_period_cnt < pulse_period_d) ? (pulse_period_cnt + 1) : 32'b0;
    end
  end

  assign  end_of_period_s = (pulse_period_cnt == (pulse_period_d - 1)) ? 1'b1 : 1'b0;

  // generate pulse with a specified width

  always @(posedge clk) begin
    if (rstn == 1'b0) begin
      pulse_width_cnt <= 0;
      pulse <= 0;
    end else begin
      pulse_width_cnt <= (pulse == 1'b1) ? pulse_width_cnt + 1 : {PULSE_WIDTH{1'h0}};
      if(end_of_period_s == 1'b1) begin
        pulse <= 1'b1;
      end else if(pulse_width_cnt == {PULSE_WIDTH{1'b1}}) begin
        pulse <= 1'b0;
      end
    end
  end

endmodule
