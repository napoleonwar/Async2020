----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.05.2020 20:24:43
-- Design Name: 
-- Module Name: CrossBar - Behavioral
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

entity CrossBar is
    Port ( L_Data_in    : in full_channel_forward;
           N_Data_in    : in full_channel_forward;
           E_Data_in    : in full_channel_forward;
           S_Data_in    : in full_channel_forward;
           W_Data_in    : in full_channel_forward;
           L_Ack_in    : in STD_LOGIC;
           N_Ack_in     : in STD_LOGIC;
           E_Ack_in     : in STD_LOGIC;
           S_Ack_in     : in STD_LOGIC;
           W_Ack_in     : in STD_LOGIC;
           
           L_Data_out : out channel_forward;
           N_Data_out : out channel_forward;
           E_Data_out : out channel_forward;
           S_Data_out : out channel_forward;
           W_Data_out : out channel_forward;
           L_Ack_out : out STD_LOGIC;
           N_Ack_out : out STD_LOGIC;
           E_Ack_out : out STD_LOGIC;
           S_Ack_out : out STD_LOGIC;
           W_Ack_out : out STD_LOGIC);
end CrossBar;
----------------------------------------------------------------------------------
architecture Behavioral of CrossBar is

    component Xbar_fork
    port(   Data_in : in full_channel_forward;
            Ack_x   : in STD_LOGIC;
            Ack_y   : in STD_LOGIC;
            Ack_z   : in STD_LOGIC;
            Data_x  : out STD_LOGIC_VECTOR (3 downto 0); -- write/read enable
            Data_y  : out STD_LOGIC_VECTOR (3 downto 0); -- SEL (routing)
            Data_z  : out channel_forward; -- Data for Demux
            Ack_out : out STD_LOGIC);
    end component;
    
    component memory
    port(   Wen      : in STD_LOGIC;
            Ren      : in STD_LOGIC;
            Data_in  : in STD_LOGIC_VECTOR (3 downto 0);
            ack_in   : in STD_LOGIC;
            Data_out : out STD_LOGIC_VECTOR (3 downto 0);
            ack_out  : out STD_LOGIC;
            ack_ctl  : out STD_LOGIC);
    end component;
    
    component Demux
    port(  Data_in  : in channel_forward;
           Ctl      : in STD_LOGIC_vector (3 downto 0);
           ack_in   : in STD_LOGIC;
           Data_x   : out channel_forward;
           Data_y   : out channel_forward;
           Data_z   : out channel_forward;
           Data_w   : out channel_forward;
           ack_ctl  : out STD_LOGIC;
           ack_out  : out STD_LOGIC);
    end component;
    
    component Xbar_merge
    port(  Data_x   : in channel_forward;
           Data_y   : in channel_forward;
           Data_z   : in channel_forward;
           Data_w   : in channel_forward;
           Ack_in   : in STD_LOGIC;
           Data_out : out channel_forward;
           Ack_x    : out STD_LOGIC;
           Ack_y    : out STD_LOGIC;
           Ack_z    : out STD_LOGIC;
           Ack_w    : out STD_LOGIC);
    end component;
    
    signal L_Data_x_fork, N_Data_x_fork, E_Data_x_fork, S_Data_x_fork, W_Data_x_fork : STD_LOGIC_VECTOR (3 downto 0);
    
    signal L_Wen_mem, N_Wen_mem, E_Wen_mem, S_Wen_mem, W_Wen_mem : STD_LOGIC;
    signal L_Ren_mem, N_Ren_mem, E_Ren_mem, S_Ren_mem, W_Ren_mem : STD_LOGIC;
    signal L_Data_in_mem, N_Data_in_mem, E_Data_in_mem, S_Data_in_mem, W_Data_in_mem        : STD_LOGIC_VECTOR (3 downto 0);
    signal L_Data_out_mem, N_Data_out_mem, E_Data_out_mem, S_Data_out_mem, W_Data_out_mem   : STD_LOGIC_VECTOR (3 downto 0);
    signal L_Ack_ctl_mem, N_Ack_ctl_mem, E_Ack_ctl_mem, S_Ack_ctl_mem, W_Ack_ctl_mem        : STD_LOGIC;
    signal L_Ack_in_mem, N_Ack_in_mem, E_Ack_in_mem, S_Ack_in_mem, W_Ack_in_mem             : STD_LOGIC;
    signal L_Ack_out_mem, N_Ack_out_mem, E_Ack_out_mem, S_Ack_out_mem, W_Ack_out_mem        : STD_LOGIC;
    
    signal L_Data_in_Demux, N_Data_in_Demux, E_Data_in_Demux, S_Data_in_Demux, W_Data_in_Demux  : channel_forward;
    signal L_Data_N_Demux, N_Data_N_Demux, E_Data_N_Demux, S_Data_N_Demux, W_Data_N_Demux       : channel_forward;
    signal L_Data_E_Demux, N_Data_E_Demux, E_Data_E_Demux, S_Data_E_Demux, W_Data_E_Demux       : channel_forward;
    signal L_Data_S_Demux, N_Data_S_Demux, E_Data_S_Demux, S_Data_S_Demux, W_Data_S_Demux       : channel_forward;
    signal L_Data_W_Demux, N_Data_W_Demux, E_Data_W_Demux, S_Data_W_Demux, W_Data_W_Demux       : channel_forward;
    signal L_Ack_out_Demux, N_Ack_out_Demux, E_Ack_out_Demux, S_Ack_out_Demux, W_Ack_out_Demux  : STD_LOGIC;
    signal L_Ack_in_Demux, N_Ack_in_Demux, E_Ack_in_Demux, S_Ack_in_Demux, W_Ack_in_Demux       : STD_LOGIC;
    
    signal L_Ack_x_Merge, N_Ack_x_Merge, E_Ack_x_Merge, S_Ack_x_Merge, W_Ack_x_Merge : STD_LOGIC;
    signal L_Ack_y_Merge, N_Ack_y_Merge, E_Ack_y_Merge, S_Ack_y_Merge, W_Ack_y_Merge : STD_LOGIC;
    signal L_Ack_z_Merge, N_Ack_z_Merge, E_Ack_z_Merge, S_Ack_z_Merge, W_Ack_z_Merge : STD_LOGIC;
    signal L_Ack_w_Merge, N_Ack_w_Merge, E_Ack_w_Merge, S_Ack_w_Merge, W_Ack_w_Merge : STD_LOGIC;
begin
--------------------------------------LOCAL CHANNEL------------------------------------------
    L_fork : Xbar_fork
        port map(Data_in => L_Data_in, Ack_x => L_Ack_ctl_mem, Ack_y => L_Ack_out_mem,
                 Ack_z => L_Ack_out_Demux, Data_x => L_Data_x_fork, Data_y => L_Data_in_mem,
                 Data_z => L_Data_in_Demux, Ack_out => L_Ack_out);
                 
    L_Wen_mem <= L_Data_x_fork(3);
    L_Ren_mem <= L_Data_x_fork(2) OR L_Data_x_fork(1) OR L_Data_x_fork(0);
    
    L_mem : memory
        port map(Wen => L_Wen_mem, Ren => L_Ren_mem, Data_in => L_Data_in_mem, ack_in => L_Ack_in_mem,
                 Data_out => L_Data_out_mem, ack_out => L_Ack_out_mem, ack_ctl => L_Ack_ctl_mem);
    
    L_demux : Demux
        port map (Data_in => L_Data_in_Demux, Ctl => L_Data_out_mem, ack_in => L_Ack_in_Demux,
                  Data_x => L_Data_N_Demux, Data_y => L_Data_E_Demux , Data_z => L_Data_S_Demux,
                  Data_w => L_Data_W_Demux, ack_ctl => L_Ack_in_mem, ack_out => L_Ack_out_Demux);
    
    L_Ack_in_Demux <= N_Ack_x_Merge OR E_Ack_y_Merge OR S_Ack_z_Merge OR W_Ack_w_Merge;
    
    L_merge : Xbar_merge
        port map (Data_x => N_Data_N_Demux, Data_y => E_Data_E_Demux , Data_z => S_Data_S_Demux,
                  Data_w => W_Data_W_Demux, Ack_in => L_Ack_in, Data_out => L_Data_out,
                  Ack_x => L_Ack_x_Merge, Ack_y => L_Ack_y_Merge, Ack_z => L_Ack_z_Merge, Ack_w => L_Ack_w_Merge);
-----------------------------------------------------------------------------------------------    
--------------------------------------NORTH CHANNEL------------------------------------------
    N_fork : Xbar_fork
        port map(Data_in => N_Data_in, Ack_x => N_Ack_ctl_mem, Ack_y => N_Ack_out_mem,
                 Ack_z => N_Ack_out_Demux, Data_x => N_Data_x_fork, Data_y => N_Data_in_mem,
                 Data_z => N_Data_in_Demux, Ack_out => N_Ack_out);
                 
    N_Wen_mem <= N_Data_x_fork(3);
    N_Ren_mem <= N_Data_x_fork(2) OR N_Data_x_fork(1) OR N_Data_x_fork(0);
    
    N_mem : memory
        port map(Wen => N_Wen_mem, Ren => N_Ren_mem, Data_in => N_Data_in_mem, ack_in => N_Ack_in_mem,
                 Data_out => N_Data_out_mem, ack_out => N_Ack_out_mem, ack_ctl => N_Ack_ctl_mem);
    
    N_demux : Demux
        port map (Data_in => N_Data_in_Demux, Ctl => N_Data_out_mem, ack_in => N_Ack_in_Demux,
                  Data_x => N_Data_N_Demux, Data_y => N_Data_E_Demux , Data_z => N_Data_S_Demux,
                  Data_w => N_Data_W_Demux, ack_ctl => N_Ack_in_mem, ack_out => N_Ack_out_Demux);
    
    N_Ack_in_Demux <= L_Ack_x_Merge OR E_Ack_x_Merge OR S_Ack_x_Merge OR W_Ack_x_Merge;
    
    N_merge : Xbar_merge
        port map (Data_x => L_Data_N_Demux, Data_y => E_Data_N_Demux , Data_z => S_Data_N_Demux,
                  Data_w => W_Data_N_Demux, Ack_in => N_Ack_in, Data_out => N_Data_out,
                  Ack_x => N_Ack_x_Merge, Ack_y => N_Ack_y_Merge, Ack_z => N_Ack_z_Merge, Ack_w => N_Ack_w_Merge);
-----------------------------------------------------------------------------------------------    
--------------------------------------EAST CHANNEL------------------------------------------
    E_fork : Xbar_fork
        port map(Data_in => E_Data_in, Ack_x => E_Ack_ctl_mem, Ack_y => E_Ack_out_mem,
                 Ack_z => E_Ack_out_Demux, Data_x => E_Data_x_fork, Data_y => E_Data_in_mem,
                 Data_z => E_Data_in_Demux, Ack_out => E_Ack_out);
                 
    E_Wen_mem <= E_Data_x_fork(3);
    E_Ren_mem <= E_Data_x_fork(2) OR E_Data_x_fork(1) OR E_Data_x_fork(0);
    
    E_mem : memory
        port map(Wen => E_Wen_mem, Ren => E_Ren_mem, Data_in => E_Data_in_mem, ack_in => E_Ack_in_mem,
                 Data_out => E_Data_out_mem, ack_out => E_Ack_out_mem, ack_ctl => E_Ack_ctl_mem);
    
    E_demux : Demux
        port map (Data_in => E_Data_in_Demux, Ctl => E_Data_out_mem, ack_in => E_Ack_in_Demux,
                  Data_x => E_Data_N_Demux, Data_y => E_Data_E_Demux , Data_z => E_Data_S_Demux,
                  Data_w => E_Data_W_Demux, ack_ctl => E_Ack_in_mem, ack_out => E_Ack_out_Demux);
    
    E_Ack_in_Demux <= L_Ack_y_Merge OR N_Ack_y_Merge OR S_Ack_y_Merge OR W_Ack_y_Merge;
    
    E_merge : Xbar_merge
        port map (Data_x => N_Data_E_Demux, Data_y => L_Data_E_Demux , Data_z => S_Data_E_Demux,
                  Data_w => W_Data_E_Demux, Ack_in => E_Ack_in, Data_out => E_Data_out,
                  Ack_x => E_Ack_x_Merge, Ack_y => E_Ack_y_Merge, Ack_z => E_Ack_z_Merge, Ack_w => E_Ack_w_Merge);
-----------------------------------------------------------------------------------------------    
--------------------------------------SOUTH CHANNEL------------------------------------------
    S_fork : Xbar_fork
        port map(Data_in => S_Data_in, Ack_x => S_Ack_ctl_mem, Ack_y => S_Ack_out_mem,
                 Ack_z => S_Ack_out_Demux, Data_x => S_Data_x_fork, Data_y => S_Data_in_mem,
                 Data_z => S_Data_in_Demux, Ack_out => S_Ack_out);
                 
    S_Wen_mem <= S_Data_x_fork(3);
    S_Ren_mem <= S_Data_x_fork(2) OR S_Data_x_fork(1) OR S_Data_x_fork(0);
    
    S_mem : memory
        port map(Wen => S_Wen_mem, Ren => S_Ren_mem, Data_in => S_Data_in_mem, ack_in => S_Ack_in_mem,
                 Data_out => S_Data_out_mem, ack_out => S_Ack_out_mem, ack_ctl => S_Ack_ctl_mem);
    
    S_demux : Demux
        port map (Data_in => S_Data_in_Demux, Ctl => S_Data_out_mem, ack_in => S_Ack_in_Demux,
                  Data_x => S_Data_N_Demux, Data_y => S_Data_E_Demux , Data_z => S_Data_S_Demux,
                  Data_w => S_Data_W_Demux, ack_ctl => S_Ack_in_mem, ack_out => S_Ack_out_Demux);
    
    S_Ack_in_Demux <= L_Ack_z_Merge OR N_Ack_z_Merge OR E_Ack_z_Merge OR W_Ack_z_Merge;
    
    S_merge : Xbar_merge
        port map (Data_x => L_Data_S_Demux, Data_y => N_Data_S_Demux , Data_z => E_Data_S_Demux,
                  Data_w => W_Data_S_Demux, Ack_in => S_Ack_in, Data_out => S_Data_out,
                  Ack_x => S_Ack_x_Merge, Ack_y => S_Ack_y_Merge, Ack_z => S_Ack_z_Merge, Ack_w => S_Ack_w_Merge);
-----------------------------------------------------------------------------------------------    
--------------------------------------WEST CHANNEL------------------------------------------
    W_fork : Xbar_fork
        port map(Data_in => W_Data_in, Ack_x => W_Ack_ctl_mem, Ack_y => W_Ack_out_mem,
                 Ack_z => W_Ack_out_Demux, Data_x => W_Data_x_fork, Data_y => W_Data_in_mem,
                 Data_z => W_Data_in_Demux, Ack_out => W_Ack_out);
                 
    W_Wen_mem <= W_Data_x_fork(3);
    W_Ren_mem <= W_Data_x_fork(2) OR W_Data_x_fork(1) OR W_Data_x_fork(0);
    
    W_mem : memory
        port map(Wen => W_Wen_mem, Ren => W_Ren_mem, Data_in => W_Data_in_mem, ack_in => W_Ack_in_mem,
                 Data_out => W_Data_out_mem, ack_out => W_Ack_out_mem, ack_ctl => W_Ack_ctl_mem);
    
    W_demux : Demux
        port map (Data_in => W_Data_in_Demux, Ctl => W_Data_out_mem, ack_in => W_Ack_in_Demux,
                  Data_x => W_Data_N_Demux, Data_y => W_Data_E_Demux , Data_z => W_Data_S_Demux,
                  Data_w => W_Data_W_Demux, ack_ctl => W_Ack_in_mem, ack_out => W_Ack_out_Demux);
    
    W_Ack_in_Demux <= L_Ack_w_Merge OR N_Ack_w_Merge OR E_Ack_w_Merge OR S_Ack_w_Merge;
    
    W_merge : Xbar_merge
        port map (Data_x => L_Data_W_Demux, Data_y => N_Data_W_Demux , Data_z => E_Data_W_Demux,
                  Data_w => S_Data_W_Demux, Ack_in => W_Ack_in, Data_out => W_Data_out,
                  Ack_x => W_Ack_x_Merge, Ack_y => W_Ack_y_Merge, Ack_z => W_Ack_z_Merge, Ack_w => W_Ack_w_Merge);
-----------------------------------------------------------------------------------------------    

end Behavioral;
