`timescale 1ns / 1ps

module dig_clk(
    input rst,
    input clk,
    output reg [6:0] seg,
    output reg [7:0] an 
);

    reg [26:0] clkdiv = 0;
    reg [5:0] sec = 0;
    reg [5:0] min = 0;
    reg [4:0] hrs = 0;

    reg [3:0] digit;
    reg [2:0] sel = 0;

    wire [3:0] secones = sec % 10;
    wire [3:0] sectens = sec / 10;
    wire [3:0] minones = min % 10;
    wire [3:0] mintens = min / 10;
    wire [3:0] hrsones = hrs % 10;
    wire [3:0] hrstens = hrs / 10;

   
    always @(posedge clk)
        clkdiv <= clkdiv + 1;

   
    always @(posedge clkdiv[25]) begin
        if (rst)
            sec <= 0;
        else if (sec == 59)
            sec <= 0;
        else
            sec <= sec + 1;
    end

    
    always @(posedge clkdiv[25]) begin
        if (rst)
            min <= 0;
        else if (sec == 59) begin
            if (min == 59)
                min <= 0;
            else
                min <= min + 1;
        end
    end

    
    always @(posedge clkdiv[25]) begin
        if (rst)
            hrs <= 0;
        else if (sec == 59 && min == 59) begin
            if (hrs == 23)
                hrs <= 0;
            else
                hrs <= hrs + 1;
        end
    end

    
    always @(posedge clkdiv[15])
        sel <= sel + 1;

    
    always @(*) begin
        case (sel)
            3'd0: begin digit = secones;  an = 8'b11111110; end
            3'd1: begin digit = sectens;  an = 8'b11111101; end
            3'd2: begin digit = minones;  an = 8'b11111011; end
            3'd3: begin digit = mintens;  an = 8'b11110111; end
            3'd4: begin digit = hrsones;  an = 8'b11101111; end
            3'd5: begin digit = hrstens;  an = 8'b11011111; end
            default: begin digit = 4'd0; an = 8'b11111111; end
        endcase

        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end

endmodule
