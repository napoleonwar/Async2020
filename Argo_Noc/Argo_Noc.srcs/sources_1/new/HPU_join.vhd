----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2020 19:06:42
-- Design Name: 
-- Module Name: HPU_join - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.define_type.all;
use IEEE.NUMERIC_STD.ALL;

entity HPU_join is
    Port (  data_in_x   : in channel_forward;
            data_in_y   : in route;
            ack_in      : STD_LOGIC;
            
            data_out    : out full_channel_forward;
            ack_x       : out STD_LOGIC;
            ack_y       : out STD_LOGIC);
end HPU_join;
----------------------------------------------------------------------------------
architecture Behavioral of HPU_join is
begin
    ack_x <= ack_in;
    ack_y <= ack_in;
    
    data_out.phit <= data_in_x.phit;
    data_out.w00  <= data_in_x.w00;
    data_out.w01  <= data_in_x.w01;
    data_out.w10  <= data_in_x.w10;
    data_out.w11  <= data_in_x.w11;
    data_out.N    <= data_in_y.N;
    data_out.E    <= data_in_y.E;
    data_out.S    <= data_in_y.S;
    data_out.W    <= data_in_y.W;
end Behavioral;
