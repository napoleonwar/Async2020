-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.define_type.all;

entity tb_router is
end tb_router;
-----------------------------------------------------------------------------------------
architecture Behavioral of tb_router is
    Component Router
    Port(  L_Data_in : in channel_forward;
           N_Data_in : in channel_forward;
           E_Data_in : in channel_forward;
           S_Data_in : in channel_forward;
           W_Data_in : in channel_forward;
           L_Ack_in  : in STD_LOGIC;
           N_Ack_in  : in STD_LOGIC;
           E_Ack_in  : in STD_LOGIC;
           S_Ack_in  : in STD_LOGIC;
           W_Ack_in  : in STD_LOGIC;
           reset: in STD_LOGIC;
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
    end component;
   --In 
   signal L_Data_in :  channel_forward;  
   signal N_Data_in :  channel_forward;  
   signal E_Data_in :  channel_forward;  
   signal S_Data_in :  channel_forward;  
   signal W_Data_in :  channel_forward;  
   signal L_Ack_in  :  STD_LOGIC;        
   signal N_Ack_in  :  STD_LOGIC;        
   signal E_Ack_in  :  STD_LOGIC;        
   signal S_Ack_in  :  STD_LOGIC;        
   signal W_Ack_in  :  STD_LOGIC;
   signal reset: STD_LOGIC;
   --Out        
   signal L_Data_out :  channel_forward;
   signal N_Data_out :  channel_forward;
   signal E_Data_out :  channel_forward;
   signal S_Data_out :  channel_forward;
   signal W_Data_out :  channel_forward;
   signal L_Ack_out  :  STD_LOGIC;      
   signal N_Ack_out  :  STD_LOGIC;      
   signal E_Ack_out  :  STD_LOGIC;      
   signal S_Ack_out  :  STD_LOGIC;      
   signal W_Ack_out  :  STD_LOGIC;
   
   Component encoder
   port(   data_in : in STD_LOGIC_VECTOR (31 downto 0);
           Empty : in std_logic;
           data_out : out encoded_data);
   end component;
   
   signal L_Data_in_encoder : STD_LOGIC_VECTOR (31 downto 0);  
   signal N_Data_in_encoder : STD_LOGIC_VECTOR (31 downto 0);  
   signal E_Data_in_encoder : STD_LOGIC_VECTOR (31 downto 0);  
   signal S_Data_in_encoder : STD_LOGIC_VECTOR (31 downto 0);  
   signal W_Data_in_encoder : STD_LOGIC_VECTOR (31 downto 0);
   signal L_Data_out_encoder : encoded_data;
   signal N_Data_out_encoder : encoded_data;
   signal E_Data_out_encoder : encoded_data;
   signal S_Data_out_encoder : encoded_data;
   signal W_Data_out_encoder : encoded_data;
   signal L_Empty_encoder1 : STD_LOGIC;
   signal N_Empty_encoder1 : STD_LOGIC;
   signal E_Empty_encoder1 : STD_LOGIC;
   signal S_Empty_encoder1 : STD_LOGIC;
   signal W_Empty_encoder1 : STD_LOGIC; 
   
   Component PhitEncoder
   port(   data_in : in STD_LOGIC_VECTOR (2 downto 0);
           Empty : in std_logic;
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
   end component;
   
   signal L_phit_in_encoder : STD_LOGIC_VECTOR (2 downto 0);  
   signal N_phit_in_encoder : STD_LOGIC_VECTOR (2 downto 0);  
   signal E_phit_in_encoder : STD_LOGIC_VECTOR (2 downto 0);  
   signal S_phit_in_encoder : STD_LOGIC_VECTOR (2 downto 0);  
   signal W_phit_in_encoder : STD_LOGIC_VECTOR (2 downto 0);
   signal L_phit_out_encoder : STD_LOGIC_VECTOR (3 downto 0);
   signal N_phit_out_encoder : STD_LOGIC_VECTOR (3 downto 0);
   signal E_phit_out_encoder : STD_LOGIC_VECTOR (3 downto 0);
   signal S_phit_out_encoder : STD_LOGIC_VECTOR (3 downto 0);
   signal W_phit_out_encoder : STD_LOGIC_VECTOR (3 downto 0);
   signal L_Empty_encoder2 : STD_LOGIC; 
   signal N_Empty_encoder2 : STD_LOGIC; 
   signal E_Empty_encoder2 : STD_LOGIC; 
   signal S_Empty_encoder2 : STD_LOGIC; 
   signal W_Empty_encoder2 : STD_LOGIC;
   
   Component decoder
   Port(data_in : in channel_forward;               
        phit_out : out std_logic_vector(2 downto 0);
        data_out : out std_logic_vector(31 downto 0);
        empty : out std_logic
        ); 
   end component;
   
   Signal L_phit_out_deco : std_logic_vector(2 downto 0);
   Signal N_phit_out_deco : std_logic_vector(2 downto 0);
   Signal E_phit_out_deco : std_logic_vector(2 downto 0);
   Signal S_phit_out_deco : std_logic_vector(2 downto 0);
   Signal W_phit_out_deco : std_logic_vector(2 downto 0);
   Signal L_data_out_deco : std_logic_vector(31 downto 0);
   Signal N_data_out_deco : std_logic_vector(31 downto 0); 
   Signal E_data_out_deco : std_logic_vector(31 downto 0); 
   Signal S_data_out_deco : std_logic_vector(31 downto 0); 
   Signal W_data_out_deco : std_logic_vector(31 downto 0);
   signal L_Empty_decoder : STD_LOGIC;
   signal N_Empty_decoder : STD_LOGIC;
   signal E_Empty_decoder : STD_LOGIC;
   signal S_Empty_decoder : STD_LOGIC;
   signal W_Empty_decoder : STD_LOGIC; 
-----------------------------------------------------------------------------------------
begin

    DUT: Router port map(
        L_Data_in  => L_Data_in ,    
        N_Data_in  => N_Data_in ,
        E_Data_in  => E_Data_in ,
        S_Data_in  => S_Data_in ,
        W_Data_in  => W_Data_in ,
        L_Ack_in   => L_Ack_in  ,
        N_Ack_in   => N_Ack_in  ,
        E_Ack_in   => E_Ack_in  ,
        S_Ack_in   => S_Ack_in  ,
        W_Ack_in   => W_Ack_in  ,
        reset      => reset     ,
        L_Data_out => L_Data_out,
        N_Data_out => N_Data_out,
        E_Data_out => E_Data_out,
        S_Data_out => S_Data_out,
        W_Data_out => W_Data_out,
        L_Ack_out  => L_Ack_out ,
        N_Ack_out  => N_Ack_out ,
        E_Ack_out  => E_Ack_out ,
        S_Ack_out  => S_Ack_out ,
        W_Ack_out  => W_Ack_out);
-----------------------------------------ENCODING FOR L--------------------------------------       
    L_encoder_data: encoder port map (
        data_in  => L_Data_in_encoder,
        Empty    => L_Empty_encoder1,
        data_out => L_Data_out_encoder );
    L_encoder_phit: PhitEncoder port map (
        data_in  => L_phit_in_encoder,
        Empty    => L_Empty_encoder2,
        data_out => L_phit_out_encoder );
        
    L_Data_in.phit <= L_phit_out_encoder;
    L_Data_in.w00  <= L_Data_out_encoder.w00;
    L_Data_in.w01  <= L_Data_out_encoder.w01;
    L_Data_in.w10  <= L_Data_out_encoder.w10;
    L_Data_in.w11  <= L_Data_out_encoder.w11;
    
    L_decoder_data: decoder port map (
        data_in  => L_Data_out,
        phit_out => L_phit_out_deco,
        data_out => L_data_out_deco,
        empty =>  L_Empty_decoder);
----------------------------------------------------------------------------------------------
-----------------------------------------ENCODING FOR N--------------------------------------       
    N_encoder_data: encoder port map (
        data_in  => N_Data_in_encoder,
        Empty    => N_Empty_encoder1,
        data_out => N_Data_out_encoder );
    N_encoder_phit: PhitEncoder port map (
        data_in  => N_phit_in_encoder,
        Empty    => N_Empty_encoder2,
        data_out => N_phit_out_encoder );
        
    N_Data_in.phit <= N_phit_out_encoder;
    N_Data_in.w00  <= N_Data_out_encoder.w00;
    N_Data_in.w01  <= N_Data_out_encoder.w01;
    N_Data_in.w10  <= N_Data_out_encoder.w10;
    N_Data_in.w11  <= N_Data_out_encoder.w11;
    
    N_decoder_data: decoder port map (
        data_in  => N_Data_out,
        phit_out => N_phit_out_deco,
        data_out => N_data_out_deco,
        empty =>  N_Empty_decoder );
----------------------------------------------------------------------------------------------    
-----------------------------------------ENCODING FOR E--------------------------------------       
    E_encoder_data: encoder port map (
        data_in  => E_Data_in_encoder,
        Empty    => E_Empty_encoder1,
        data_out => E_Data_out_encoder );
    E_encoder_phit: PhitEncoder port map (
        data_in  => E_phit_in_encoder,
        Empty    => E_Empty_encoder2,
        data_out => E_phit_out_encoder );
        
    E_Data_in.phit <= E_phit_out_encoder;
    E_Data_in.w00  <= E_Data_out_encoder.w00;
    E_Data_in.w01  <= E_Data_out_encoder.w01;
    E_Data_in.w10  <= E_Data_out_encoder.w10;
    E_Data_in.w11  <= E_Data_out_encoder.w11;
    
     E_decoder_data: decoder port map (
        data_in  => E_Data_out,
        phit_out => E_phit_out_deco,
        data_out => E_data_out_deco,
        empty =>  E_Empty_decoder ); 
----------------------------------------------------------------------------------------------    
-----------------------------------------ENCODING FOR S--------------------------------------       
    S_encoder_data: encoder port map (
        data_in  => S_Data_in_encoder,
        Empty    => S_Empty_encoder1,
        data_out => S_Data_out_encoder );
    S_encoder_phit: PhitEncoder port map (
        data_in  => S_phit_in_encoder,
        Empty    => S_Empty_encoder2,
        data_out => S_phit_out_encoder );
        
    S_Data_in.phit <= S_phit_out_encoder;
    S_Data_in.w00  <= S_Data_out_encoder.w00;
    S_Data_in.w01  <= S_Data_out_encoder.w01;
    S_Data_in.w10  <= S_Data_out_encoder.w10;
    S_Data_in.w11  <= S_Data_out_encoder.w11;
    
     S_decoder_data: decoder port map (
        data_in  => S_Data_out,
        phit_out => S_phit_out_deco,
        data_out => S_data_out_deco,
        empty =>  S_Empty_decoder );
----------------------------------------------------------------------------------------------    
 -----------------------------------------ENCODING FOR W--------------------------------------       
    W_encoder_data: encoder port map (
        data_in  => W_Data_in_encoder,
        Empty    => W_Empty_encoder1,
        data_out => W_Data_out_encoder );
    W_encoder_phit: PhitEncoder port map (
        data_in  => W_phit_in_encoder,
        Empty    => W_Empty_encoder2,
        data_out => W_phit_out_encoder );
        
    W_Data_in.phit <= W_phit_out_encoder;
    W_Data_in.w00  <= W_Data_out_encoder.w00;
    W_Data_in.w01  <= W_Data_out_encoder.w01;
    W_Data_in.w10  <= W_Data_out_encoder.w10;
    W_Data_in.w11  <= W_Data_out_encoder.w11;
    
     W_decoder_data: decoder port map (
        data_in  => W_Data_out,
        phit_out => W_phit_out_deco,
        data_out => W_data_out_deco,
        empty =>  W_Empty_decoder );
----------------------------------------------------------------------------------------------    
   
    send_L: process
    begin
            L_Empty_encoder1 <= '1';
            L_Empty_encoder2 <= '1';
            reset <= '0';
            wait for 100 ns;
        --------------Header--------------------------
            reset <= '1';
            L_Empty_encoder1 <= '0';
            L_Empty_encoder2 <= '0';
            L_phit_in_encoder <= "110"; --header
            L_Data_in_encoder <= STD_LOGIC_VECTOR (to_unsigned(0,L_Data_in_encoder'length)); 
            wait until L_Ack_out = '1';
            wait for 100 ns;
        -------------Empty-----------------------------    
            L_Empty_encoder1 <= '1';
            L_Empty_encoder2 <= '1';
            wait for 100 ns;
        --------------Int--------------------------
            L_Empty_encoder1 <= '0';
            L_Empty_encoder2 <= '0';
            L_phit_in_encoder <= "100"; --Intermidiate
            L_Data_in_encoder <= STD_LOGIC_VECTOR (to_unsigned(1,L_Data_in_encoder'length)); 
            wait until L_Ack_out = '1'; -- packet goes to N
            wait for 100 ns;
        -------------Empty-----------------------------    
            L_Empty_encoder1 <= '1';
            L_Empty_encoder2 <= '1';
            wait for 100 ns;
        --------------Tail--------------------------
            L_Empty_encoder1 <= '0';
            L_Empty_encoder2 <= '0';
            L_phit_in_encoder <= "101"; --tail
            L_Data_in_encoder <= STD_LOGIC_VECTOR (to_unsigned(2,L_Data_in_encoder'length)); 
            wait until N_Ack_out = '1'; -- packet goes to N
            wait for 100 ns;
        -------------Empty-----------------------------    
            L_Empty_encoder1 <= '1';
            L_Empty_encoder2 <= '1';
            wait for 100 ns;                
        --------------Void--------------------------
            L_Empty_encoder1 <= '0';
            L_Empty_encoder2 <= '0';
            L_phit_in_encoder <= "011"; --void
            L_Data_in_encoder <= STD_LOGIC_VECTOR (to_unsigned(3,L_Data_in_encoder'length)); 
            wait until N_Ack_out = '1'; -- packet goes to N
            wait for 100 ns;
        -------------Empty-----------------------------    
            L_Empty_encoder1 <= '1';
            L_Empty_encoder2 <= '1';
            wait for 100 ns;           
        
    end process;
    
    recieve_N: process
    begin
            N_Ack_in <= '1';
            wait until W_Empty_decoder = '1';
            wait for 100 ns;
            N_Ack_in <= '0';
        --------------Header-------------------------- 
            wait until N_data_out_deco = STD_LOGIC_VECTOR (to_unsigned(0,N_data_out_deco'length)) ;
            wait until N_phit_out_deco = "110";
            wait for 100 ns;
            N_Ack_in <= '1';
        -------------Empty-----------------------------    
            wait until W_Empty_decoder = '1';
            wait for 100 ns;
            N_Ack_in <= '1';
            wait for 100 ns;
            N_Ack_in <= '0';
        --------------Int--------------------------
            wait until N_data_out_deco = STD_LOGIC_VECTOR (to_unsigned(1,N_data_out_deco'length)) ;
            wait until N_phit_out_deco = "100";
            wait for 100 ns;
            N_Ack_in <= '1';
        -------------Empty-----------------------------    
            wait until W_Empty_decoder = '1';
            wait for 100 ns;
            N_Ack_in <= '1';
            wait for 100 ns;
            N_Ack_in <= '0';
        --------------Tail--------------------------
            wait until N_data_out_deco = STD_LOGIC_VECTOR (to_unsigned(2,N_data_out_deco'length)) ;
            wait until N_phit_out_deco = "101";
            wait for 100 ns;
            N_Ack_in <= '1';
        -------------Empty-----------------------------    
            wait until W_Empty_decoder = '1';
            wait for 100 ns;
            N_Ack_in <= '1';
            wait for 100 ns;
            N_Ack_in <= '0';             
        --------------Void--------------------------
            wait until N_data_out_deco = STD_LOGIC_VECTOR (to_unsigned(3,N_data_out_deco'length)) ;
            wait until N_phit_out_deco = "011";
            wait for 100 ns;
            N_Ack_in <= '1';
        -------------Empty-----------------------------    
            wait until W_Empty_decoder = '1';
            wait for 100 ns;
            N_Ack_in <= '1';
            wait for 100 ns;
            N_Ack_in <= '0';  
        
        
    end process;
end Behavioral;