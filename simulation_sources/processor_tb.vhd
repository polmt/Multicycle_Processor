library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity processor_tb is
end processor_tb;

architecture behavioral of processor_tb is

	constant width : positive := 32;
	
	component processor is
		port(clk, reset : in std_logic;
		     PC : out std_logic_vector(width-17 downto 0);
		     Instr : out std_logic_vector(width-1 downto 0);
	         ALUResult : out std_logic_vector(width-1 downto 0);
		     WriteData : out std_logic_vector(width-1 downto 0);
		     Result : out std_logic_vector(width-1 downto 0));
	end component;
	
	signal clk : std_logic := '0';
	signal reset : std_logic := '1';
	signal PC : std_logic_vector(width-17 downto 0);
	signal Instruction : std_logic_vector(width-1 downto 0);
	signal ALUResult : std_logic_vector(width-1 downto 0);
	signal WriteData : std_logic_vector(width-1 downto 0);
	signal Result : std_logic_vector(width-1 downto 0);
	
	constant clk_period : time := 8.2 ns;

begin

		uut : processor
			port map(clk => clk, 		
				     reset => reset,      
				     PC => PC, 			
				     Instr => Instruction,
				     ALUResult => ALUResult,  
				     WriteData => WriteData,  
				     Result => Result);
			
		create_clk : process
			begin
				clk <= '0';
				wait for clk_period/2;
				clk <= '1';
				wait for clk_period/2;
			end process;
			
		stimulation : process
		
			begin
				reset <= '1';
				wait for 10*clk_period;
				wait until (clk = '0' and clk'event);
				reset <= '0';
						
				wait for 10*clk_period;
				
				assert PC = x"0058"
				    report "Unexpected ROR value for PC"
				        severity Error;
				assert Instruction = x"E1A0DFEC"
				    report "Unexpected ROR value for Instruction"
				        severity Error;
				assert ALUResult = x"00000004"
				    report "Unexpected ROR value for ALUResult"
				        severity Error;
				assert WriteData = x"00000002"
				    report "Unexpected ROR value for WriteData"
				        severity Error;
				assert Result = x"00000004"
				    report "Unexpected ROR value for Result"
				        severity Error;
				
				wait for 2*clk_period;
				
				assert PC = x"005C"
				    report "Unexpected MOV value for PC"
				        severity Error;
				assert Instruction = x"E0C00000"
				    report "Unexpected MOV value for Instruction"
				        severity Error;
				assert ALUResult = x"00000000"
				    report "Unexpected MOV value for ALUResult"
				        severity Error;
				assert WriteData = x"00000000"
				    report "Unexpected MOV value for WriteData"
				        severity Error;
				assert Result = x"00000000"
				    report "Unexpected MOV value for Result"
				        severity Error;

            wait;
				
			end process;

end behavioral;
