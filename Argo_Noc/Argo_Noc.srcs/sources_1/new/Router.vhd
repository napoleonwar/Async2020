----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2020 10:00:52
-- Design Name: 
-- Module Name: Router - Structural
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

entity Router is
    Port ( L_Data_in : in channel_forward;
           N_Data_in : in channel_forward;
           E_Data_in : in channel_forward;
           S_Data_in : in channel_forward;
           W_Data_in : in channel_forward;
           L_Ack_in  : in STD_LOGIC;
           N_Ack_in  : in STD_LOGIC;
           E_Ack_in  : in STD_LOGIC;
           S_Ack_in  : in STD_LOGIC;
           W_Ack_in  : in STD_LOGIC;
           
           L_Data_out : out channel_forward;
           N_Data_out : out channel_forward;
           E_Data_out : out channel_forward;
           S_Data_out : out channel_forward;
           W_Data_out : out channel_forward;
           L_Ack_out  : out STD_LOGIC;
           N_Ack_out  : out STD_LOGIC;
           E_Ack_out  : out STD_LOGIC;
           S_Ack_out  : out STD_LOGIC;
           W_Ack_out  : out STD_LOGIC);
           
end Router;
----------------------------------------------------------------------------------
architecture Structural of Router is
    component encoder
    port (  data_in : in STD_LOGIC_VECTOR (31 downto 0);
            data_out : out encoded_data);
    end component;
    
    component PhitEncoder
    port (  data_in : in STD_LOGIC_VECTOR (2 downto 0);
            data_out : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    component channel_latch
    Port ( data_in : in channel_forward;
           ack_in_chl : in STD_LOGIC;
           data_out : out channel_forward;
           ack_out_chl : out STD_LOGIC);
    end component;
    
    component Hpu is
    Port ( data_in      : in channel_forward;
           data_out     : out full_channel_forward;
           ack_in       : in STD_LOGIC;
           ack_out      : out STD_LOGIC);
    end component;
    
    component HPU_latch is
    Port ( data_in : in full_channel_forward;
           ack_in_chl : in STD_LOGIC;
           data_out : out full_channel_forward;
           ack_out_chl : out STD_LOGIC);
    end component;
    
    component CrossBar is
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
     end component;
    
    signal L_encoded_data,    N_encoded_data,    E_encoded_data,    S_encoded_data,    W_encoded_data    : encoded_data;
    signal L_encoded_phit,    N_encoded_phit,    E_encoded_phit,    S_encoded_phit,    W_encoded_phit    : STD_LOGIC_VECTOR (3 downto 0);
    signal L_channel_forward, N_channel_forward, E_channel_forward, S_channel_forward, W_channel_forward : channel_forward;
    signal L_channel_forward_CL, N_channel_forward_CL, E_channel_forward_CL, S_channel_forward_CL, W_channel_forward_CL : channel_forward;
    signal L_Ack_toCL, N_Ack_toCL, E_Ack_toCL, S_Ack_toCL, W_Ack_toCL : STD_LOGIC;
    signal L_channel_forward_HPU, N_channel_forward_HPU, E_channel_forward_HPU, S_channel_forward_HPU, W_channel_forward_HPU : full_channel_forward;
    signal L_Ack_toHPU, N_Ack_toHPU, E_Ack_toHPU, S_Ack_toHPU, W_Ack_toHPU : STD_LOGIC;
    signal L_channel_forward_HPU_CL, N_channel_forward_HPU_CL, E_channel_forward_HPU_CL, S_channel_forward_HPU_CL, W_channel_forward_HPU_CL : full_channel_forward;
    signal L_Ack_toHPU_CL, N_Ack_toHPU_CL, E_Ack_toHPU_CL, S_Ack_toHPU_CL, W_Ack_toHPU_CL : STD_LOGIC;
    signal L_channel_forward_Xbar, N_channel_forward_Xbar, E_channel_forward_Xbar, S_channel_forward_Xbar, W_channel_forward_Xbar : channel_forward;
    signal L_Ack_toXbar, N_Ack_toXbar, E_Ack_toXbar, S_Ack_toXbar, W_Ack_toXbar : STD_LOGIC;

begin
--------------------------------L CHANNEL-------------------------------------------------- 
    L_Channel_Latch_in : channel_latch port map(data_in => L_data_in, ack_in_chl =>  L_Ack_toCL,
                                                data_out => L_channel_forward_CL, ack_out_chl => L_Ack_out);
                            
    L_HPU : Hpu port map(data_in => L_channel_forward_CL, ack_in =>  L_Ack_toHPU,
                         data_out => L_channel_forward_HPU, ack_out => L_Ack_toCL);
   
    L_HPU_Latch : HPU_latch port map(data_in => L_channel_forward_HPU, ack_in_chl =>  L_Ack_toHPU_CL,
                                     data_out => L_channel_forward_HPU_CL, ack_out_chl => L_Ack_toHPU);

    L_Channel_Latch_out : channel_latch port map(data_in => L_channel_forward_Xbar, ack_in_chl =>  L_Ack_in,
                                                 data_out => L_Data_out, ack_out_chl => L_Ack_toXbar);
----------------------------------------------------------------------------------
 --------------------------------N CHANNEL--------------------------------------------------
    N_Channel_Latch_in : channel_latch port map(data_in => N_data_in, ack_in_chl =>  N_Ack_toCL,
                                                data_out => N_channel_forward_CL, ack_out_chl => N_Ack_out);
                            
    N_HPU : Hpu port map(data_in => N_channel_forward_CL, ack_in =>  N_Ack_toHPU,
                         data_out => N_channel_forward_HPU, ack_out => N_Ack_toCL);
   
    N_HPU_Latch : HPU_latch port map(data_in => N_channel_forward_HPU, ack_in_chl =>  N_Ack_toHPU_CL,
                                     data_out => N_channel_forward_HPU_CL, ack_out_chl => N_Ack_toHPU);

    N_Channel_Latch_out : channel_latch port map(data_in => N_channel_forward_Xbar, ack_in_chl =>  N_Ack_in,
                                                 data_out => N_Data_out, ack_out_chl => N_Ack_toXbar);
----------------------------------------------------------------------------------
--------------------------------E CHANNEL--------------------------------------------------
    E_Channel_Latch_in : channel_latch port map(data_in => E_data_in, ack_in_chl =>  E_Ack_toCL,
                                                data_out => E_channel_forward_CL, ack_out_chl => E_Ack_out);
                            
    E_HPU : Hpu port map(data_in => E_channel_forward_CL, ack_in =>  E_Ack_toHPU,
                         data_out => E_channel_forward_HPU, ack_out => E_Ack_toCL);
   
    E_HPU_Latch : HPU_latch port map(data_in => E_channel_forward_HPU, ack_in_chl =>  E_Ack_toHPU_CL,
                                     data_out => E_channel_forward_HPU_CL, ack_out_chl => E_Ack_toHPU);

    E_Channel_Latch_out : channel_latch port map(data_in => E_channel_forward_Xbar, ack_in_chl =>  E_Ack_in,
                                                 data_out => E_Data_out, ack_out_chl => E_Ack_toXbar);
----------------------------------------------------------------------------------
--------------------------------S CHANNEL--------------------------------------------------
    S_Channel_Latch_in : channel_latch port map(data_in => S_data_in, ack_in_chl =>  S_Ack_toCL,
                                                data_out => S_channel_forward_CL, ack_out_chl => S_Ack_out);
                            
    S_HPU : Hpu port map(data_in => S_channel_forward_CL, ack_in =>  S_Ack_toHPU,
                         data_out => S_channel_forward_HPU, ack_out => S_Ack_toCL);
   
    S_HPU_Latch : HPU_latch port map(data_in => S_channel_forward_HPU, ack_in_chl =>  S_Ack_toHPU_CL,
                                     data_out => S_channel_forward_HPU_CL, ack_out_chl => S_Ack_toHPU);

    S_Channel_Latch_out : channel_latch port map(data_in => S_channel_forward_Xbar, ack_in_chl =>  S_Ack_in,
                                                 data_out => S_Data_out, ack_out_chl => S_Ack_toXbar);
----------------------------------------------------------------------------------
--------------------------------W CHANNEL-------------------------------------------------- 
    W_Channel_Latch_in : channel_latch port map(data_in => W_data_in, ack_in_chl =>  W_Ack_toCL,
                                                data_out => W_channel_forward_CL, ack_out_chl => W_Ack_out);
                            
    W_HPU : Hpu port map(data_in => W_channel_forward_CL, ack_in =>  W_Ack_toHPU,
                         data_out => W_channel_forward_HPU, ack_out => W_Ack_toCL);
   
    W_HPU_Latch : HPU_latch port map(data_in => W_channel_forward_HPU, ack_in_chl =>  W_Ack_toHPU_CL,
                                     data_out => W_channel_forward_HPU_CL, ack_out_chl => W_Ack_toHPU);

    W_Channel_Latch_out : channel_latch port map(data_in => W_channel_forward_Xbar, ack_in_chl =>  W_Ack_in,
                                                 data_out => W_Data_out, ack_out_chl => W_Ack_toXbar);
----------------------------------------------------------------------------------
------------------------------------CROSS BAR----------------------------------------------
    Cross_Bar : CrossBar port map(L_Data_in => L_channel_forward_HPU_CL, N_Data_in => N_channel_forward_HPU_CL,
                                  E_Data_in => E_channel_forward_HPU_CL, S_Data_in => S_channel_forward_HPU_CL,
                                  W_Data_in => W_channel_forward_HPU_CL, L_Ack_in => L_Ack_toXbar,
                                  N_Ack_in => N_Ack_toXbar, E_Ack_in => E_Ack_toXbar, S_Ack_in => S_Ack_toXbar,
                                  W_Ack_in => W_Ack_toXbar, L_Data_out => L_channel_forward_Xbar,
                                  N_Data_out => N_channel_forward_Xbar, E_Data_out => E_channel_forward_Xbar,
                                  S_Data_out => S_channel_forward_Xbar, W_Data_out => W_channel_forward_Xbar,
                                  L_Ack_out => L_Ack_toHPU_CL, N_Ack_out => N_Ack_toHPU_CL, E_Ack_out => E_Ack_toHPU_CL, 
                                  S_Ack_out => S_Ack_toHPU_CL, W_Ack_out => W_Ack_toHPU_CL);
end Structural;
