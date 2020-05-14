----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2020 21:27:15
-- Design Name: 
-- Module Name: c_element_LUT1 - Behavioral
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
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

library  unisim;
use  unisim.vcomponents.lut4;

entity c_element_LUT1 is
    generic(
        reset_value : BIT := '1');
    Port(   reset : in STD_LOGIC;
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            y : out STD_LOGIC);
end c_element_LUT1;
----------------------------------------------------------------------------------
architecture Behavioral of c_element_LUT1 is
constant  rv : bit :=  reset_value;
constant  reset_vector : bit_vector (7  downto  0) := rv&rv&rv&rv&rv&rv&rv&rv;
       
signal s_out : STD_LOGIC;

attribute  keep : string;
attribute  keep of  s_out : signal  is "true";

begin
    c_element: lut4
        generic map (
            init => "11101000" & reset_vector)
        port map (
            i0 => a,
            i1 => b,
            i2 => s_out,
            i3 => reset,
            o => s_out );

    y <= s_out after 1 ns;        

end Behavioral;
