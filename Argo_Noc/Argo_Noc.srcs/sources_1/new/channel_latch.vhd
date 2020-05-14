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
use IEEE.std_logic_misc.and_reduce;
use IEEE.std_logic_misc.or_reduce;

entity channel_latch is
    Port ( data_in : in channel_forward;
           ack_in_chl : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_out : out channel_forward;
           ack_out_chl : out STD_LOGIC);
end channel_latch;
----------------------------------------------------------
architecture Behavioral of channel_latch is

    component C_element_LUT
    port(   reset: in STD_LOGIC;
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            y : out STD_LOGIC);
    end component;

 -----------------------------------------------
    signal data_after_CE : channel_forward;
    signal data_or       : std_logic_vector(16 downto 0); 
    signal data_and_left : std_logic;
    signal data_and_right: std_logic;
    signal ack : std_logic;
    signal no_reset : STD_LOGIC := '1';
    
begin

    ack <= NOT ack_in_chl;
               
    channel_latch_data : for i in 0 to 15 generate
        cElement_00 : C_element_LUT 
            port map(a => data_in.w00(i),
                     b => ack,
                     reset => reset,
                     y => data_after_CE.w00(i) );
        cElement_01 : C_element_LUT 
            port map(a => data_in.w01(i),
                     b => ack,
                     reset => reset,
                     y => data_after_CE.w01(i) );
        cElement_10 : C_element_LUT 
            port map(a => data_in.w10(i),
                     b => ack,
                     reset => reset,
                     y => data_after_CE.w10(i) );
        cElement_11 : C_element_LUT 
            port map(a => data_in.w11(i),
                     b => ack,
                     reset => reset,
                     y => data_after_CE.w11(i) );         
    end generate;
    
    channel_latch_Phit : for i in 0 to 3 generate
        cElement_phit : C_element_LUT 
                port map(a => data_in.phit(i),
                         b => ack,
                         reset => reset,
                         y => data_after_CE.phit(i));
       end generate;                    

    data_out <= data_after_CE;
    
    --Completion Detector Start
    process(data_after_CE,data_or) is
    begin
        for i in 0 to 15 loop
            data_or(i) <= data_after_CE.w00(i) OR data_after_CE.w01(i) OR data_after_CE.w10(i) OR data_after_CE.w11(i);
        end loop;
        
        data_or(16) <= or_reduce(data_after_CE.phit);
        data_and_left <= and_reduce(data_or);
        data_and_right <= or_reduce(data_or); 
    end process;
                   
    cElement_acki : C_element_LUT
                    port map(a => data_and_left,
                             b => data_and_right,
                             reset => reset,
                             y => ack_out_chl);
    --Completion Detector End
end Behavioral;
