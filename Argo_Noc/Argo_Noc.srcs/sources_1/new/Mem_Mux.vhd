----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2020 17:12:17
-- Design Name: 
-- Module Name: Mem_Mux - Behavioral
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

entity Mem_Mux is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : in STD_LOGIC_VECTOR (3 downto 0);
           ctl : in STD_LOGIC_VECTOR (1 downto 0);
           z_ack : in std_logic;
           
           z : out STD_LOGIC_VECTOR (3 downto 0);
           x_ack : out std_logic;
           y_ack : out std_logic;
           ctl_ack : out std_logic);
end Mem_Mux;
----------------------------------------------------------------------------------
architecture Behavioral of Mem_Mux is
    component C_element is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
    end component;
    signal x_after_CE : STD_LOGIC_VECTOR (3 downto 0);
    signal y_after_CE : STD_LOGIC_VECTOR (3 downto 0);
    signal x_data_or  : std_logic;
    signal y_data_or  : std_logic;
    signal data_and_left_x : std_logic;
    signal data_and_right_x: std_logic;
    signal data_and_left_y : std_logic;
    signal data_and_right_y: std_logic;
    signal ctl2b      : std_logic_vector(1 downto 0); 

begin
    ctl_ack <= z_ack;

    mux_data_x : for i in 0 to 3 generate
        cElement_data_x : C_element 
                port map(a => x(i),
                         b => ctl(0),
                         y => x_after_CE(i));
    end generate;
    mux_data_y : for i in 0 to 3 generate
        cElement_data_y : C_element 
                port map(a => y(i),
                         b => ctl(1),
                         y => y_after_CE(i));
    end generate;
    
    process(x_after_CE,y_after_CE,x_data_or,y_data_or)
    begin
        x_data_or <= or_reduce(x_after_CE);
        y_data_or <= or_reduce(y_after_CE);
        for i in 0 to 3 loop
            z(i) <= x_after_CE(i) OR y_after_CE(i);
        end loop;
    end process;
    
    x_ack_CE : C_element
           port map(a => x_data_or,
                    b => z_ack,
                    y => x_ack);
    Y_ack_CE : C_element
           port map(a => y_data_or,
                    b => z_ack,
                    y => y_ack);

end Behavioral;
