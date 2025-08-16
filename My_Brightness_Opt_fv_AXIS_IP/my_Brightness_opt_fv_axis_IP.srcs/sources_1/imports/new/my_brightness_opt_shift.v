`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2025 22:00:51
// Design Name: 
// Module Name: my_brightness_opt_shift
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module my_brightness_opt_shift #(parameter integer brightness_multiplier = 1)
    (  
		// video inputs
		input pxl_clk,
		input nreset,
		input [23:0] vid_pData_in,
		input [7:0] brightness_pct,
		input ip_enabled,
        // video outputs
        output reg [23:0] vid_pData_out
    );
    wire [7:0] temp_r;
    wire [7:0] temp_g;
    wire [7:0] temp_b;
    
    assign temp_r = vid_pData_in[7:0];
    assign temp_g = vid_pData_in[15:8];
    assign temp_b = vid_pData_in[23:16];
    
    wire [15:0] temp_rc;
    wire [15:0] temp_gc;
    wire [15:0] temp_bc;
    
    assign temp_rc = vid_pData_in[7:0]*brightness_pct;
    assign temp_gc = vid_pData_in[15:8]*brightness_pct;
    assign temp_bc = vid_pData_in[23:16]*brightness_pct;
    
    always@(posedge pxl_clk) begin
        if(nreset == 0) begin
            vid_pData_out <= {temp_b,temp_g,temp_r};
        end
        else begin
            if(ip_enabled == 1) begin
                if(brightness_pct < 8'd64) begin
                    vid_pData_out[7:0] <= temp_rc[13:6]; // optimization for devide by 64
                    vid_pData_out[15:8] <= temp_gc[13:6];
                    vid_pData_out[23:16] <= temp_bc[13:6];
                end
                else if(brightness_pct <= 8'd128) begin
                    vid_pData_out[7:0] <= temp_r+(((255-temp_r)*(brightness_pct-64))>>6);
                    vid_pData_out[15:8] <= temp_g+(((255-temp_g)*(brightness_pct-64))>>6);
                    vid_pData_out[23:16] <= temp_b+(((255-temp_b)*(brightness_pct-64))>>6);
                end                
                else begin
                    vid_pData_out <= {temp_b,temp_g,temp_r};
                end
            end
            else begin
                vid_pData_out <= {temp_b,temp_g,temp_r};
            end                        
        end
    end
endmodule


