----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2020 19:41:16
-- Design Name: 
-- Module Name: HPU_latch - Behavioral
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

entity HPU_latch is
    Port ( data_in : in full_channel_forward;
           ack_in_chl : in STD_LOGIC;
           data_out : out full_channel_forward;
           ack_out_chl : out STD_LOGIC);
end HPU_latch;
----------------------------------------------------------
architecture Behavioral of HPU_latch is

    component C_element
    port(
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC
    );
    end component;
    
 -----------------------------------------------
    signal data_after_CE : full_channel_forward;
    signal data_or       : std_logic_vector(17 downto 0); 
    signal data_and_left : std_logic;
    signal data_and_right: std_logic;
    signal ack : std_logic;
    
begin

    ack <= NOT ack_in_chl;
    
    hpu_latch_Phit : for i in 0 to 3 generate
        cElement_phit : C_element 
                port map(a => data_in.phit(i),
                         b => ack,
                         y => data_after_CE.phit(i));
       end generate;   
                               
    hpu_latch_data : for i in 0 to 15 generate
        cElement_00 : C_element 
            port map(a => data_in.w00(i),
                     b => ack,
                     y => data_after_CE.w00(i) );
        cElement_01 : C_element 
            port map(a => data_in.w01(i),
                     b => ack,
                     y => data_after_CE.w01(i) );
        cElement_10 : C_element 
            port map(a => data_in.w10(i),
                     b => ack,
                     y => data_after_CE.w10(i) );
        cElement_11 : C_element 
            port map(a => data_in.w11(i),
                     b => ack,
                     y => data_after_CE.w11(i) );         
    end generate;
    
    hpu_latch_Route : for i in 0 to 3 generate
        cElement_route : C_element 
                port map(a => data_in.routing(i),
                         b => ack,
                         y => data_after_CE.routing(i));
       end generate;
    
                                 
    data_out <= data_after_CE;
    
    --Completion Detector Start
    process(data_after_CE, data_or) is
    begin
        for i in 0 to 15 loop
            data_or(i) <= data_after_CE.w00(i) OR data_after_CE.w01(i) OR data_after_CE.w10(i) OR data_after_CE.w11(i);
        end loop;
  
        data_or(16) <= or_reduce(data_after_CE.phit);
        data_or(17) <= or_reduce(data_after_CE.routing);
        
        data_and_left <= and_reduce(data_or);
        data_and_right <= or_reduce(data_or); 
    end process;
                   
    cElement_acki : C_element
                    port map(a => data_and_left,
                             b => data_and_right,
                             y => ack_out_chl);
    --Completion Detector End
end Behavioral;
