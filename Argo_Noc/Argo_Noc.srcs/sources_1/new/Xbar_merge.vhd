----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2020 13:05:22
-- Design Name: 
-- Module Name: Xbar_merge - Behavioral
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
use IEEE.std_logic_misc.and_reduce;
use IEEE.std_logic_misc.or_reduce;

entity Xbar_merge is
    Port ( Data_x   : in channel_forward;
           Data_y   : in channel_forward;
           Data_z   : in channel_forward;
           Data_w   : in channel_forward;
           Ack_in   : in STD_LOGIC;
           reset : in STD_LOGIC;
           
           Data_out : out channel_forward;
           Ack_x    : out STD_LOGIC;
           Ack_y    : out STD_LOGIC;
           Ack_z    : out STD_LOGIC;
           Ack_w    : out STD_LOGIC);
end Xbar_merge;
----------------------------------------------------------------------------------
architecture Behavioral of Xbar_merge is
    component C_element_LUT is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           reset : in STD_LOGIC;
           y : out STD_LOGIC);
    end component;
    signal data_or_x, data_or_y, data_or_z, data_or_w : STD_LOGIC_VECTOR (16 downto 0);
    signal data_and_left_x, data_and_left_y, data_and_left_z, data_and_left_w : std_logic;
    signal data_and_right_x, data_and_right_y, data_and_right_z, data_and_right_w : std_logic;
    signal ack_out_x, ack_out_y, ack_out_z, ack_out_w : STD_LOGIC;
    signal no_reset : STD_LOGIC:= '1';
begin

    process(Data_x, Data_y, Data_z, Data_w, data_or_x, data_or_y, data_or_z, data_or_w) is
    begin
        
        data_or_x(16) <= or_reduce(Data_x.phit);
        data_or_y(16) <= or_reduce(Data_y.phit);
        data_or_z(16) <= or_reduce(Data_z.phit);
        data_or_w(16) <= or_reduce(Data_w.phit);
        for i in 0 to 15 loop
            data_or_x(i) <= Data_x.w00(i) OR Data_x.w01(i) OR Data_x.w10(i) OR Data_x.w11(i);
            data_or_y(i) <= Data_y.w00(i) OR Data_y.w01(i) OR Data_y.w10(i) OR Data_y.w11(i);
            data_or_z(i) <= Data_z.w00(i) OR Data_z.w01(i) OR Data_z.w10(i) OR Data_z.w11(i);
            data_or_z(i) <= Data_w.w00(i) OR Data_w.w01(i) OR Data_w.w10(i) OR Data_w.w11(i);
        end loop;
        
        data_and_left_x     <= and_reduce(data_or_x);
        data_and_right_x    <= or_reduce(data_or_x);
        data_and_left_y     <= and_reduce(data_or_y);
        data_and_right_y    <= or_reduce(data_or_y); 
        data_and_left_z     <= and_reduce(data_or_z);
        data_and_right_z    <= or_reduce(data_or_z); 
        data_and_left_w     <= and_reduce(data_or_w);
        data_and_right_w    <= or_reduce(data_or_w);
        
        data_out.phit <= Data_x.phit OR Data_y.phit OR Data_z.phit OR Data_w.phit;
        for i in 0 to 15 loop
            data_out.w00(i) <= Data_x.w00(i) OR Data_y.w00(i) OR Data_z.w00(i) OR Data_w.w00(i);
            data_out.w01(i) <= Data_x.w01(i) OR Data_y.w01(i) OR Data_z.w01(i) OR Data_w.w01(i);
            data_out.w10(i) <= Data_x.w10(i) OR Data_y.w10(i) OR Data_z.w10(i) OR Data_w.w10(i);
            data_out.w11(i) <= Data_x.w11(i) OR Data_y.w11(i) OR Data_z.w11(i) OR Data_w.w11(i);
        end loop;

    end process;
    -- C elements for completion detection
    cElement_ack_x_low : C_element_LUT 
                    port map(a => data_and_left_x,
                             b => data_and_right_x,
                             reset => reset,
                             y => ack_out_x);
    cElement_ack_y_low : C_element_LUT 
                    port map(a => data_and_left_y,
                             b => data_and_right_y,
                             reset => reset,
                             y => ack_out_y);
    cElement_ack_z_low : C_element_LUT 
                    port map(a => data_and_left_z,
                             b => data_and_right_z,
                             reset => reset,
                             y => ack_out_z);
    cElement_ack_w_low : C_element_LUT 
                    port map(a => data_and_left_w,
                             b => data_and_right_w,
                             reset => reset,
                             y => ack_out_w);
     -- Final c elements before ack out                        
    cElement_ack_x : C_element_LUT 
                    port map(a => ack_out_x,
                             b => Ack_in,
                             reset => reset,
                             y => Ack_x);
    cElement_ack_y : C_element_LUT 
                    port map(a => ack_out_y,
                             b => Ack_in,
                             reset => reset,
                             y => Ack_y);
    cElement_ack_z : C_element_LUT 
                    port map(a => ack_out_z,
                             b => Ack_in,
                             reset => reset,
                             y => Ack_z);
    cElement_ack_w : C_element_LUT 
                    port map(a => ack_out_w,
                             b => Ack_in,
                             reset => reset,
                             y => Ack_w);                                                                                            
    

end Behavioral;

