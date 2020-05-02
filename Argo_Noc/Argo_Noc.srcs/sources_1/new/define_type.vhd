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

type channel_forward is record
    phit : STD_LOGIC_VECTOR (3 downto 0);
    w00 : STD_LOGIC_VECTOR (15 downto 0); 
    w01 : STD_LOGIC_VECTOR (15 downto 0);
    w10 : STD_LOGIC_VECTOR (15 downto 0); 
    w11 : STD_LOGIC_VECTOR (15 downto 0); 
end record channel_forward;

type route is record
    N : STD_LOGIC; 
    E : STD_LOGIC;
    S : STD_LOGIC; 
    W : STD_LOGIC; 
end record route;

type full_channel_forward is record
    phit : STD_LOGIC_VECTOR (3 downto 0);
    w00 : STD_LOGIC_VECTOR (15 downto 0); 
    w01 : STD_LOGIC_VECTOR (15 downto 0);
    w10 : STD_LOGIC_VECTOR (15 downto 0); 
    w11 : STD_LOGIC_VECTOR (15 downto 0);
    N : STD_LOGIC; 
    E : STD_LOGIC;
    S : STD_LOGIC; 
    W : STD_LOGIC;  
end record full_channel_forward;

end package define_type;