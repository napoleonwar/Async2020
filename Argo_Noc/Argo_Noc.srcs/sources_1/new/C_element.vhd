----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/04/10 16:58:43
-- Design Name: 
-- Module Name: C_element - Behavioral
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

entity C_element is
    generic(
        init : STD_LOGIC := '0');
    Port ( i0 : in STD_LOGIC;
           i1 : in STD_LOGIC;
           i2 : in STD_LOGIC;
           i3 : in STD_LOGIC;
           io : out STD_LOGIC);
end C_element;

architecture Behavioral of C_element is
begin
 
process
begin
    io <= i3 AND ((i0 AND i1) OR (i2 AND (i0 OR i1)));
    if i3 = '0' then
        io <= init;
    end if;
end process;

end Behavioral;
