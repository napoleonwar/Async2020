----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/04/24 21:17:38
-- Design Name: 
-- Module Name: Mux - Behavioral
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
use work.define_type.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_misc.and_reduce;
use IEEE.std_logic_misc.or_reduce;

entity Mux is
    Port ( x : in channel_forward;
           y : in channel_forward;
           ctl : in STD_LOGIC_VECTOR (3 downto 0);
           z_ack : in std_logic;
           reset : in std_logic;
           z : out channel_forward;
           x_ack : out std_logic;
           y_ack : out std_logic;
           ctl_ack : out std_logic);
end Mux;
-----------------------------------------------------------------------------------
architecture Behavioral of Mux is
component C_element_LUT is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           reset : in STD_LOGIC;
           y : out STD_LOGIC);
end component;
    signal x_after_CE : channel_forward;
    signal y_after_CE : channel_forward;
    signal x_data_or  : std_logic_vector(15 downto 0); 
    signal y_data_or  : std_logic_vector(15 downto 0);
    signal data_and_left_x : std_logic;
    signal data_and_right_x: std_logic;
    signal data_and_left_y : std_logic;
    signal data_and_right_y: std_logic;
    
    signal x2ack      : std_logic;
    signal y2ack      : std_logic;
    signal ctl2b      : std_logic_vector(1 downto 0); 
    
    signal no_reset : STD_LOGIC := '1';

begin
    ctl_ack <= z_ack;
    ctl2b <= ctl(3) & (ctl(2) OR ctl(1) OR ctl(0));
    MUX_DATA : for i in 0 to 15 generate
        cElement_x_00 : C_element_LUT 
                    port map(a => x.w00(i),
                             b => ctl2b(0),
                             reset => reset,
                             y => x_after_CE.w00(i));
        cElement_x_01 : C_element_LUT 
                    port map(a => x.w01(i),
                             b => ctl2b(0),
                             reset => reset,
                             y => x_after_CE.w01(i));
        cElement_x_10 : C_element_LUT 
                    port map(a => x.w10(i),
                             b => ctl2b(0),
                             reset => reset,
                             y => x_after_CE.w10(i));
        cElement_x_11 : C_element_LUT 
                    port map(a => x.w11(i),
                             b => ctl2b(0),
                             reset => reset,
                             y => x_after_CE.w11(i));   
        cElement_y_00 : C_element_LUT 
                    port map(a => y.w00(i),
                             b => ctl2b(1),
                             reset => reset,
                             y => y_after_CE.w00(i));
        cElement_y_01 : C_element_LUT 
                    port map(a => y.w01(i),
                             b => ctl2b(1),
                             reset => reset,
                             y => y_after_CE.w01(i));
        cElement_y_10 : C_element_LUT 
                    port map(a => y.w10(i),
                             b => ctl2b(1),
                             reset => reset,
                             y => y_after_CE.w10(i));
        cElement_y_11 : C_element_LUT 
                    port map(a => y.w11(i),
                             b => ctl2b(1),
                             reset => reset,
                             y => y_after_CE.w11(i));
         end generate;
         
    MUX_Phit : for i in 0 to 3 generate
        cElement_phit_x : C_element_LUT 
                port map(a => x.phit(i),
                         b => ctl2b(0),
                         reset => reset,
                         y => x_after_CE.phit(i));
        cElement_phit_y : C_element_LUT 
                port map(a => y.phit(i),
                         b => ctl2b(1),
                         reset => reset,
                         y => y_after_CE.phit(i));
       end generate;
         
process(x_after_CE,y_after_CE,x_data_or,y_data_or)
begin
    for i in 0 to 15 loop
        x_data_or(i) <= x_after_CE.w00(i) OR x_after_CE.w01(i)OR x_after_CE.w10(i)OR x_after_CE.w11(i);
        y_data_or(i) <= y_after_CE.w00(i) OR y_after_CE.w01(i)OR y_after_CE.w10(i)OR y_after_CE.w11(i);
    end loop;
    data_and_left_x <= and_reduce(x_data_or);
    data_and_right_x <= or_reduce(x_data_or);
    data_and_left_y <= and_reduce(y_data_or);
    data_and_right_y <= or_reduce(y_data_or);
    for i in 0 to 15 loop
        z.w00(i) <= x_after_CE.w00(i) OR y_after_CE.w00(i);
        z.w01(i) <= x_after_CE.w01(i) OR y_after_CE.w01(i);
        z.w10(i) <= x_after_CE.w10(i) OR y_after_CE.w10(i);
        z.w11(i) <= x_after_CE.w11(i) OR y_after_CE.w11(i);
    end loop;
    for i in 0 to 3 loop
        z.phit(i) <= x_after_CE.phit(i) OR y_after_CE.phit(i);
    end loop;
end process;

x_ack_CE : C_element_LUT
           port map(a => data_and_left_x,
                    b => data_and_right_x,
                    reset => reset,
                    y => x2ack);
Y_ack_CE : C_element_LUT
           port map(a => data_and_left_y,
                    b => data_and_right_y,
                    reset => reset,
                    y => y2ack);
                    
x_ack_CE1 : C_element_LUT
           port map(a => x2ack,
                    b => z_ack,
                    reset => reset,
                    y => x_ack);
Y_ack_CE1 : C_element_LUT
           port map(a => y2ack,
                    b => z_ack,
                    reset => reset,
                    y => y_ack);
      
end Behavioral;
