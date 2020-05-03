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
    Port ( data_in : in STD_LOGIC_VECTOR (34 downto 0);
           data_out : out channel_forward;
           ack_in_chl : in STD_LOGIC;
           ack_out_chl : out STD_LOGIC);
end channel_latch;
----------------------------------------------------------
architecture Behavioral of channel_latch is

    component C_element
    port(   a : in STD_LOGIC;
            b : in STD_LOGIC;
            y : out STD_LOGIC);
    end component;
    
    component encoder
    port (  data_in : in STD_LOGIC_VECTOR (31 downto 0);
            data_out : out encoded_data);
    end component;
    
    component PhitEncoder
    port (  data_in : in STD_LOGIC_VECTOR (2 downto 0);
            data_out : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
 -----------------------------------------------
    signal encoded_data  : encoded_data;
    signal encoded_phit  : STD_LOGIC_VECTOR (3 downto 0);
    signal data_after_CE : channel_forward;
    signal data_or       : std_logic_vector(16 downto 0); 
    signal data_and_left : std_logic;
    signal data_and_right: std_logic;
    signal ack : std_logic;
    
begin

    ack <= NOT ack_in_chl;
    
    DataIn : encoder port map(data_in => data_in(31 downto 0),
                            data_out => encoded_data);
                            
    PhitIn : PhitEncoder port map(data_in => data_in(34 downto 32),
                            data_out => encoded_phit);
                            
    channel_latch_data : for i in 0 to 15 generate
        cElement_00 : C_element 
            port map(a => encoded_data.w00(i),
                     b => ack,
                     y => data_after_CE.w00(i) );
        cElement_01 : C_element 
            port map(a => encoded_data.w01(i),
                     b => ack,
                     y => data_after_CE.w01(i) );
        cElement_10 : C_element 
            port map(a => encoded_data.w10(i),
                     b => ack,
                     y => data_after_CE.w10(i) );
        cElement_11 : C_element 
            port map(a => encoded_data.w11(i),
                     b => ack,
                     y => data_after_CE.w11(i) );         
    end generate;
    
    channel_latch_Phit : for i in 0 to 3 generate
        cElement_phit : C_element 
                port map(a => encoded_phit(i),
                         b => ack,
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
                   
    cElement_acki : C_element
                    port map(a => data_and_left,
                             b => data_and_right,
                             y => ack_out_chl);
    --Completion Detector End
end Behavioral;
