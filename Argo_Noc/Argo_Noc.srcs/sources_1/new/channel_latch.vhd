----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/04/10 16:50:15
-- Design Name: 
-- Module Name: channel_latch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.define_type.all;

entity channel_latch is
    Port ( data_in : in STD_LOGIC_VECTOR (34 downto 0);
           data_out : out data_encode;
           ack_in_chl : in STD_LOGIC;
           ack_out_chl : out STD_LOGIC);
end channel_latch;
----------------------------------------------------------
architecture Behavioral of channel_latch is

    component C_element
    port(
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC
    );
    end component;
    component encoder
    port ( data_in : in STD_LOGIC_VECTOR (34 downto 0);
           data_out : out data_encode
           );
    end component;
 -----------------------------------------------
    signal encoded_data  : data_encode;
    signal data_after_CE : data_encode;
    signal data_or       : std_logic_vector(31 downto 0); 
    signal data_and_left : std_logic := '1';
    signal data_and_right: std_logic;
    signal ack : std_logic;
    
begin
   input : encoder port map(data_in => data_in,
                            data_out => encoded_data  );
   channel_latch : for i in 0 to 31 generate
        cElement_true : C_element 
                    port map(a => encoded_data.t(i),
                             b => ack,
                             y => data_after_CE.t(i) );
        cElement_false : C_element 
                    port map(a => encoded_data.f(i),
                             b => ack,
                             y => data_after_CE.f(i) );
         end generate;
         cElement_acki : C_element
                        port map(a => data_and_left,
                                 b => data_and_right,
                                 y => ack_out_chl);
         data_out <= data_after_CE;
         ack <= NOT ack_in_chl;
    process(data_in,ack) is
    begin
    for i in 0 to 34 loop
        data_or(i) <= data_after_CE.t(i) or data_after_CE.f(i);
        if data_or(i) = '0' then
            data_and_left <= '0';
        end if;
        if data_or(i) = '1' then
            data_and_right <= '1';
        end if;
    end loop;
    
    end process;

end Behavioral;
