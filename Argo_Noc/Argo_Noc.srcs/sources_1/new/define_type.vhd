----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/04/13 16:17:28
-- Design Name: 
-- Module Name: define_type - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

package define_type is
constant ORI_DATA_WIDTH : INTEGER := 35;

type data_encode is record
    f : STD_LOGIC_VECTOR (ORI_DATA_WIDTH-1 downto 0); -- 34 TO 0
    t : STD_LOGIC_VECTOR (ORI_DATA_WIDTH-1 downto 0); -- 34 TO 0
end record data_encode;

type data_no_phit is record
    f : STD_LOGIC_VECTOR (ORI_DATA_WIDTH-4 downto 0); -- 31 TO 0
    t : STD_LOGIC_VECTOR (ORI_DATA_WIDTH-4 downto 0); -- 31 TO 0
end record data_no_phit;

type ctrl is record
    f : STD_LOGIC;
    t : STD_LOGIC; 
end record ctrl;
end package define_type;