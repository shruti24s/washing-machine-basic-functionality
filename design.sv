// Code your design here
module washing_machine(clk,rst,start,door,lock,filled,water_valve,water_wash,detergent_add,soap_wash,cycle_timeout,motor,drained,drain_valve,spin,done);
  
  input clk, rst, start, door, filled,detergent_add,cycle_timeout,drained,spin;
  output reg lock, water_valve,water_wash,soap_wash,motor,drain_valve,done;
  
  parameter S1 = 3'b000; //lock
  parameter S2 = 3'b001; // fill the water
  parameter S3 = 3'b010; //add detergent 
  parameter S4 = 3'b011; //cycle running
  parameter S5 = 3'b100; // draining
  parameter S6 = 3'b101; //spinning
  
  reg [2:0] state,next_state;
  
  always @(posedge clk or negedge rst)
    begin
      if(rst)
		begin
			state<=3'b000;
		end
		else
		begin
			state<=next_state;
		end
	end
  
  
  always @(state or start or door or filled or detergent_add or cycle_timeout or drained or spin)
    begin
    lock = 0;
    water_valve = 0;
    water_wash = 0;
    soap_wash = 0;
    motor = 0;
    drain_valve = 0;
    done = 0;
    next_state = state;
      
      case(state)
        S1 : begin 
          next_state = (start == 1 && door == 1) ? S2 : S1; 
        end
        
        S2 : begin
                         lock = 1;
               water_valve = (filled == 0) ? 1'b1 : 1'b0; 
               next_state = (filled == 1 && detergent_add == 0) ? S3 : 
                       (filled == 1 && detergent_add == 1) ? S4 : S2;
               soap_wash = (detergent_add == 0) ? 1'b1 : 1'b0;
               water_wash = (detergent_add == 1) ? 1'b1 : 1'b0;
             end 
        
        S3 : begin
             lock = 1;
             water_valve = 0;
             soap_wash = 1;
             next_state = (detergent_add == 1) ? S4 : S3;   
             end

            S4 : begin
                 lock = 1;
              motor = (cycle_timeout == 1) ? 1'b0 : 1'b1;
              next_state = (cycle_timeout == 1) ? S5 : S4;

            end
        
        S5 : begin
          lock = 1;
          drain_valve = (drained == 1) ? 1'b0: 1'b1;
          next_state = (drained == 1) ? S6:S5;
        end
              
        
        S6 : begin
            lock = 1;
            next_state = (spin == 1) ? S1 : S6; 
            done = (spin == 1) ? 1'b1 : 1'b0;
        end
          
      
    default : begin
        next_state = S1; // Reset to initial state in case of invalid state
      end
    endcase
  end
  
endmodule

