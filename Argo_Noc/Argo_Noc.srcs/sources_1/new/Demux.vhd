----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2020 12:33:55
-- Design Name: 
-- Module Name: Demux - Behavioral
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

entity Demux is
    Port ( Data_in  : in channel_forward;
           Ctl      : in STD_LOGIC_vector (3 downto 0);
           ack_in    : in STD_LOGIC;
           
           Data_x   : out channel_forward;
           Data_y   : out channel_forward;
           Data_z   : out channel_forward;
           Data_w   : out channel_forward;
           ack_ctl  : out STD_LOGIC;
           ack_out  : out STD_LOGIC);
end Demux;
----------------------------------------------------------------------------------
architecture Behavioral of Demux is
    component C_element is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
    end component;
begin
    DeMUX_phit: for i in 0 to 3 generate
        cElement_x_phit : C_element 
                    port map(a => Data_in.phit(i),
                             b => Ctl(3),
                             y => Data_x.phit(i));
        cElement_y_phit : C_element 
                    port map(a => Data_in.phit(i),
                             b => Ctl(2),
                             y => Data_y.phit(i));
        cElement_z_phit : C_element 
                    port map(a => Data_in.phit(i),
                             b => Ctl(1),
                             y => Data_z.phit(i));
        cElement_w_phit : C_element 
                    port map(a => Data_in.phit(i),
                             b => Ctl(0),
                             y => Data_w.phit(i));                                                               
    end generate;
    DeMUX_DATA : for i in 0 to 15 generate
    --N
        cElement_x_00 : C_element 
                    port map(a => Data_in.w00(i),
                             b => Ctl(3),
                             y => Data_x.w00(i));
        cElement_x_01 : C_element 
                    port map(a => Data_in.w01(i),
                             b => Ctl(3),
                             y => Data_x.w01(i));
        cElement_x_10 : C_element 
                    port map(a => Data_in.w10(i),
                             b => Ctl(3),
                             y => Data_x.w10(i));
        cElement_x_11 : C_element 
                    port map(a => Data_in.w11(i),
                             b => Ctl(3),
                             y => Data_x.w11(i));
        --E                        
        cElement_y_00 : C_element 
                    port map(a => Data_in.w00(i),
                             b => Ctl(2),
                             y => Data_y.w00(i));
        cElement_y_01 : C_element 
                    port map(a => Data_in.w01(i),
                             b => Ctl(1),
                             y => Data_y.w01(i));
        cElement_y_10 : C_element 
                    port map(a => Data_in.w10(i),
                             b => Ctl(2),
                             y => Data_y.w10(i));
        cElement_y_11 : C_element 
                    port map(a => Data_in.w11(i),
                             b => Ctl(2),
                             y => Data_y.w11(i));
        --S
        cElement_z_00 : C_element 
                    port map(a => Data_in.w00(i),
                             b => Ctl(1),
                             y => Data_z.w00(i));
        cElement_z_01 : C_element 
                    port map(a => Data_in.w01(i),
                             b => Ctl(1),
                             y => Data_z.w01(i));
        cElement_z_10 : C_element 
                    port map(a => Data_in.w10(i),
                             b => Ctl(1),
                             y => Data_z.w10(i));
        cElement_z_11 : C_element 
                    port map(a => Data_in.w11(i),
                             b => Ctl(1),
                             y => Data_z.w11(i));
        --W                        
        cElement_w_00 : C_element 
                    port map(a => Data_in.w00(i),
                             b => Ctl(0),
                             y => Data_w.w00(i));
        cElement_w_01 : C_element 
                    port map(a => Data_in.w01(i),
                             b => Ctl(0),
                             y => Data_w.w01(i));
        cElement_w_10 : C_element 
                    port map(a => Data_in.w10(i),
                             b => Ctl(0),
                             y => Data_w.w10(i));
        cElement_w_11 : C_element 
                    port map(a => Data_in.w11(i),
                             b => Ctl(0),
                             y => Data_w.w11(i));
     end generate;
     ack_out <= ack_in;
     ack_ctl <= ack_in;  
end Behavioral;
