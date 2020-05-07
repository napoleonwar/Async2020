library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.define_type.all;
use IEEE.NUMERIC_STD.ALL;

entity decoder is
    Port ( data_in : in channel_forward;
           phit_out : out std_logic_vector(2 downto 0);
           data_out : out std_logic_vector(31 downto 0);
           empty : out std_logic
           );
end decoder;

architecture Behavioral of decoder is
signal data : std_logic_vector (3 downto 0);
signal phit_empty, data_empty : std_logic;
begin
    
    process(data_in) is
    constant FOR_STEP : natural := 2; 
    begin
        data_out <=(others=>'0');
        phit_out <=(others=>'0');
        phit_empty <= '0';
        data_empty <= '0';
        empty <= '0';
        case data_in.phit is
            when "1000" => phit_out <= "110";
            when "0100" => phit_out <= "101";
            when "0010" => phit_out <= "100";
            when "0001" => phit_out <= "000";
            when others => phit_empty <= '1';
        end case;
        
        for i in 0 to 15 loop
            data <= data_in.w11(i) & data_in.w10(i) & data_in.w01(i) & data_in.w00(i);
            case data is 
                when "0001" =>   data_out(((i*FOR_STEP)+1) downto (i*FOR_STEP)) <= "00"; 
                when "0010" =>   data_out(((i*FOR_STEP)+1) downto (i*FOR_STEP)) <= "01"; 
                when "0100" =>   data_out(((i*FOR_STEP)+1) downto (i*FOR_STEP)) <= "10"; 
                when "1000" =>   data_out(((i*FOR_STEP)+1) downto (i*FOR_STEP)) <= "11";
                when others =>   data_empty <= '1';
            end case;
        end loop;
        empty <= phit_empty AND data_empty;
    end process;
    
end Behavioral;
