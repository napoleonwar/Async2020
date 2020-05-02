----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/04/13 16:13:21
-- Design Name: 
-- Module Name: encoder - Behavioral
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

entity encoder is
    Port ( data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out channel_forward
          -- headphit : out  STD_LOGIC_VECTOR (2 downto 0)
           );
end encoder;

architecture Behavioral of encoder is
begin
      
    process(data_in) is
    begin
        data_out.w00 <=(others=>'0');
        data_out.w01 <=(others=>'0');
        data_out.w10 <=(others=>'0');
        data_out.w11 <=(others=>'0');
        for i in 0 to 15 loop
            case data_in((1+(i*2)) downto (i*2)) is 
                when "00" =>   data_out.w00(i) <= '1'; 
                when "01" =>   data_out.w01(i) <= '1'; 
                when "10" =>   data_out.w10(i) <= '1'; 
                when others =>  data_out.w11(i) <= '1'; 
            end case;
        end loop;
    end process;
    
end Behavioral;
