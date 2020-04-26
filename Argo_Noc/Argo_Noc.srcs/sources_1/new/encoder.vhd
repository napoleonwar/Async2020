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

entity encoder is
    Port ( data_in : in STD_LOGIC_VECTOR (34 downto 0);
           data_out : out data_encode
          -- headphit : out  STD_LOGIC_VECTOR (2 downto 0)
           );
end encoder;

architecture Behavioral of encoder is

begin
    process(data_in) is
    begin
    for i in 0 to ORI_DATA_WIDTH-1 loop  -- I IN 0 TO 34
    if data_in(i) = '1' then
        data_out.t(i) <= '1';
        data_out.f(i) <= '0';
    else
        data_out.t(i) <= '0';
        data_out.f(i) <= '1';
    end if;
    end loop;
    --headphit <= data_in(34 downto 32);
end process;
end Behavioral;
