----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.05.2020 12:34:14
-- Design Name: 
-- Module Name: tb_channel_latch - Behavioral
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

entity tb_channel_latch is
end tb_channel_latch;

architecture Behavioral of tb_channel_latch is
    Component channel_latch
    Port(
        data_in : in STD_LOGIC_VECTOR (34 downto 0);
        data_out : out channel_forward;
        phit_out : out phit_type;
        ack_in_chl : in channel_backward;
        ack_out_chl : out channel_backward);
    end component;
    
    --Inputs
    signal data_in :  STD_LOGIC_VECTOR (34 downto 0);
    signal ack_in_ch1 : channel_backward;
    
    --Outputs
    signal data_out : channel_forward;
    signal phit_out : phit_type;
    signal ack_out_chl : channel_backward;
    
begin

    DUT: channel_latch port map(
        data_in => data_in,
        data_out => data_out,
        phit_out => phit_out,
        ack_in_chl => ack_in_ch1,
        ack_out_chl => ack_out_chl);
    
    tb: process
    begin
        -- data ready but no acknowledge 
        ack_in_ch1.ack <= '1';
        data_in(34) <='1';
        data_in(33) <='1';
        data_in(32) <='0';
        data_in(31 downto 0) <= STD_LOGIC_VECTOR (to_unsigned(1,32));
        
        wait for 200 ns;
        -- acknowledge
        ack_in_ch1.ack <= '0';
        
        wait for 200 ns;
        -- new phit
        ack_in_ch1.ack <= '1';
        data_in(34) <='1';
        data_in(33) <='0';
        data_in(32) <='0';
        data_in(31 downto 0) <= STD_LOGIC_VECTOR (to_unsigned(2,32));
        
        wait;
        
    end process;
end Behavioral;
