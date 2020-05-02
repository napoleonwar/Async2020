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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PhitEncoder is
    Port ( data_in : in STD_LOGIC_VECTOR (2 downto 0); 
           data_out : out channel_forward -- Header, Tail, Intermidiate, Void
           );
end PhitEncoder;

architecture Behavioral of PhitEncoder is

begin
    process(data_in) is
    begin
    data_out.phit <=(others=>'0');
    case data_in is
        when "110" =>   data_out.phit(3) <= '1'; -- IS Header
        when "101" =>   data_out.phit(2) <= '1'; -- IS Tail
        when "100" =>   data_out.phit(1) <= '1'; -- IS Intermediate
        when others =>  data_out.phit(0) <= '1'; -- IS Void
    end case;
    end process;
end Behavioral;
