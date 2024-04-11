library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity ALU_tb is
end ALU_tb;

architecture behavioral of ALU_tb is

	constant width : positive := 32;

	component ALU is
		port(ALUControl : in std_logic_vector(3 downto 0);
			 shamt5 : in std_logic_vector(4 downto 0);			
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);			
			 ALUResult : out std_logic_vector(width-1 downto 0);
			 Flags : out std_logic_vector(3 downto 0));	
	end component;
	
	signal clk : std_logic := '0';
	signal reset : std_logic := '1';
	signal A : std_logic_vector(width-1 downto 0) := (others => 'X');
	signal B : std_logic_vector(width-1 downto 0) := (others => 'X');
	signal ALUControl : std_logic_vector (3 downto 0) := (others => '0');
	signal shamt5 : std_logic_vector (4 downto 0) := (others => 'X');
	signal ALUResult : std_logic_vector (width-1 downto 0);
	signal Flags : std_logic_vector (3 downto 0);
	constant CLK_period : time := 10 ns;

begin

	    test_ALU : ALU
		port map(ALUControl => ALUControl,
			     shamt5 => shamt5,
                 A => A,
                 B => B,
                 ALUResult => ALUResult,
                 Flags => Flags);
	
		CLK_process : process
			begin
				CLK <= '0';
				wait for clk_period/2;
				CLK <= '1';
				wait for clk_period/2;
			end process;
			
		stim : process
		
		variable shamt_n : natural range 0 to 31;
		variable B_s : signed(width-1 downto 0);
		variable B_u : unsigned(width-1 downto 0);
		
		begin

			reset <= '1';
			ALUControl <= "0000";
			wait for 100 ns;
			wait until (CLK = '0' and CLK'event);
			
			reset <= '0';

			ALUControl <= "0000";
			shamt5 <= "00000";
			A <= x"0000_0000";
			B <= x"0000_0000";	
			wait for 2*clk_period;
			
			
			A <= x"FFFF_FFFF";
			B <= x"8000_0000";
			wait for 2*clk_period;
			
			A <= x"0000_0001";
			B <= x"7FFF_FFFF";
			wait for 2*clk_period;
			
			A <= x"0000_0001";
			B <= x"8000_0000";
			wait for 2*clk_period;						
			
			A <= x"FFFF_FFFF";
			B <= x"7FFF_FFFF";
			wait for 2*clk_period;
			
			ALUControl <= "0001";
			shamt5 <= "00000";
			wait for 2*clk_period;
			
			A <= x"8000_0000";
			B <= x"0000_0001";
			wait for 2*clk_period;
			
			A <= x"FFFF_FFFF";
			B <= x"7FFF_FFFF";
			wait for 2*clk_period;
			
			A <= x"0000_C350";
			B <= x"0001_86A0";
			wait for 2*clk_period;
			
			
			shamt5 <= "00001";
			
			for j in 2 to 15 loop
				ALUControl <= std_logic_vector(to_unsigned(j, ALUControl'length));
				
				for k in -40 to 40 loop
					for l in -40 to 40 loop
						A <= std_logic_vector(to_signed(k, A'length));
						B <= std_logic_vector(to_signed(l, B'length));
						wait for 2*clk_period;
						
						if (ALUControl(1) = '1' or ALUControl(2) = '1' or ALUControl(3) = '1') then
							assert Flags(1 downto 0) = "00"
							    report "Unexpected value flag" 
								    severity Error;
						end if;
						
						shamt_n := to_integer(unsigned(shamt5));
						
						B_s := signed(B);
						B_u := unsigned(B);
						
						if    (ALUControl = "0010") then
							assert (A and B) = ALUResult
							    report "Unexpected value AND"
							        severity Error;
							
						elsif (ALUControl = "0011") then
							assert (A or B) = ALUResult
							    report "Unexpected value OR"
							        severity Error;
							
						elsif (ALUControl = "0100") then
							assert B = ALUResult
							    report "Unexpected value MOV"
							        severity Error;
						
						elsif (ALUControl = "0101") then
							assert (not B) = ALUResult
							    report "Unexpected value MVN"
							        severity Error;
							
						elsif (ALUControl = "0110" or ALUControl = "0111") then
							assert (A xor B) = ALUResult
							    report "Unexpected value XOR"
							        severity Error;
							
						elsif (ALUControl = "1000" or ALUControl = "1100") then	
							assert std_logic_vector(shift_left (B_u, shamt_n)) = ALUResult 
								report "Unexpected value LSL"
								    severity Error;
								
						elsif (ALUControl = "1001" or ALUControl = "1101") then	
							assert std_logic_vector(shift_right (B_u, shamt_n)) = ALUResult 
								report "Unexpected value LSR"
								    severity Error;
								
						elsif (ALUControl = "1010" or ALUControl = "1110") then	
							assert std_logic_vector(shift_right (B_s, shamt_n)) = ALUResult 
								report "Unexpected value ASR"
								    severity Error;
								
						elsif (ALUControl = "1011" or ALUControl = "1111") then	
							assert std_logic_vector(rotate_right (B_s, shamt_n)) = ALUResult 
								report "Unexpected value ROR"
								    severity Error;
								
						end if;
						
					end loop;
					
				end loop;	
				
			end loop;

			stop;
			
		end process;
	
end behavioral;
