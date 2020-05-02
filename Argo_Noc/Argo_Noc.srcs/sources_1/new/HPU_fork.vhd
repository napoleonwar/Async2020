----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2020 11:47:14
-- Design Name: 
-- Module Name: HPU_fork - Behavioral
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

entity HPU_fork is
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
end HPU_fork;
----------------------------------------------------------------------------------
architecture Behavioral of HPU_fork is
    component C_element
    port(
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC
    );
    end component;
    signal ack1, ack2 : STD_LOGIC;
begin

ctl_out <= data_in.phit;

data_out <= data_in;

shiftRight.phit <= data_in.phit;
shiftRight.w00(15 downto 9) <= data_in.w00(15 downto 9);
shiftRight.w01(15 downto 9) <= data_in.w01(15 downto 9);
shiftRight.w10(15 downto 9) <= data_in.w10(15 downto 9);
shiftRight.w11(15 downto 9) <= data_in.w11(15 downto 9);
shiftRight.w00(8) <= '0';                              
shiftRight.w01(8) <= '0';                              
shiftRight.w10(8) <= '0';                              
shiftRight.w11(8) <= '0';                              
shiftRight.w00(7 downto 0) <= data_in.w00(8 downto 1); 
shiftRight.w01(7 downto 0) <= data_in.w01(8 downto 1); 
shiftRight.w10(7 downto 0) <= data_in.w10(8 downto 1);
shiftRight.w11(7 downto 0) <= data_in.w11(8 downto 1);

SEL.N <= data_in.w00(0);
SEL.E <= data_in.w01(0);
SEL.S <= data_in.w10(0);
SEL.W <= data_in.w11(0);

ack1 <= ctl_ack_in AND ack_in;
ack2 <= ack1_in AND ack2_in;

cElement_acki : C_element
    port map(a => ack1,
             b => ack2,
             y => ack_out);
                             
end Behavioral;
