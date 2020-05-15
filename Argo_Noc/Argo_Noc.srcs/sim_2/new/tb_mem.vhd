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

entity tb_memory is

end tb_memory;
----------------------------------------------------------------------------------
architecture Behavioral of tb_memory is
    
    component memory is
        port(  Wen      : in STD_LOGIC;
               Ren      : in STD_LOGIC;
               Data_in  : in STD_LOGIC_VECTOR (3 downto 0);
               ack_in   : in STD_LOGIC;
               reset    : in STD_LOGIC;
               
               Data_out : out STD_LOGIC_VECTOR (3 downto 0);
               ack_out  : out STD_LOGIC;
               ack_ctl  : out STD_LOGIC);
    end component;
    
   signal Wen      : STD_LOGIC;                     
   signal Ren      : STD_LOGIC;                     
   signal Data_in  : STD_LOGIC_VECTOR (3 downto 0); 
   signal ack_in   : STD_LOGIC;                     
   signal reset    : STD_LOGIC;                     
   signal Data_out : STD_LOGIC_VECTOR (3 downto 0);
   signal ack_out  : STD_LOGIC;                    
   signal ack_ctl  : STD_LOGIC;    
   signal or_a_1, or_b_1, or_a_2, or_b_2, or_o_1, or_o_2, and_o_3, and_o_4 : STD_LOGIC;               

begin

    DUT : memory 
        Port map(
            Wen      => Wen     ,
            Ren      => Ren     ,
            Data_in  => Data_in ,
            ack_in   => ack_in  ,
            reset    => reset   ,
            Data_out => Data_out,      
            ack_out  => ack_out ,
            ack_ctl  => ack_ctl 
                       
        );
        
    or_o_1 <= or_a_1 NOR or_b_1;
    or_o_2 <= or_a_2 NOR or_b_2;
    
    or_b_1 <= reset and or_o_2;
    or_b_2 <= reset and or_o_1;
    
    and_o_3 <= or_a_1 AND or_b_1;
    and_o_4 <= or_a_2 AND or_b_2;
      
    test : process
    begin
      reset <='0';
      or_a_1 <= '0';
      or_a_2 <= '0';
      wait for 100 ns;
      reset <='1';
      or_a_1 <= '1';
      or_a_2 <= '0';
      wait for 100 ns;
      or_a_1 <= '0';
      or_a_2 <= '0';
      wait for 100 ns;
      or_a_1 <= '0';
      or_a_2 <= '1';
      wait for 100 ns;
      or_a_1 <= '0';
      or_a_2 <= '0';
      wait for 100 ns;
      or_a_1 <= '1';
      or_a_2 <= '0';
      WAIT;
      -- reset <= '0';
      --wait for 100 ns;
      --Wen      <= '1';
      --Ren      <= '1';
      --Data_in  <= STD_LOGIC_VECTOR (to_unsigned(8,Data_in'length)); 
      --ack_in   <= '1';
      --reset    <= '1';
      --wait for 100 ns;
      --Wen      <= '0';
      --Ren      <= '0';
      --Data_in  <= STD_LOGIC_VECTOR (to_unsigned(0,Data_in'length)); 
      --ack_in   <= '1';
      --wait for 100 ns;
      --Wen      <= '0';
      --Ren      <= '1';
      --Data_in  <= STD_LOGIC_VECTOR (to_unsigned(7,Data_in'length)); 
      --ack_in   <= '1';
      --reset    <= '1';

    end process;

                     
end Behavioral;