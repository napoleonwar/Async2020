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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_misc.and_reduce;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux is
    Port ( x : in data_encode;
           y : in data_encode;
           ctl : in ctrl;
           z : out data_encode;
           z_ack : in std_logic;
           x_ack : out std_logic;
           y_ack : out std_logic;
           ctl_ack : out std_logic
           );
end Mux;

architecture Behavioral of Mux is
component C_element is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;
    signal x_after_CE : data_encode;
    signal y_after_CE : data_encode;
    signal x_data_or  : std_logic_vector(31 downto 0); 
    signal y_data_or  : std_logic_vector(31 downto 0); 
    signal x2ack      : std_logic;
    signal y2ack      : std_logic;
    signal ack : std_logic;
begin
    ack <= z_ack;
    MUX : for i in 0 to 34 generate
        cElement_x_t : C_element 
                    port map(a => x.t(i),
                             b => ctl.f,
                             y => x_after_CE.t(i));
        cElement_x_f : C_element 
                    port map(a => x.f(i),
                             b => ctl.f,
                             y => x_after_CE.f(i));      
        cElement_y_t : C_element 
                    port map(a => y.t(i),
                             b => ctl.t,
                             y => y_after_CE.t(i));      
        cElement_y_f : C_element 
                    port map(a => y.f(i),
                             b => ctl.t,
                             y => y_after_CE.f(i) );
         end generate;
     x_ack_CE : C_element
            port map(a => x2ack,
                     b => ack,
                     y => x_ack);
     Y_ack_CE : C_element
            port map(a => y2ack,
                     b => ack,
                     y => y_ack);
      ctl_ack <= ack;
process(x_after_CE,y_after_CE)
begin
    for i in 0 to 34 loop
        x_data_or(i) <= x_after_CE.f(i) OR x_after_CE.t(i);
        y_data_or(i) <= y_after_CE.f(i) OR y_after_CE.t(i);
    end loop;
    x2ack <= and_reduce(x_data_or);
    y2ack <= and_reduce(y_data_or);
    for i in 0 to 34 loop
        z.t(i) <= x_after_CE.t(i) OR y_after_CE.t(i);
        z.f(i) <= x_after_CE.f(i) OR y_after_CE.f(i);
    end loop;
end process;
end Behavioral;
