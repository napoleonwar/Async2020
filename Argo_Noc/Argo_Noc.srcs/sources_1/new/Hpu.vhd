----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/04/24 21:11:07
-- Design Name: 
-- Module Name: Hpu - Behavioral
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

entity Hpu is
    Port ( data_in      : in channel_forward;
           data_out     : out full_channel_forward;
           ack_in       : in STD_LOGIC;
           ack_out      : out STD_LOGIC);
end Hpu;
----------------------------------------------------------------------------------
architecture Behavioral of Hpu is
component HPU_fork is
    Port ( data_in      : in channel_forward;
           ctl_ack_in   : in STD_LOGIC;
           ack_in       : in STD_LOGIC;
           ack1_in      : in STD_LOGIC;
           ack2_in      : in STD_LOGIC;
           ctl_out      : out STD_LOGIC_VECTOR (3 downto 0);
           data_out     : out channel_forward;
           shiftRight   : out channel_forward;
           SEL          : out route;
           ack_out      : out STD_LOGIC);
end component;

component HPU_join is
    Port ( data_in_x   : in channel_forward;
           data_in_y   : in route;
           ack_in      : STD_LOGIC;
            
           data_out    : out full_channel_forward;
           ack_x       : out STD_LOGIC;
           ack_y       : out STD_LOGIC);
end component;

component  Mux is
    Port ( x        : in channel_forward;
           y        : in channel_forward;
           ctl      : in STD_LOGIC_VECTOR (3 downto 0);
           z_ack    : in std_logic;
           z        : out channel_forward;
           x_ack    : out std_logic;
           y_ack    : out std_logic;
           ctl_ack  : out std_logic);
end component;

component C_element is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

    signal data_mux_x   : channel_forward;
    signal data_mux_y   : channel_forward;
    signal ctl_mux      : STD_LOGIC_VECTOR (3 downto 0);
    signal data_join_x  : channel_forward;
    signal data_join_y  : route;
    
    signal ack_mux_x    : std_logic;
    signal ack_mux_y    : std_logic;
    signal ack_mux_ctl  : std_logic;
    signal ack_join_x   : std_logic;
    signal ack_join_y   : std_logic;
    
    
begin
fork: HPU_fork port map (data_in => data_in, ctl_ack_in => ack_mux_ctl, ack_in => ack_join_y,
                         ack1_in => ack_mux_x, ack2_in => ack_mux_y, ctl_out => ctl_mux,
                         data_out => data_mux_x, shiftRight => data_mux_y, SEL => data_join_y, 
                         ack_out => ack_out);
 
MUX_HPU : MUX port map (x => data_mux_x, y => data_mux_y, ctl => ctl_mux, z_ack => ack_join_x, 
                        z => data_join_x, x_ack => ack_mux_x, y_ack => ack_mux_y, ctl_ack => ack_mux_ctl);
    
join: HPU_join port map(data_in_x => data_join_x, data_in_y => data_join_y, ack_in => ack_in,
                        data_out => data_out, ack_x => ack_join_x, ack_y => ack_join_y);
                        
end Behavioral;
