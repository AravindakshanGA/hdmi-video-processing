`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 21:45:13
// Design Name: 
// Module Name: my_brightness_axis_ip_Wrapper
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


module my_brightness_axis_ip_Wrapper #(parameter integer DATA_WIDTH = 32)
    (
        // programmable parameters
        input [7:0] brightness_pct,
        input brightness_ip_enabled,
        // axi clock and reset
        input axi_clk,
        input axi_reset_n,    
        //AXIS-Slave signals
        input s_axi_valid,
        input [23:0] s_axis_data,
        input s_axis_user,
        input s_axis_last,
        output s_axis_ready,
        
        //AXIS-Master signals
        input m_axis_read,
        output reg [23:0] m_axis_data,
        output reg m_axis_user,
        output reg m_axis_last,
        output reg m_axis_valid

    );
    
    
    wire [7:0] temp_r;
    wire [7:0] temp_g;
    wire [7:0] temp_b;
    
    assign temp_r = s_axis_data[7:0];
    assign temp_g = s_axis_data[15:8];
    assign temp_b = s_axis_data[23:16];
    
    wire [15:0] temp_rc;
    wire [15:0] temp_gc;
    wire [15:0] temp_bc;
    
    assign temp_rc = s_axis_data[7:0]*brightness_pct;
    assign temp_gc = s_axis_data[15:8]*brightness_pct;
    assign temp_bc = s_axis_data[23:16]*brightness_pct;
    
    assign s_axis_ready = m_axis_read;
    always@(posedge axi_clk)begin
        if(axi_reset_n == 1'b0) begin
            m_axis_data <= s_axis_data;
        end
        else begin
            if(s_axi_valid & s_axis_ready) begin
                if(brightness_ip_enabled == 1) begin
                    if(brightness_pct < 8'd64) begin
                        m_axis_data[7:0] <= temp_rc[13:6]; // optimization for devide by 64
                        m_axis_data[15:8] <= temp_gc[13:6];
                        m_axis_data[23:16] <= temp_bc[13:6];
                    end
                    else if(brightness_pct <= 8'd128) begin
                        m_axis_data[7:0] <= temp_r+(((255-temp_r)*(brightness_pct-64))>>6);
                        m_axis_data[15:8] <= temp_g+(((255-temp_g)*(brightness_pct-64))>>6);
                        m_axis_data[23:16] <= temp_b+(((255-temp_b)*(brightness_pct-64))>>6);
                    end                
                    else begin
                        m_axis_data <= s_axis_data;
                    end                
                end
                else begin
                    m_axis_data <= s_axis_data;               
                end
            end
        end
    end
    always@(posedge axi_clk) begin
        m_axis_valid <= s_axi_valid & s_axis_ready;
        m_axis_last <= s_axis_last;
        m_axis_user <= s_axis_user;
    end
endmodule
