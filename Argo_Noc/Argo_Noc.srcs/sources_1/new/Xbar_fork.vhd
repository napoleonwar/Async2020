----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2020 20:31:08
-- Design Name: 
-- Module Name: Xbar_fork - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Xbar_fork is
    Port ( Data_in : in full_channel_forward;
           Ack_x : in STD_LOGIC;
           Ack_y : in STD_LOGIC;
           Ack_z : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           Data_x : out STD_LOGIC_VECTOR (3 downto 0); -- write/read enable
           Data_y : out STD_LOGIC_VECTOR (3 downto 0); -- SEL (routing)
           Data_z : out channel_forward; -- Data for Demux
           Ack_out : out STD_LOGIC);
end Xbar_fork;
----------------------------------------------------------------------------------
architecture Behavioral of Xbar_fork is
    component C_element_LUT
    port(
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           reset : in STD_LOGIC;
           y : out STD_LOGIC
    );
    end component;
    signal ack1, ack2 : STD_LOGIC;
    signal no_reset : STD_LOGIC := '1';

begin

    Data_x <= data_in.phit;
    
    Data_y <= data_in.routing;
    
    Data_z.phit <= data_in.phit;
    Data_z.w00 <= data_in.w00;
    Data_z.w01 <= data_in.w01;
    Data_z.w10 <= data_in.w10;
    Data_z.w11 <= data_in.w11;
    
    ack1 <= Ack_x AND Ack_y;
    ack2 <= Ack_z;
    
    cElement_acki : C_element_LUT
    port map(a => ack1,
             b => ack2,
             reset => reset,
             y => ack_out);

end Behavioral;
