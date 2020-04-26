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
           ack_in : in STD_LOGIC;
           ack_out : out STD_LOGIC);
end Hpu;

architecture Behavioral of Hpu is
component  Mux is
    Port ( x : in data_encode;
           y : in data_encode;
           ctl : in ctrl;
           z : out data_encode;
           z_ack : in std_logic;
           x_ack : out std_logic;
           y_ack : out std_logic;
           ctl_ack : out std_logic
           );
end component;
    signal VLD : ctrl ;
    signal SOP : ctrl ;
    signal EOP : ctrl ;
    
    signal data_shiftRoute : data_encode;
    signal ack_merge_x : std_logic;
    signal ack_merge_y : std_logic;
    signal sele : std_logic;
begin
MUX_HPU : MUX port map (x=>data_in,y=>data_shiftRoute,ctl => SOP,z_ack =>ack_in,x_ack =>ack_merge_x,
                    y_ack=>ack_merge_y,ctl_ack=>sele);

 PHIT_TYPE: block
    begin
    process(data_in)
    begin
--            IF data_in.t(34) = '1' then
--                VLD <= '1';
--            ELSE IF data_in.f(34) = '1' then 
--                VLD <= '0';
--                END IF;
--            END IF;
            
--            IF data_in.t(33) = '1' then
--                SOP <= '1';
--            ELSE IF data_in.f(33) = '1' then 
--                SOP <= '0';
--                END IF;
--            END IF;
            
--            IF data_in.t(32) = '1' then
--                EOP <= '1';
--            ELSE IF data_in.f(32) = '1' then 
--                EOP <= '0';
--                END IF;
--            END IF;
    end process;
    END block PHIT_TYPE;
end Behavioral;
