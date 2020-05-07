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
    
    component Mem_Mux is
        port(  x : in STD_LOGIC_VECTOR (3 downto 0);
               y : in STD_LOGIC_VECTOR (3 downto 0);
               ctl : in STD_LOGIC_VECTOR (1 downto 0);
               z_ack : in std_logic;
               z : out STD_LOGIC_VECTOR (3 downto 0);
               x_ack : out std_logic;
               y_ack : out std_logic;
               ctl_ack : out std_logic);
    end component;
    
    component C_element
        port(   a : in STD_LOGIC;
                b : in STD_LOGIC;
                y : out STD_LOGIC);
    end component;

    signal data_after_CE, data_after_CE2, lower_and, data_in_or, data_read : STD_LOGIC_VECTOR (3 downto 0);
    signal Data_in_ack_right, ctl_ack_left, ctl_ack_right, Do_ack, Di_ack, ctl_ack_int, ctl_ack_int1 : STD_LOGIC;
    signal ctl : std_logic_vector (1 downto 0);
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
            Data_Read(i) <= (NOT lower_and(i)) AND (Ren);
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
            port map(a => Do_ack,
                     b => Ren,
                     y => ctl_ack_right);
    
    ctl <=  Wen & Ren;                
    Mux : Mem_Mux
        port map(x => Data_Read, y => Data_in, ctl => ctl, z_ack => ack_in, 
                 z => Data_out, x_ack => Do_ack, y_ack => Di_ack, ctl_ack => ctl_ack_int1);
    
    ctl_ack_int <= ctl_ack_left OR ctl_ack_right;
    
    cElement_Ctl_ack : C_element 
            port map(a => ctl_ack_int,
                     b => ctl_ack_int1,
                     y => ack_ctl);
                     
    cElement_Di_ack_out : C_element 
            port map(a => Di_ack,
                     b => ctl_ack_left,
                     y => ack_out);
                     
end Behavioral;
