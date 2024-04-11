------------------------
--TOP ENTITY/PROCESSOR--
------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
	generic(width : positive := 32);
	port(clk, reset : in std_logic;
		 PC : out std_logic_vector(width-17 downto 0);
		 Instr : out std_logic_vector(width-1  downto 0);
	     ALUResult : out std_logic_vector(width-1  downto 0);
		 WriteData : out std_logic_vector(width-1  downto 0);
		 Result : out std_logic_vector(width-1  downto 0));
end processor;

architecture behavioral of processor is

	component controller is
		port(clk, reset : in std_logic;
			 Instr : in std_logic_vector(31 downto 20);
			 Rd : in std_logic_vector(3 downto 0);
			 sh : in std_logic_vector(1 downto 0);
			 Flags : in std_logic_vector(3 downto 0);
			 IRWrite : out std_logic;
			 RegSrc : out std_logic_vector(2 downto 0);
			 RegWrite : out std_logic;
			 ImmSrc : out std_logic;
			 ALUSrc : out std_logic;
			 ALUControl : out std_logic_vector(3 downto 0);
			 FlagsWrite : out std_logic;
			 MAWrite : out std_logic;
			 MemWrite : out std_logic;
			 MemtoReg : out std_logic;
			 PCSrc : out std_logic_vector(1 downto 0);
			 PCWrite : out std_logic);
	end component;
	
	component datapath is
		generic(width : positive := 32);
		port(clk, reset : in std_logic;
			 PCWrite : in std_logic;
			 IRWrite : in std_logic;
			 RegSrc : in std_logic_vector(2 downto 0);
			 RegWrite : in std_logic;
			 ImmSrc : in std_logic;
			 ALUSrc : in std_logic;
			 ALUControl : in std_logic_vector(3 downto 0);
			 FlagsWrite : in std_logic;
			 MAWrite	: in std_logic;
			 MemWrite : in std_logic;
			 MemtoReg : in std_logic;
			 PCSrc : in std_logic_vector(1 downto 0);
			 PC : out std_logic_vector(width-1 downto 0);
			 Instr : out std_logic_vector(width-1 downto 0);
			 ALUResult : out std_logic_vector(width-1 downto 0);
			 Writedata : out std_logic_vector(width-1 downto 0);
			 Result : out std_logic_vector(width-1 downto 0);
			 Flags : out std_logic_vector(3 downto 0));
	end component;

	signal PC_in : std_logic_vector(width-1 downto 0);
	signal Instr_in : std_logic_vector(width-1 downto 0);
	signal ALUResult_in : std_logic_vector(width-1 downto 0);
	signal Writedata_in : std_logic_vector(width-1 downto 0);
	signal Result_in : std_logic_vector(width-1 downto 0);
	signal Flags_in : std_logic_vector(3 downto 0);
	signal ALUControl_in : std_logic_vector(3 downto 0);
	signal RegSrc_in : std_logic_vector(2 downto 0);
	signal PCSrc_in : std_logic_vector(1 downto 0);
	signal IRWrite_in : std_logic;
	signal RegWrite_in : std_logic;
	signal ImmSrc_in : std_logic;
	signal ALUSrc_in : std_logic;
	signal FlagsWrite_in : std_logic;
	signal MAWrite_in : std_logic;
	signal MemWrite_in : std_logic;
	signal MemtoReg_in : std_logic;
	signal PCWrite_in : std_logic;
		
	
begin

	control_unit : controller
		port map(clk => clk,
			     reset => reset,
 			     Instr => Instr_in(31 downto 20),
			     Rd	=> Instr_in(15 downto 12),
			     sh	=> Instr_in(6 downto 5),
			     Flags => Flags_in,
 			     IRWrite => IRWrite_in,
 			     RegSrc => RegSrc_in,
			     RegWrite => RegWrite_in,
			     ImmSrc => ImmSrc_in,
			     ALUSrc => ALUSrc_in,
			     ALUControl => ALUControl_in,
			     FlagsWrite => FlagsWrite_in,
			     MAWrite => MAWrite_in,
			     MemWrite => MemWrite_in,
			     MemtoReg => MemtoReg_in,
			     PCSrc => PCSrc_in,
			     PCWrite => PCWrite_in);
	
	datapath_unit : datapath
		generic map(width => width)	
		port map(clk => clk,
			     reset => reset,
			     PCWrite => PCWrite_in,
			     IRWrite => IRWrite_in,
			     RegSrc => RegSrc_in,
			     RegWrite => RegWrite_in,
			     ImmSrc => ImmSrc_in,
			     ALUSrc => ALUSrc_in,
			     ALUControl => ALUControl_in,
			     FlagsWrite => FlagsWrite_in,
			     MAWrite => MAWrite_in,
			     MemWrite => MemWrite_in,
			     MemtoReg => MemtoReg_in,
			     PCSrc => PCSrc_in,
			     PC => PC_in,
			     Flags => Flags_in,
			     Instr => Instr_in,
			     Writedata => Writedata_in,
			     Result => Result_in,
			     ALUResult => ALUResult_in);
			
	             PC <= PC_in(15 downto 0);
	             Instr <= Instr_in;
	             Writedata <= Writedata_in;
	             ALUResult <= ALUResult_in;
	             Result <= Result_in;

end behavioral;




------------
--DATAPATH--
------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	generic(width : positive := 32);
	port(clk, reset : in std_logic;
		 PCWrite : in std_logic;
		 IRWrite : in std_logic;
		 RegSrc : in std_logic_vector(2 downto 0);
		 RegWrite : in std_logic;
		 ImmSrc : in std_logic;
		 ALUSrc : in std_logic;
		 ALUControl : in std_logic_vector(3 downto 0);
		 FlagsWrite : in std_logic;
		 MAWrite	: in std_logic;
		 MemWrite : in std_logic;
		 MemtoReg : in std_logic;
		 PCSrc : in std_logic_vector(1 downto 0);
		 PC : out std_logic_vector(width-1 downto 0);
		 Instr : out std_logic_vector(width-1 downto 0);
		 ALUResult : out std_logic_vector(width-1 downto 0);
		 Writedata : out std_logic_vector(width-1 downto 0);
		 Result : out std_logic_vector(width-1 downto 0);
		 Flags : out std_logic_vector(3 downto 0));
end datapath;

architecture behavioral of datapath is
	
	constant N : positive := 6;
	constant addr_len : positive := 4;
	
	component Reg_WE is
		generic(width : positive := 32);
		port(clk : in std_logic;
			 reset : in std_logic;
			 WE : in std_logic;
			 D : in std_logic_vector (width-1 downto 0);
			 Q : out std_logic_vector (width-1 downto 0));
	end component;
	
	component DFF is
		generic(width : positive := 32);
		port(clk : in std_logic;
			 reset : in std_logic;
			 D : in std_logic_vector(width-1 downto 0);
			 Q : out std_logic_vector(width-1 downto 0));
	end component;
	
	component stage1 is
		generic(N : positive := 6;
			    width : positive := 32);
		port(PC_in : in std_logic_vector (width-1 downto 0);
			 Instr : out std_logic_vector (width-1 downto 0);
			 PCPlus4 : out std_logic_vector (width-1 downto 0));
	end component;
	
	component stage2 is
		generic(N : positive := 4;
			    width : positive := 32);
		port(clk : in std_logic;
			 RegSrc : in std_logic_vector(2 downto 0);
			 RegWrite : in std_logic;
			 ImmSrc : in std_logic;
			 Instr : in std_logic_vector(23 downto 0);
			 PCPlus4 : in std_logic_vector(width-1 downto 0);
			 Result_in : in std_logic_vector(width-1 downto 0);
			 RD1 : out std_logic_vector(width-1 downto 0);
			 RD2 : out std_logic_vector(width-1 downto 0);
			 ExtImm : out std_logic_vector(width-1 downto 0));
	end component;
	
	component stage3 is
		generic(width : positive := 32);
		port(ALUSrc : in std_logic;
			 ALUControl : in std_logic_vector(3 downto 0);	
			 SrcA : in std_logic_vector(width-1 downto 0);
			 Writedata_in : in std_logic_vector(width-1 downto 0);
			 ExtImm : in std_logic_vector(width-1 downto 0);
			 ALUResult_in : out std_logic_vector(width-1 downto 0);
			 Flags_in : out std_logic_vector(3 downto 0));
		end component;
	
	component RAM_array is
		generic(N : positive := 5;
			    M : positive := 32);
		port(clk : in std_logic;
			 WE : in std_logic;
			 A : in std_logic_vector (N-1 downto 0);
			 WD : in std_logic_vector (M-1 downto 0);
			 RD : out std_logic_vector (M-1 downto 0));
	end component;
	
	component stage5 is
		generic(width : positive := 32);
		port(MemtoReg : in std_logic;
			 PCSrc	: in std_logic_vector(1 downto 0);
			 ALUResult : in std_logic_vector(width-1 downto 0);
			 S_in : in std_logic_vector(width-1 downto 0);
			 RD : in std_logic_vector(width-1 downto 0);
			 PCPlus4 : in std_logic_vector(width-1 downto 0);
			 Result : out std_logic_vector(width-1 downto 0);
			 PCN : out std_logic_vector(width-1 downto 0));
	end component;

	signal Instr_in : std_logic_vector (width-1 downto 0);
	signal PCPlus4_in : std_logic_vector (width-1 downto 0);
	signal Instr_out : std_logic_vector (width-1 downto 0);
	signal PCPlus4_out : std_logic_vector (width-1 downto 0);
	signal PCN : std_logic_vector (width-1 downto 0);
	signal PC_in : std_logic_vector (width-1 downto 0);
	signal RD1 : std_logic_vector (width-1 downto 0);
	signal RD2 : std_logic_vector (width-1 downto 0);
	signal ExtImm_in : std_logic_vector (width-1 downto 0);
	signal SrcA : std_logic_vector (width-1 downto 0);
	signal Writedata_in : std_logic_vector (width-1 downto 0);
	signal ExtImm_out : std_logic_vector (width-1 downto 0);
	signal ALUResult_in : std_logic_vector (width-1 downto 0);
	signal Result_in : std_logic_vector (width-1 downto 0);
	signal Flags_in : std_logic_vector (3 downto 0);
	signal A_in : std_logic_vector (4 downto 0);
	signal WriteData_out : std_logic_vector (width-1 downto 0);
	signal ALUResult_out : std_logic_vector (width-1 downto 0);
	signal RD_in : std_logic_vector (width-1 downto 0);
	signal RD_out : std_logic_vector (width-1 downto 0);

begin

	Program_Counter : Reg_WE
		generic map(width => width)
		port map(clk   => clk,
			     reset => reset,
			     WE => PCWrite,
			     D => PCN,
			     Q => PC_in);
			     
	             PC <= PC_in;
	
	First_Stage : stage1
		generic map(N => N,
			        width => width)
		port map(PC_in => PC_in,
			     Instr => Instr_in,
			     PCPlus4 => PCPlus4_in);

	Instr_Register : Reg_WE
		generic map(width => width)
		port map(clk => clk,   
			     reset => reset,
			     WE => IRWrite,
			     D => Instr_in,
			     Q => Instr_out);

	PC_plus4_Register : DFF
		generic map(width => width)
		port map(clk => clk,
			     reset => reset,
			     D => PCPlus4_in,
			     Q => PCPlus4_out);

	Instr <= Instr_in;

	Second_Stage : stage2
		generic map(N => addr_len,		
			        width => width)
		port map(clk => clk,
			     RegSrc => RegSrc,
			     RegWrite => RegWrite,
			     ImmSrc => ImmSrc,
			     Instr => Instr_out(23 downto 0),
			     PCPlus4 => PCPlus4_out,
			     Result_in => Result_in,
			     RD1 => RD1,
			     RD2 => RD2,
			     ExtImm => ExtImm_in);

	A_Register : DFF
		generic map(width => width)
		port map(clk => clk,
			     reset => reset,
			     D => RD1,
			     Q => SrcA);

	B_Register : DFF
		generic map(width => width)
		port map(clk => clk,
			reset => reset,
			D => RD2,
			Q => Writedata_in);
	
	I_Register : DFF
		generic map(width => width)
		port map(clk => clk,
			reset => reset,
			D => ExtImm_in,
			Q => ExtImm_out);

	WriteData <= Writedata_in;

	Third_Stage : stage3
		generic map(width => width)
		port map(ALUSrc => ALUSrc,    
			     ALUControl => ALUControl,
			     SrcA => SrcA,        
			     Writedata_in => Writedata_in,
			     ExtImm => ExtImm_out,      
			     ALUResult_in => ALUResult_in,
			     Flags_in => Flags_in);
	
	Status_Register : Reg_WE
		generic map(width => 4)
		port map(clk => clk,
			     reset => reset,
			     WE => FlagsWrite,
			     D => Flags_in,
			     Q => Flags);

	ALUResult <= ALUResult_in;	
	
	MA_Register : Reg_WE
		generic map(width => 5)
		port map(clk => clk,
			     reset => reset,
			     WE => MAWrite,
			     D => ALUResult_in(6 downto 2),
			     Q => A_in);	
	
	WD_Register : DFF
		generic map(width => width)
		port map(clk => clk,
			     reset => reset,
			     D => Writedata_in,
			     Q => WriteData_out);
	
	S_Register : DFF
		generic map(width => width)
		port map(clk => clk,
			reset => reset,
			D => ALUResult_in,
			Q => ALUResult_out);

	Fourth_Stage : RAM_array
		generic map(N => 5,
			        M => width)
		port map(clk => clk,
			     WE => MemWrite,
			     A => A_in,
			     WD => WriteData_out,
			     RD => RD_in);

	RD_Register : DFF
		generic map(width => width)
		port map(clk => clk,
			     reset => reset,
			     D => RD_in,
			     Q => RD_out);

	Fifth_Stage : stage5
		generic map(width => width)
		port map(MemtoReg => MemtoReg,
			     PCSrc => PCSrc,
			     ALUResult => ALUResult_in,
			     S_in  => ALUResult_out,
			     RD => RD_out,
			     PCPlus4 => PCPlus4_out,
			     Result => Result_in,
			     PCN => PCN);
		
	             Result <= Result_in;

end behavioral;



----------------------------
--REGISTER W/ WRITE ENABLE--
----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Reg_WE is
	generic(width : positive := 32);
	port(clk : in std_logic;
		reset : in std_logic;
		WE : in std_logic;
		D : in std_logic_vector(width-1 downto 0);
		Q :out std_logic_vector(width-1 downto 0));
end Reg_WE;

architecture behavioral of Reg_WE is

begin

	process (clk)

	begin

		if (clk = '1' and clk'event) then
			if (reset = '1') then
				Q <= (others => '0');
			elsif (WE = '1') then
				Q <= D;
			end if;
		end if;
	
	end process;

end behavioral;




---------------
--D FLIP FLOP--
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DFF is
	generic(width : positive := 32);
    port(clk : in std_logic;
		 reset : in std_logic;
         D : in std_logic_vector(width-1 downto 0);
         Q : out std_logic_vector(width-1 downto 0));
end DFF;

architecture behavioral of DFF is

begin

	process (clk)
	
	begin
		if (clk = '1' and clk'event) then
		
			if ( reset = '1') then
				Q <= (others => '0'); 
			else
				Q <= D;
			end if;
			
		end if;
		
	end process;

end behavioral;



-----------------
--STAGE 1 (LDR)--
-----------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity stage1 is
	generic(N : positive := 6;
		    width : positive := 32);
	port(PC_in : in std_logic_vector(width-1 downto 0);
		 Instr : out std_logic_vector(width-1 downto 0);
		 PCPlus4 : out std_logic_vector(width-1 downto 0));
end stage1;

architecture behavioral of stage1 is

	component ROM is
		generic(N : positive := 6;
			    M : positive := 32);
		port(addr : in std_logic_vector (N-1 downto 0);
			 data_out : out std_logic_vector (M-1 downto 0));
	end component;
	
	component adder is
		generic(width : positive := 32);
		port(A : in std_logic_vector (width-1 downto 0); 
			 B : in std_logic_vector (width-1 downto 0);
			 S : out std_logic_vector (width-1 downto 0));
	end component;
	
begin

	InstrMemory : ROM
		generic map(N => N,
			        M => width)
		port map(addr => PC_in(N+1 downto 2),
			     data_out => Instr);
		
	INC4 : adder 
		generic map(width => width)
		port map(A => PC_in, 
			     B => x"00000004",
			     S => PCPlus4);

end behavioral;



-------
--ROM--
-------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
	generic(N : positive := 6;
		    M : positive := 32);
	port(addr : in std_logic_vector(N-1 downto 0);
		 data_out : out std_logic_vector(M-1 downto 0));
end ROM;

architecture behavioral of ROM is

type ROM_array is array (0 to 2**N-1) of std_logic_vector(M-1 downto 0);

constant ROM : ROM_array := (X"E2C00000", X"E2801005", X"E1E02001", X"E0513002",
	                         X"0A000000", X"51814003", X"E0015004", X"E5801004",
	                         X"EB00000F", X"E1A0A089", X"E1A000A0", X"E5906004",
	                         X"E2267009", X"E357000D", X"B2808050", X"E5808024",
	                         X"E08FF000", X"E3E02000", X"E590F024", X"EAFFFFEB",
	                         X"E245B00A", X"E28BC007", X"E1A0DFEC", X"E0C00000",
	                         X"EAFFFFE6", X"E2800001", X"E1B09141", X"62800064",
	                         X"22405032", X"E0C0F00E", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000",
	                         X"00000000", X"00000000", X"00000000", X"00000000");

begin

	data_out <= ROM(to_integer(unsigned(addr)));

end behavioral;



-----------------
--STAGE 2 (STR)--
-----------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage2 is
	generic(N : positive := 4;
		    width : positive := 32);
	port(clk : in std_logic;
		 RegSrc : in std_logic_vector(2 downto 0);
		 RegWrite : in std_logic;
		 ImmSrc : in std_logic;
		 Instr : in std_logic_vector(23 downto 0);
		 PCPlus4 : in std_logic_vector(width-1 downto 0);
		 Result_in : in std_logic_vector(width-1 downto 0);
		 RD1 : out std_logic_vector(width-1 downto 0);
		 RD2 : out std_logic_vector(width-1 downto 0);
		 ExtImm : out std_logic_vector(width-1 downto 0));
end stage2;

architecture behavioral of stage2 is

	constant width_in : positive := 24;

	component mux2to1 is
		generic(width : positive := 32);
		port(sel : in std_logic;
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;

	component adder is
		generic(width : positive := 32);
		port(A : in std_logic_vector(width-1 downto 0); 
			 B : in std_logic_vector(width-1 downto 0);
			 S : out std_logic_vector(width-1 downto 0));
	end component;
	
	component RegisterFile is
		generic (N : positive := 4;
				 M : positive := 32);
		port(clk : in std_logic;
			RegWrite : in std_logic;
			A1 : in std_logic_vector(N-1 downto 0);
			A2 : in std_logic_vector(N-1 downto 0);
			A3 : in std_logic_vector(N-1 downto 0);
			WD3 : in std_logic_vector(M-1 downto 0);
			R15 : in std_logic_vector(M-1 downto 0);
			RD1 : out std_logic_vector(M-1 downto 0);
			RD2 : out std_logic_vector(M-1 downto 0));
	end component;

	component size_extend is
		generic (width_in : positive := 24;
				 width_out : positive := 32);
		port(SorZ : in std_logic;
			 SZ_in : in std_logic_vector (width_in-1 downto 0);
			 SZ_out : out std_logic_vector (width_out-1 downto 0));
	end component;

	signal RA1 : std_logic_vector (N-1 downto 0);
	signal RA2 : std_logic_vector (N-1 downto 0);
	signal WA : std_logic_vector (N-1 downto 0);
	signal PCPlus8 : std_logic_vector (width-1 downto 0);
	signal WD3 : std_logic_vector (width-1 downto 0);

begin

	INC8 : adder 
		generic map(width => width)
		port map(A => x"00000004", 
			     B => PCPlus4,
			     S => PCPlus8);

	mux_for_Rn_or_R15 : mux2to1 
		generic map(width => N)
		port map(sel  => RegSrc(0),
			     A => Instr(19 downto 16),
			     B => x"F",
			     Y => RA1);

	mux_for_Rm_or_Rd : mux2to1 
		generic map(width => N)
		port map(sel => RegSrc(1),
			     A => Instr(3 downto 0),
			     B => Instr(15 downto 12),
			     Y => RA2);

	mux_for_Rd_or_R14 : mux2to1 
		generic map(width => N)
		port map(sel => RegSrc(2),
			     A => Instr(15 downto 12),
			     B => x"E",
			     Y => WA);

	mux_for_INC4_or_Result : mux2to1 
		generic map(width => width)
		port map(sel => RegSrc(2),
			     A => Result_in,
			     B => PCPlus4,
			     Y => WD3);

	RegFile : RegisterFile
		generic map(N => N,
			        M => width)
		port map(clk => clk,
			     RegWrite => RegWrite,
			     A1 => RA1,
			     A2 => RA2,
			     A3 => WA,
			     WD3 => WD3,	
			     R15 => PCPlus8,
			     RD1 => RD1,
			     RD2 => RD2);
			     
	Extend : size_extend
		generic map(width_in => width_in, 
			        width_out => width)
		port map(SorZ => ImmSrc,  
			     SZ_in => Instr,
			     SZ_out => ExtImm);

end behavioral;



----------------
--STAGE 3 (DP)--
----------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage3 is
	generic(width : positive := 32);
    port(ALUSrc : in std_logic;
		 ALUControl : in std_logic_vector(3 downto 0);			 
		 SrcA : in std_logic_vector(width-1 downto 0);
		 Writedata_in : in std_logic_vector(width-1 downto 0);
		 ExtImm : in std_logic_vector(width-1 downto 0);
		 ALUResult_in : out std_logic_vector(width-1 downto 0);
		 Flags_in : out std_logic_vector(3 downto 0));
end stage3;

architecture behavioral of stage3 is

	component mux2to1 is
		generic(width : positive := 32);
		port(sel : in std_logic;
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;

	component ALU is
		generic(width : positive := 32);
		port(ALUControl : in std_logic_vector(3 downto 0);
			 shamt5 : in std_logic_vector(4 downto 0);
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 ALUResult : out std_logic_vector(width-1 downto 0);
			 Flags : out std_logic_vector(3 downto 0));	
	end component;
	
	signal SrcB : std_logic_vector(width-1 downto 0);

begin

	mux_for_Register_or_Immediate : mux2to1 
		generic map(width => width)
		port map(sel => ALUSrc,
			     A => Writedata_in,
			     B => ExtImm,
			     Y  => SrcB);
		
	ALU_S : ALU
		generic map(width => width)
		port map(ALUControl => ALUControl,
			     shamt5 => ExtImm(11 downto 7),
			     A => SrcA,
			     B => SrcB,
			     ALUResult => ALUResult_in,
			     Flags => Flags_in);

end behavioral;



--------------------
--ADDER (FOR INC8)--
--------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic(width : positive := 32);
	port(A : in std_logic_vector(width-1 downto 0); 
		 B : in std_logic_vector(width-1 downto 0);
		 S : out std_logic_vector(width-1 downto 0));
end adder;

architecture behavioral of adder is

begin

	adder: process (A, B)

	variable A_u : unsigned(width-1 downto 0);
	variable B_u : unsigned(width-1 downto 0);
	variable S_u : unsigned(width-1 downto 0);

	begin

		A_u := unsigned(A);
		B_u := unsigned(B);

		S_u := A_u + B_u;

		S <= std_logic_vector(S_u);

	end process;

end behavioral;


--------------
--CONTROLLER--
--------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
	port(clk, reset : in std_logic;
		 Instr : in std_logic_vector(31 downto 20);
		 Rd : in std_logic_vector(3 downto 0);
		 sh : in std_logic_vector(1 downto 0);
		 Flags : in std_logic_vector(3 downto 0);
		 IRWrite : out std_logic;
		 RegSrc : out std_logic_vector(2 downto 0);
		 RegWrite : out std_logic;
		 ImmSrc : out std_logic;
		 ALUSrc : out std_logic;
		 ALUControl : out std_logic_vector(3 downto 0);
		 FlagsWrite : out std_logic;
		 MAWrite : out std_logic;
		 MemWrite : out std_logic;
		 MemtoReg : out std_logic;
		 PCSrc : out std_logic_vector(1 downto 0);
		 PCWrite : out std_logic);
end controller;

architecture behavioral of controller is

	component InstrDecoder is
		port(op : in std_logic_vector(1 downto 0);
             funct : in std_logic_vector(5 downto 0);
             sh : in std_logic_vector(1 downto 0);
             RegSrc : out std_logic_vector(2 downto 0);
             ALUSrc : out std_logic;
             MemtoReg : out std_logic;
             ALUControl : out std_logic_vector(3 downto 0);
             ImmSrc : out std_logic;
             NoWrite_in : out std_logic);
	end component;
	
	component FSM is
		port(clk, reset : in std_logic;
			 op : in std_logic_vector(1 downto 0);
			 S_or_L : in std_logic;
			 Rd : in std_logic_vector(3 downto 0);
			 Link : in std_logic;
			 NoWrite_in : in std_logic;
			 CondEx_in : in std_logic;
			 IRWrite : out std_logic;
			 RegWrite : out std_logic;
			 MAWrite : out std_logic;
			 MemWrite : out std_logic;
			 FlagsWrite : out std_logic;
			 PCSrc : out std_logic_vector(1 downto 0);
			 PCWrite : out std_logic);
	end component;
	
	component CONDLogic is
		port(cond : in std_logic_vector(3 downto 0);
			 flags : in std_logic_vector(3 downto 0);
			 CondEx_in : out std_logic);
	end component;

	signal NoWrite_in : std_logic;
	signal CondEx_in : std_logic;

begin

	Instr_Decoder : InstrDecoder
		port map(op => Instr(27 downto 26),        
			     funct => Instr(25 downto 20),
			     sh => sh,
			     RegSrc => RegSrc,    
			     ALUSrc => ALUSrc,    
			     MemtoReg => MemtoReg,  
			     ALUControl => ALUControl,
			     ImmSrc => ImmSrc,    
			     NoWrite_in  => NoWrite_in);

	Moore_FSM : FSM
		port map(clk => clk,   
			     reset => reset, 
			     op =>  Instr(27 downto 26),
			     S_or_L =>  Instr(20),
			     Rd =>  Rd,
			     Link =>  Instr(24),
			     NoWrite_in => NoWrite_in,
			     CondEx_in => CondEx_in, 
			     IRWrite => IRWrite,   
			     RegWrite => RegWrite,  
			     MAWrite => MAWrite,   
			     MemWrite => MemWrite,  
			     FlagsWrite => FlagsWrite,
			     PCSrc => PCSrc,     
			     PCWrite => PCWrite);

	Condition_Logic : CONDLogic
		port map(cond => Instr(31 downto 28),
			     flags => Flags,
			     CondEx_in => CondEx_in);

end behavioral;


------------------
--STAGE 5 (B/BL)--
------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stage5 is
	generic(width : positive := 32);
	port(MemtoReg : in std_logic;
		 PCSrc : in std_logic_vector(1 downto 0);
		 ALUResult : in std_logic_vector(width-1 downto 0);
		 S_in : in std_logic_vector(width-1 downto 0);
		 RD : in std_logic_vector(width-1 downto 0);
		 PCPlus4 : in std_logic_vector(width-1 downto 0);
		 Result : out std_logic_vector(width-1 downto 0);
		 PCN : out std_logic_vector(width-1 downto 0));
end stage5;

architecture behavioral of stage5 is

	component mux2to1 is
		generic(width : positive := 32);
		port(sel : in std_logic;
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;

	component mux3to1 is
		generic(width : positive := 32);
		port(sel : in std_logic_vector(1 downto 0);
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 C : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;

	signal Internal_Result : std_logic_vector(width-1 downto 0);

begin

	mux_for_S_or_RD : mux2to1 
		generic map(width => width)
		port map(sel => MemtoReg,
			     A => S_in,
			     B => RD,
			     Y => Internal_Result);
	
	PC_mux : mux3to1
		generic map(width => width)
		port map(sel => PCSrc,
			     A => PCPlus4,
			     B => ALUResult,
			     C => Internal_Result,
			     Y => PCN);

	Result <= Internal_Result;

end behavioral;



---------------------------------
--CONDITION LOGIC (CHECKS COND)--
---------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONDLogic is
	port(cond : in std_logic_vector(3 downto 0);
		 flags : in std_logic_vector(3 downto 0);
		 CondEx_in : out std_logic);
end CONDLogic;

architecture behavioral of CONDLogic is

begin
	process (cond, flags)
		variable  N, Z, C, V : std_logic;
	begin
		N := flags(3);
		Z := flags(2);
		C := flags(1);
		V := flags(0);
	
		case cond is
			-- Equal
			when "0000" => 
				CondEx_in <= Z;
			-- Non Equal
			when "0001" => 
				CondEx_in <= not Z;
			-- Carry Set/Higher or Same
			when "0010" => 
				CondEx_in <= C;
			-- Carry Clear/Lower
			when "0011" => 
				CondEx_in <= not C;
			-- Minus (Negative)
			when "0100" => 
				CondEx_in <= N;
			-- Plus (Positive or Zero)
			when "0101" => 
				CondEx_in <= not N;
			-- oVerflow Set
			when "0110" => 
				CondEx_in <= V;
			-- oVerflow Clear
			when "0111" => 
				CondEx_in <= not V;
			-- Higher
			when "1000" => 
				CondEx_in <= (not Z) and C;
			-- Lower or Same
			when "1001" => 
				CondEx_in <= Z or (not C);
			-- Greater or Equal
			when "1010" => 
				CondEx_in <= not (N xor V);
			-- Less (signed)
			when "1011" => 
				CondEx_in <= N xor V;
			-- Greater (signed)
			when "1100" => 
				CondEx_in <= (not Z) and (not (N xor V));
			-- Less or Equal (signed)
			when "1101" => 
				CondEx_in <= Z or (N xor V);
			-- Always
			when "1110" => 
				CondEx_in <= '1';
			-- Uncoditional
			when "1111" => 
				CondEx_in <= '1';
			-- Default
			when others =>
				CondEx_in <= '0';
				
		end case;

	end process;

end behavioral;



-------------
--MOORE FSM--
-------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM is
	port(clk, reset : in std_logic;
		 op : in std_logic_vector(1 downto 0);
		 S_or_L : in std_logic;
		 Rd : in std_logic_vector(3 downto 0);
		 Link : in std_logic;
		 NoWrite_in : in std_logic;
		 CondEx_in : in std_logic;
		 IRWrite : out std_logic;
		 RegWrite : out std_logic;
		 MAWrite : out std_logic;
		 MemWrite : out std_logic;
		 FlagsWrite : out std_logic;
		 PCSrc : out std_logic_vector(1 downto 0);
		 PCWrite : out std_logic);
end FSM;
	
architecture behavioral of FSM is
	type FSM_states is
	(S0, S1, S2a, S2b, S3, S4a, S4b, S4c, S4d, S4e, S4f, S4g, S4h, S4i);
	attribute enum_encoding: string;
	attribute enum_encoding of FSM_states: type is
	    "0000 0001 0011 0010 0110 0111 0101 0100 1100 1101 1111 1110 1010 1011";
	signal current_state, next_state : FSM_states;
	signal Op_Reg_in : std_logic_vector(1 downto 0);		  
	signal SL_Reg_in : std_logic;
	signal Rd_Reg_in : std_logic_vector(3 downto 0);
	signal link_Reg_in : std_logic;
	signal NW_Reg_in : std_logic;	
	signal CondEx_Reg_in : std_logic;
begin

	Instr_Reg : process (clk)
	begin
		if (clk = '1' and clk'event) then

			if (reset = '1') then
				Op_Reg_in <= "11";
				SL_Reg_in <= '0';
				Rd_Reg_in <= "0000";
				link_Reg_in <= '0';
				NW_Reg_in <= '0';
				CondEx_Reg_in <= '0';	
			else
				Op_Reg_in <= op;	
				SL_Reg_in <= S_or_L;  
				Rd_Reg_in <= Rd;     
				link_Reg_in <= Link;	
				NW_Reg_in <= NoWrite_in;
				CondEx_Reg_in <= CondEx_in;
			end if;

		end if;

	end process;

	synchronous : process (clk)
	begin
	
		if (clk = '1' and clk'event) then
			if (reset = '1') then
				current_state <= S0;
			else
				current_state <= next_state;
			end if;

		end if;

	end process;
	
	asynchronous : process (current_state, Op_Reg_in, SL_Reg_in, Rd_Reg_in, link_Reg_in, NW_Reg_in, CondEx_Reg_in)
	
	begin
		next_state <= S0;
		IRWrite <= '0';
		RegWrite <= '0';
		MAWrite <= '0';
		MemWrite <= '0';
		FlagsWrite <= '0';
		PCSrc <= "00";
		PCWrite <= '0';

		case current_state is
			when S0 =>
				IRWrite <= '1';
				if (Op_Reg_in = "11") then
					next_state <= S0;
				else
					next_state <= S1;
				end if;

			when S1 =>
				if (CondEx_Reg_in = '0') then
					next_state <= S4c;
				else
					if (Op_Reg_in = "10") then
						-- Branch Link
						if (link_Reg_in = '1') then
							next_state <= S4i;	
						-- Branch
						else
							next_state <= S4h;
						end if;
					elsif (Op_Reg_in = "01") then
						next_state <= S2a;
					elsif (Op_Reg_in = "00") then
						-- Compare
						if (NW_Reg_in = '1') then
							next_state <= S4g;
						else
							next_state <= S2b;
						end if;
					else
						null;
					end if;
				end if;

			when S2a =>
				MAWrite <= '1';
				-- Store Register (STR)
				if (SL_Reg_in = '0') then
					next_state <= S4d;
				-- Load Register (LDR)
				else
					next_state <= S3;
				end if;

			when S2b =>
				-- S = 0
				if (SL_Reg_in = '0') then
					-- Rd = 15
					if (Rd_Reg_in = "1111") then
						next_state <= S4b;
					-- Rd /= 15
					else
						next_state <= S4a;
					end if;
				-- S = 1
				else
					-- Rd = 15
					if (Rd_Reg_in = "1111") then
						next_state <= S4f;
					-- Rd /= 15
					else
						next_state <= S4e;
					end if;
				end if;

			when S3  =>
				-- LDR, Rd = 15
				if (Rd_Reg_in = "1111") then
					next_state <= S4b;
				-- LDR, Rd /= 15
				else
					next_state <= S4a;
				end if;

			when S4a =>
				PCWrite <= '1';
				RegWrite <= '1';
				next_state <= S0;

			when S4b =>
				PCSrc <= "10";
				PCWrite <= '1';
				next_state <= S0;

			when S4c =>
				PCWrite <= '1';
				next_state <= S0;

			when S4d =>
				PCWrite <= '1';
				MemWrite <= '1';
				next_state <= S0;
			
			when S4e =>
				PCWrite <= '1';
				RegWrite <= '1';
				FlagsWrite <= '1';
				next_state <= S0;
			
			when S4f =>
				PCSrc <= "10";
				PCWrite <= '1';
				FlagsWrite <= '1';
				next_state <= S0;
			
			when S4g =>
				PCWrite <= '1';
				FlagsWrite <= '1';
				next_state <= S0;
			
			when S4h =>
				PCSrc <= "11";
				PCWrite <= '1';
				next_state <= S0;
			
			when S4i =>
				PCSrc <= "11";
				PCWrite <= '1';
				RegWrite <= '1';
				next_state <= S0;
						
			when others =>
				next_state <= S0;

		end case;
		
	end process;
	
end behavioral;



-----------------------
--INSTRUCTION DECODER--
-----------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstrDecoder is
	port(op : in std_logic_vector(1 downto 0);
		 funct : in std_logic_vector(5 downto 0);
		 sh : in std_logic_vector(1 downto 0);
		 RegSrc : out std_logic_vector(2 downto 0);
		 ALUSrc : out std_logic;
		 MemtoReg : out std_logic;
		 ALUControl : out std_logic_vector(3 downto 0);
		 ImmSrc : out std_logic;
		 NoWrite_in : out std_logic);
end InstrDecoder;

architecture behavioral of InstrDecoder is

begin

	process (op, funct, sh)

	begin

		RegSrc <= "000";
		ALUSrc <= '0';
		ImmSrc <= '0';
		ALUControl <= "0000";
		MemtoReg <= '0';
		NoWrite_in <= '0';

		case op is
			when "00" =>
				case funct(4 downto 1) is
					-- Add
					when "0100" =>
						RegSrc(1)  <= funct(5);
						ALUSrc     <= funct(5);
						ALUControl <= "0000";
					-- Subtract
					when "0010" =>
						RegSrc(1)  <= funct(5);
						ALUSrc     <= funct(5);
						ALUControl <= "0001";
					-- Compare
					when "1010" =>
						if(funct(0) = '1') then
							RegSrc(1)  <= funct(5);
							ALUSrc     <= funct(5);
							ALUControl <= "0001";
							NoWrite_in <= '1';
						else
							null;
						end if;
					-- Logic AND
					when "0000" =>
						RegSrc(1)  <= funct(5);
						ALUSrc     <= funct(5);
						ALUControl <= "0010";
					-- Logic OR
					when "1100" =>
						RegSrc(1)  <= funct(5);
						ALUSrc     <= funct(5);
						ALUControl <= "0011";
					-- Move
					when "0110" =>
						RegSrc(1)  <= funct(5);
						ALUSrc     <= funct(5);
						ALUControl <= "0100";
					-- Move Not
					when "1111" =>
						RegSrc(1)  <= funct(5);
						ALUSrc     <= funct(5);
						ALUControl <= "0101";
					-- Exclusive or
					when "0001" =>
						RegSrc(1)  <= funct(5);
						ALUSrc     <= funct(5);
						ALUControl <= "0111";
					-- Shift
					when "1101" =>
						if (funct(5) = '0') then
							-- Logical Shift Lleft
							if (sh = "00") then
								ALUControl <= "1000";
							-- Logical Shift Right
							elsif (sh = "01") then
								ALUControl <= "1001";
							-- Arithmetical Shift Right
							elsif (sh = "10") then
								ALUControl <= "1010";
							-- Rotate Right
							elsif (sh = "11") then
								ALUControl <= "1011";
							-- null
							else
								null;
							end if;
						else
							null;
						end if;

					when others =>
						null;
				end case;

			when "01" =>
				case funct is
					-- Load Register U = 1
					when "011001" =>
						ALUSrc <= '1';
						MemtoReg <= '1';
					-- Load Register U = 0
					when "010001" =>
						ALUSrc <= '1';
						ALUControl <= "0001";
						MemtoReg <= '1';
					-- Store Register U = 1
					when "011000" =>
						ALUSrc <= '1';
						RegSrc <= "010";
					-- Store Register U = 0
					when "010000" =>
						ALUSrc <= '1';
						RegSrc <= "010";
						ALUControl <= "0001";
					when others =>
						null;
				end case;
				
			when "10" =>
				-- Branch
				if (funct(5 downto 4) = "10") then
					RegSrc <= "001";
					ALUSrc <= '1';
					ImmSrc <= '1';
				-- Branch Link
				elsif (funct(5 downto 4) = "11") then
					RegSrc <= "101";
					ALUSrc <= '1';
					ImmSrc <= '1';
				-- null
				else
					null;
				end if;

			when others =>
				null;

		end case;	

	end process;

end behavioral;



----------------------------------
--MUX 2 IN TO 1 OUT, OF N LENGTH--
----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2to1 is
	generic(width : positive := 32);
	port(sel : in std_logic;
		 A : in std_logic_vector(width-1 downto 0);
		 B : in std_logic_vector(width-1 downto 0);
		 Y : out std_logic_vector(width-1 downto 0));
end mux2to1;

architecture behavioral of mux2to1 is

begin

	process (A, B, sel)
	
	begin
	
		if (sel = '0') then
			Y <= A;
		else
			Y <= B;
		end if;
		
	end process;
	
end behavioral;



----------------------------------
--MUX 3 IN TO 1 OUT, OF N LENGTH--
----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux3to1 is
	generic(width : positive := 32);
	port(sel : in std_logic_vector (1 downto 0);
		 A : in std_logic_vector(width-1 downto 0);
		 B : in std_logic_vector(width-1 downto 0);
		 C : in std_logic_vector(width-1 downto 0);
		 Y   : out std_logic_vector(width-1 downto 0));
end mux3to1;

architecture behavioral of mux3to1 is

begin

	process (sel, A, B, C)
	
	begin
	
		case sel is
		
			when "00" => 
				Y <= A;
			when "11" => 
				Y <= B;
			when "10" => 
				Y <= C;
			when others => 
				Y <= (others => '0');
			
		end case;
		
	end process;

end behavioral;



----------------------------------
--MUX 4 IN TO 1 OUT, OF N LENGTH--
----------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4to1 is
	generic(width : positive := 32);
	port(sel : in std_logic_vector(1 downto 0);
		 A : in std_logic_vector(width-1 downto 0);
		 B : in std_logic_vector(width-1 downto 0);
		 C : in std_logic_vector(width-1 downto 0);
		 D : in std_logic_vector(width-1 downto 0);
		 Y : out std_logic_vector(width-1 downto 0));
end mux4to1;

architecture behavioral of mux4to1 is

begin

	process (sel, A, B, C, D)
	
	begin
	
		case sel is
		
			when "00" => 
				Y <= A;
			when "01" => 
				Y <= B;
			when "10" => 
				Y <= C;
			when "11" => 
				Y <= D;
			when others => 
				Y <= (others => '0');
			
		end case;
		
	end process;

end behavioral;



-------
--ALU--
-------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	generic(width : positive := 32);
	port(ALUControl : in std_logic_vector(3 downto 0);
		 shamt5 : in std_logic_vector(4 downto 0);
		 A : in std_logic_vector(width-1 downto 0);
		 B : in std_logic_vector(width-1 downto 0);
		 ALUResult : out std_logic_vector(width-1 downto 0);
		 Flags : out std_logic_vector(3 downto 0));	
end ALU;		

architecture behavioral of ALU is

	component add_sub is
		generic(width : positive := 32);
		port(add_or_sub : in std_logic;
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 S : out std_logic_vector(width-1 downto 0);
			 C_out : out std_logic;
			 V : out std_logic);
	end component;
	
	component and_or is
		generic(width : positive := 32);
		port(ctrl : in std_logic;
			A : in std_logic_vector(width-1 downto 0);
			B : in std_logic_vector(width-1 downto 0);
			Y : out std_logic_vector(width-1 downto 0));
	end component;
	
	component mov_mvn is
		generic(width : positive := 32);
		port(ctrl : in std_logic;
			 A : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;
	
	component xor_gate is
		generic(width : positive := 32);
		port(A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;
	
	component barrel_shifter is
		generic(width : positive := 32);
		port(S : in std_logic_vector(1 downto 0);
			 shamt : in std_logic_vector(4 downto 0);
			 brlshift_in : in std_logic_vector(width-1 downto 0);
			 brlshift_out : out std_logic_vector(width-1 downto 0));
	end component;
	
	component mux2to1 is
		generic(width : positive := 32);
		port(sel : in std_logic;
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;
	
	component nor_gate is
		generic(width : positive := 32);
		port(A : in std_logic_vector(width-1 downto 0);
			 Z : out std_logic);
	end component;
	
	component mux4to1 is
		generic(width : positive := 32);
		port(sel : in std_logic_vector(1 downto 0);
			 A : in std_logic_vector(width-1 downto 0);
			 B : in std_logic_vector(width-1 downto 0);
			 C : in std_logic_vector(width-1 downto 0);
			 D : in std_logic_vector(width-1 downto 0);
			 Y : out std_logic_vector(width-1 downto 0));
	end component;
	
	signal add_or_sub_res : std_logic_vector(width-1 downto 0);
	signal and_or_or_res : std_logic_vector(width-1 downto 0);	     
	signal mov_or_mvn_res : std_logic_vector(width-1 downto 0);
	signal xor_res : std_logic_vector(width-1 downto 0);		     
	signal shift_res : std_logic_vector(width-1 downto 0);
	signal arithm_res : std_logic_vector(width-1 downto 0);
	signal C_out : std_logic;
	signal V : std_logic;
	signal ALUResult_in : std_logic_vector(width-1 downto 0);

begin

	add_or_sub : add_sub
		generic map(width => width)
		port map(add_or_sub => ALUControl(0),
			     A => A,
			     B => B,
			     S => add_or_sub_res,
			     C_out => C_out,
			     V => V);
		
	and_or_or : and_or
		generic map(width => width)
		port map(ctrl => ALUControl(0),		
			     A => A,
			     B => B,
			     Y => and_or_or_res);
		
	mov_or_mvn : mov_mvn
		generic map(width => width)
		port map(ctrl => ALUControl(0),
			     A => B,
			     Y => mov_or_mvn_res);
		
	xor_gt : xor_gate
		generic map(width => width)
		port map(A => A,
			     B => B,
			     Y => xor_res);
		
	brl_shft : barrel_shifter
		generic map(width => width)
		port map(S => ALUControl(1 downto 0),
			     shamt => shamt5,
			     brlshift_in => B,
			     brlshift_out => shift_res);
		
	mux_arith : mux4to1
		generic map(width => width)
		port map(sel => ALUControl(2 downto 1),
			     A => add_or_sub_res,
			     B => and_or_or_res,
			     C => mov_or_mvn_res,
			     D => xor_res,
			     Y => arithm_res);
		
	mux_arith_shft: mux2to1
		generic map(width => width)
		port map(sel => ALUControl(3),
			     A => arithm_res,
			     B => shift_res,
			     Y => ALUResult_in);
				
	Flags(3) <= ALUResult_in(width-1);
	
	nor_gt : nor_gate
		generic map(width => width)
		port map(A => ALUResult_in,
				 Z => Flags(2));
		
	Flags(1) <= C_out and (not ALUControl(1)) and (not ALUControl(2)) and (not ALUControl(3));
	Flags(0) <= V and (not ALUControl(1)) and (not ALUControl(2)) and (not ALUControl(3));

	ALUResult <= ALUResult_in;

end behavioral;



------------
--NOR GATE--
------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nor_gate is
    generic(width : positive := 32);
    port(A : in std_logic_vector(width-1 downto 0);
		 Z : out std_logic);
end nor_gate;

architecture structural of nor_gate is

	signal X : std_logic_vector(width downto 0);

begin

	X(0) <= '0';
	
	ng : for j in 0 to width-1 generate
		X(j+1) <= X(j) or A(j);
		Z <= not X(width);
	end generate ng;

end structural;



------------
--XOR GATE--
------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor_gate is
	generic(width : positive := 32);
	port(A : in std_logic_vector(width-1 downto 0);
		 B : in std_logic_vector(width-1 downto 0);
		 Y : out std_logic_vector(width-1 downto 0));
end xor_gate;

architecture behavioral of xor_gate is

begin

	Y <= A xor B;

end behavioral;



---------------
--SIZE EXTEND--
---------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity size_extend is
	generic(width_in : positive := 24; 
			width_out : positive := 32);
	port(SorZ : in std_logic;
		 SZ_in : in std_logic_vector(width_in-1 downto 0);
		 SZ_out : out std_logic_vector(width_out-1 downto 0));
end size_extend;

architecture behavioral of size_extend is

begin

	size_extend : process (SorZ, SZ_in)
	
	variable SZ_in_u : unsigned (11 downto 0);
	variable SZ_out_u : unsigned (width_out-1 downto 0);
	variable SZ_in_s : signed (25 downto 0);
	variable SZ_out_s : signed (width_out-1 downto 0);
	
	begin

		SZ_in_u := unsigned (SZ_in(11 downto 0)); 
		SZ_in_s := signed (SZ_in&"00"); 

		if (SorZ = '1') then 	
			SZ_out_s := resize (SZ_in_s, width_out);
			SZ_out <= std_logic_vector(SZ_out_s);
		else 	
			SZ_out_u := resize (SZ_in_u, width_out);
			SZ_out <= std_logic_vector(SZ_out_u);
		end if;

	end process;
	
end behavioral;



-----------
--MOV/MVN--
-----------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mov_mvn is
	generic(width : positive := 32);
	port(ctrl : in std_logic;
		 A : in std_logic_vector(width-1 downto 0);
		 Y : out std_logic_vector(width-1 downto 0));
end mov_mvn;

architecture behavioral of mov_mvn is

begin

	process (A, ctrl) 

	begin

		if(ctrl = '0') then
			Y <= A;
		else
			Y <= not A;
		end if;

	end process;

end behavioral;



------------------
--BARREL SHIFTER--
------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter is
	generic(width : positive := 32);
	port(S : in std_logic_vector (1 downto 0);
		 shamt : in std_logic_vector(4 downto 0);
		 brlshift_in : in std_logic_vector(width-1 downto 0);
		 brlshift_out : out std_logic_vector(width-1 downto 0)); 
end barrel_shifter;

architecture behavioral of barrel_shifter is

begin

	brl_shift : process (S, shamt, brlshift_in)
	
	variable shamt_n : natural range 0 to 31;
	
	variable X_s : signed(width-1 downto 0);
	variable X_u : unsigned(width-1 downto 0);
	
	begin

		shamt_n := to_integer(unsigned(shamt));

		X_s := signed(brlshift_in);
		X_u := unsigned(brlshift_in);

		case S is
			when "00" => 
				brlshift_out <= std_logic_vector(shift_left(X_u, shamt_n)); 
			when "01" => 
				brlshift_out <= std_logic_vector(shift_right(X_u, shamt_n)); 
			when "10" => 
				brlshift_out <= std_logic_vector(shift_right(X_s, shamt_n)); 
			when "11" => 
				brlshift_out <= std_logic_vector(rotate_right(X_s, shamt_n)); 
			when others => 
				brlshift_out <= brlshift_in;
			
		end case;
		
	end process;

end behavioral;



----------
--AND/OR--
----------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and_or is
	generic(width : positive := 32);
	port(ctrl : in std_logic;
		 A : in std_logic_vector(width-1 downto 0);
		 B : in std_logic_vector(width-1 downto 0);
		 Y : out std_logic_vector(width-1 downto 0));
end and_or;

architecture behavioral of and_or is

begin

	process (A, B, ctrl)

	begin

		if(ctrl = '0') then
			Y <= A and B;
		else
			Y <= A or B;
		end if;

	end process;

end behavioral;



-----------
--ADD/SUB--
-----------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
	generic (width : positive := 32);
	port(add_or_sub : in std_logic;
		 A : in std_logic_vector(width-1 downto 0);
		 B : in std_logic_vector(width-1 downto 0);
		 S : out std_logic_vector(width-1 downto 0);
		 C_out : out std_logic;
		 V : out std_logic);
end add_sub;

architecture behavioral of add_sub is

begin

	process (A, B, add_or_sub)
	
	variable A_s : signed(width+1 downto 0);
	variable B_s : signed(width+1 downto 0);
	variable S_s : signed(width+1 downto 0);
	
	begin
	
		A_s := signed('0'&A(width-1)&A);
		B_s := signed('0'&B(width-1)&B);
		
		if (add_or_sub = '0') then
			S_s := A_s + B_s;
		else
			S_s := A_s - B_s;
		end if;
		
		S <= std_logic_vector(S_s(width-1 downto 0));
		V <= S_s(width) xor S_s(width-1);
		C_out <= S_s(width+1);
	
	end process;

end behavioral;



-------
--RAM--
-------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM_array is
	generic(N : positive := 5;
		    M : positive := 32);
	port(clk : in std_logic;
		 WE : in std_logic;
		 A : in std_logic_vector(N-1 downto 0);
		 WD : in std_logic_vector(M-1 downto 0);
		 RD : out std_logic_vector(M-1 downto 0));
end RAM_array;

architecture behavioral of RAM_array is

	type RAM_array is array (2**N-1 downto 0)
	  of std_logic_vector (M-1 downto 0);
	  
	signal RAM : RAM_array;
	
begin

	data_mem : process (clk)
	
	begin
	
		if (clk = '1' and clk'event) then
			if (WE = '1') then 
				RAM(to_integer(unsigned(A))) <= WD;
			end if;
		end if;
		
	end process;
	
	RD <= RAM(to_integer(unsigned(A)));

end behavioral;



--------------------------------
--REGISTER FILE (INNER MODULE)--
--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile is
	generic(N : positive := 4;
		    M : positive := 32);
	port(clk : in std_logic;
		 WE	: in std_logic;
		 addr_W : in std_logic_vector(N-1 downto 0);
		 addr_R1 : in std_logic_vector(N-1 downto 0);
		 addr_R2 : in std_logic_vector(N-1 downto 0);
		 data_in : in std_logic_vector(M-1 downto 0);
		 data_out1 : out std_logic_vector(M-1 downto 0);
		 data_out2 : out std_logic_vector(M-1 downto 0));
end RegFile;

architecture behavioral of RegFile is

type RF_array is array (2**N-1 downto 0) of std_logic_vector(M-1 downto 0);

signal RF : RF_array;

begin

	Reg_File : process (clk)

	begin

		if (clk = '1' and clk'event) then
			if (WE = '1') then
				RF(to_integer(unsigned(addr_W))) <= data_in;
			end if;
		end if;

	end process;

	data_out1 <= RF(to_integer(unsigned(addr_R1)));
	data_out2 <= RF(to_integer(unsigned(addr_R2)));

end behavioral;



-----------------
--REGISTER FILE--
-----------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
	generic(N : positive := 4;
			M : positive := 32);
	port(clk : in std_logic;
		RegWrite : in std_logic;
		A1 : in std_logic_vector(N-1 downto 0);
		A2 : in std_logic_vector(N-1 downto 0);
		A3 : in std_logic_vector(N-1 downto 0);
		WD3 : in std_logic_vector(M-1 downto 0);
		R15 : in std_logic_vector(M-1 downto 0);
		RD1 : out std_logic_vector(M-1 downto 0);
		RD2 : out std_logic_vector(M-1 downto 0));
end RegisterFile;

architecture behavioral of RegisterFile is

	component RegFile is
	generic(N : positive := 4;
		    M : positive := 32);
	port(clk : in std_logic;
		 WE : in std_logic;
		 addr_W : in std_logic_vector(N-1 downto 0);
		 addr_R1 : in std_logic_vector(N-1 downto 0);
		 addr_R2 : in std_logic_vector(N-1 downto 0);
		 data_in : in std_logic_vector(M-1 downto 0);
		 data_out1 : out std_logic_vector(M-1 downto 0);
		 data_out2 : out std_logic_vector(M-1 downto 0));		
	end component;
	
	signal RF_RD1 : std_logic_vector (M-1 downto 0);
	signal RF_RD2 : std_logic_vector (M-1 downto 0);
	
begin

	RF_RO_to_R14: RegFile
		generic map(N => N,
			        M => M)
		port map(clk => clk,
			     WE => RegWrite,
			     addr_W => A3,
			     addr_R1 => A1,
			     addr_R2 => A2,
			     data_in => WD3,
			     data_out1 => RF_RD1,
			     data_out2 => RF_RD2);

	RD1_mux : process (RF_RD1, R15, A1)

	begin

		if (A1 = "1111") then
			RD1 <= R15;
		else
			RD1 <= RF_RD1;
		end if;

	end process;

	RD2_mux : process (RF_RD2, R15, A2)

	begin

		if (A2 = "1111") then
			RD2 <= R15;
		else
			RD2 <= RF_RD2;
		end if;

	end process;

end behavioral;


