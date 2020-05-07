----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2020 13:00:58
-- Design Name: 
-- Module Name: Xbar_join - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Xbar_join is
    Port ( Data_x : in STD_LOGIC;
           Data_y : in STD_LOGIC;
           Data_z : in STD_LOGIC;
           Data_w : in STD_LOGIC;
           Ack_in : in STD_LOGIC;
           Data_out : out STD_LOGIC;
           Ack_out : out STD_LOGIC);
end Xbar_join;

architecture Behavioral of Xbar_join is

begin


end Behavioral;
