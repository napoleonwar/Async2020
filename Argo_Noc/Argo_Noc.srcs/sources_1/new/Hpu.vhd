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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Hpu is
    Port ( data_in : in data_encode;
           data_out : out data_encode;
           route_select : out sele;
           ack_in : in STD_LOGIC;
           ack_out : out STD_LOGIC);
end Hpu;

architecture Behavioral of Hpu is
component  Mux is
    Port ( x : in data_encode; -- 0
           y : in data_encode; -- 1
           ctl : in ctrl;
           z : out data_encode;
           z_ack : in std_logic;
           x_ack : out std_logic;
           y_ack : out std_logic;
           ctl_ack : out std_logic
           );
end component;
component C_element is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           y : out STD_LOGIC);
end component;
    signal VLD : ctrl ;
    signal SOP : ctrl ;
    signal EOP : ctrl ;
    
    signal data_payload : data_encode;
    signal data_header  : data_encode;
    signal data_sele    : sele;
    signal data_out_mux : data_encode;
    
    signal ack_merge_x : std_logic;
    signal ack_merge_y : std_logic;
    signal ctl_ack     : std_logic;
    signal ack2mux     : std_logic;
    signal ack2merge   : std_logic;
    signal ack_and1    : std_logic;
    signal ack_and2    : std_logic;
    signal ack_and3    : std_logic;
    
begin
    data_payload  <= data_in;
    data_header.t <= data_in.t(34 downto 15) & "00" & data_in.t(13 downto 2);
    data_header.f <= data_in.f(34 downto 15) & "11" & data_in.f(13 downto 2);
    data_sele.t   <= data_in.t(1 downto 0);
    data_sele.f   <= data_in.f(1 downto 0);
    route_select  <= data_sele;
    data_out      <= data_out_mux;
    VLD.t <= data_in.t(34);
    VLD.f <= data_in.f(34);
    SOP.t <= data_in.t(33);
    SOP.f <= data_in.f(33);
    EOP.t <= data_in.t(32);
    EOP.f <= data_in.f(32);
    ack2mux   <= ack_in;
    ack2merge <= ack_in;
    ack_out   <= ctl_ack and ack_merge_x and ack_merge_y and ack2merge;
ackout1: C_element port map (a=>ctl_ack,b=>ack_merge_x,y=>ack_and1);
ackout2: C_element port map (a=>ack_merge_y,b=>ack2merge,y=>ack_and2);
ackout3: C_element port map (a=>ack_and1,b=>ack_and2,y=>ack_out);
     
MUX_HPU : MUX port map (x=>data_payload,y=>data_header,z=>data_out_mux,ctl => SOP,z_ack =>ack_in,x_ack =>ack_merge_x,
                    y_ack=>ack_merge_y,ctl_ack=>ctl_ack);
    

end Behavioral;
