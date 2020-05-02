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
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end C_element;

architecture Behavioral of C_element is
    signal y_w : STD_LOGIC;
begin
 
 y_w <= (a AND b) OR (y_w AND (a OR b));
 
 y <= y_w;
 
   -- process(a,b) is 
   -- begin
   -- if a = b then
   --     y <= a;
   -- end if;
   -- end process;
end Behavioral;
