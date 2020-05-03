----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2020 11:43:02
-- Design Name: 
-- Module Name: memory - Behavioral
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
use IEEE.std_logic_misc.and_reduce;
use IEEE.std_logic_misc.or_reduce;

entity memory is
    Port ( Wen      : in STD_LOGIC;
           Ren      : in STD_LOGIC;
           Data_in  : in STD_LOGIC_VECTOR (3 downto 0);
           ack_in   : in STD_LOGIC;
           
           Data_out : out STD_LOGIC_VECTOR (3 downto 0);
           ack_out  : out STD_LOGIC;
           ack_ctl  : out STD_LOGIC);
end memory;
----------------------------------------------------------------------------------
architecture Behavioral of memory is
    component C_element
        port(   a : in STD_LOGIC;
                b : in STD_LOGIC;
                y : out STD_LOGIC);
    end component;

    signal data_after_CE, data_after_CE2, lower_and, data_in_or : STD_LOGIC_VECTOR (3 downto 0);
    signal Data_in_ack_right, ctl_ack_left, ctl_ack_right : STD_LOGIC;
begin

    mem_latch_route : for i in 0 to 3 generate
        cElement_route : C_element 
                port map(a => Data_in(i),
                         b => Wen,
                         y => data_after_CE(i));
    end generate;
    
    process(data_after_CE, data_after_CE2, lower_and, Ren, Data_in_or) is
    begin
        for i in 0 to 3 loop
            lower_and(i) <= data_after_CE(i) NOR data_after_CE2(i);
        end loop;
        data_after_CE2(0) <= lower_and(0);
        data_after_CE2(1) <= lower_and(1);
        data_after_CE2(2) <= lower_and(2);
        data_after_CE2(3) <= lower_and(3);
        for i in 0 to 3 loop
            Data_out(i) <= (NOT lower_and(i)) AND (Ren);
        end loop;
        for i in 0 to 3 loop
            Data_in_or(i) <= data_after_CE(i) AND data_after_CE2(i);
        end loop;
        Data_in_ack_right <= or_reduce(Data_in_or);
    end process;
    
    cElement_Di_ack : C_element 
            port map(a => Data_in_ack_right,
                     b => Wen,
                     y => ctl_ack_left);
                     
    cElement_Do_ack : C_element 
            port map(a => ack_in,
                     b => Ren,
                     y => ctl_ack_right);
    
    ack_ctl <= ctl_ack_left OR ctl_ack_right;
    ack_out <= ctl_ack_left;
end Behavioral;
