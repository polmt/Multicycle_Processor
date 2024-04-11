library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.env.ALL;

entity RegFile_tb is
end RegFile_tb;

architecture behavioral of RegFile_tb is

	constant N : positive := 4;
	constant M : positive := 32;
	
	component RegFile is
		generic(N : positive := 4;
			    M : positive := 32);
		port(clk : in std_logic;
			 WE : in std_logic;
			 addr_W : in std_logic_vector (N-1 downto 0);
			 addr_R1 : in std_logic_vector (N-1 downto 0);
			 addr_R2 : in std_logic_vector (N-1 downto 0);
			 data_in : in std_logic_vector (M-1 downto 0);
			 data_out1 : out std_logic_vector (M-1 downto 0);
			 data_out2 : out std_logic_vector (M-1 downto 0));
	end component;
	
	signal clk : std_logic := '0';
	signal WE : std_logic := '0';
	signal addr_W : std_logic_vector(N-1 downto 0) := (others => 'X');
	signal addr_R1 : std_logic_vector(N-1 downto 0) := (others => 'X');
	signal addr_R2 : std_logic_vector(N-1 downto 0) := (others => 'X');
	signal data_in : std_logic_vector(M-1 downto 0) := (others => 'X');
	signal data_out1 : std_logic_vector(M-1 downto 0);
	signal data_out2 : std_logic_vector(M-1 downto 0);
	
	constant clk_period : time := 10 ns;

begin

		uut: RegFile
			generic map(N => N,
				        M => M)
			port map(clk => clk,
				     WE => WE,     
				     addr_W => addr_W,  
				     addr_R1 => addr_R1,  
				     addr_R2 => addr_R2,  
				     data_in => data_in, 
				     data_out1 => data_out1,
				     data_out2 => data_out2);
			
		clk_process : process
			begin
				clk <= '0';
				wait for clk_period/2;
				clk <= '1';
				wait for clk_period/2;
			end process;
			
		Stimulus_process : process
		
			begin

				WE <= '0';
				wait for 100 ns;
				wait until (clk = '0' and clk'event);
				WE <= '1';
				addr_R1 <= x"0";
				addr_R2 <= x"0";	
				
				for j in 0 to 2**N-2 loop
					addr_W <= std_logic_vector(to_unsigned(j, addr_W'length));
					data_in <= std_logic_vector(to_unsigned(j, data_in'length));		
					wait for clk_period;
				end loop;
				
				WE <= '0';
				addr_W <= x"0";
				data_in <= x"0000_0000";
				wait for clk_period;
				
				for j in 0 to 2**(N-1)-2 loop
					addr_R1 <= std_logic_vector(to_unsigned(2*j, addr_R1'length));
					addr_R2 <= std_logic_vector(to_unsigned(2*j+1, addr_R2'length));
					wait for clk_period;
					
					assert data_out1=std_logjc_vector(to_unsjgned(2*j, data_out1'length))
					    report "Unexpected address port"
					        severity Error; 
					assert data_out2=std_logjc_vector(to_unsjgned(2*j+1, data_out2'length))
					    report "Unexpected address port"
					        severity Error;
				end loop;
				
				addr_R1 <= x"E";
				wait for clk_period;
				
				addr_R2 <= x"F";
				wait for clk_period;
				
				report "Successful test";
				wait;
				
			end process;

end behavioral;
