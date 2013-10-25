-- The MIT License (MIT)
--
-- Copyright (c) 2013 Michael Lancaster
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.

-- SMT dual-port RAM
-- Michael Lancaster <mjl152@uclive.ac.nz>
-- 4 October 2013

library ieee;
use ieee.std_logic_1164.all;

use IEEE.NUMERIC_STD.ALL;

entity smt_ram is
	port 
	(	
		DATA0	: in std_logic_vector(7 downto 0);
		DATA1	: in std_logic_vector(7 downto 0);
		ADDR0	: in std_logic_vector(7 downto 0);
		ADDR1	: in std_logic_vector(7 downto 0);
		SET0	: in std_logic := '0';
		SET1	: in std_logic := '0';
		RAM_CLOCK		: in std_logic;
		OUT0		 : out std_logic_vector(7 downto 0);
		OUT1		 : out std_logic_vector(7 downto 0);
		OUT2     : out std_logic_vector(7 downto 0);
		OUT3     : out std_logic_vector(7 downto 0);
		OUT4     : out std_logic_vector(7 downto 0);
		OUT5     : out std_logic_vector(7 downto 0);
		OUT6     : out std_logic_vector(7 downto 0);
		OUT7     : out std_logic_vector(7 downto 0);
		OUTADDR0 : in std_logic_vector(7 downto 0);
		OUTADDR1 : in std_logic_vector(7 downto 0)
	);
	
	type memory_t is array (255 downto 0) of std_logic_vector(7 downto 0);
	
  function initialize_ram return memory_t is
  variable mem_temp : memory_t;
  begin
  mem_temp := (others => (others => '0'));
  mem_temp(0)  := std_logic_vector(to_signed(6, 8));
  mem_temp(1)  := std_logic_vector(to_signed(68, 8));
  -- fibonacci program thread 0
  mem_temp(4)  := std_logic_vector(to_signed(3, 8));
  mem_temp(5)  := std_logic_vector(to_signed(69, 8));
  mem_temp(6)  := std_logic_vector(to_signed(70, 8));
  mem_temp(7)  := std_logic_vector(to_signed(71, 8));
  mem_temp(8)  := std_logic_vector(to_signed(2, 8));
  mem_temp(9)  := std_logic_vector(to_signed(69, 8));
  mem_temp(10)  := std_logic_vector(to_signed(70, 8));
  mem_temp(11)  := std_logic_vector(to_signed(71, 8));
  mem_temp(12)  := std_logic_vector(to_signed(4, 8));
  mem_temp(13)  := std_logic_vector(to_signed(72, 8));
  mem_temp(14)  := std_logic_vector(to_signed(73, 8));
  mem_temp(17)  := std_logic_vector(to_signed(73, 8));
  mem_temp(18)  := std_logic_vector(to_signed(74, 8));
  mem_temp(19)  := std_logic_vector(to_signed(73, 8));
  mem_temp(20)  := std_logic_vector(to_signed(4, 8));
  mem_temp(21)  := std_logic_vector(to_signed(74, 8));
  mem_temp(22)  := std_logic_vector(to_signed(72, 8));
  mem_temp(25)  := std_logic_vector(to_signed(69, 8));
  mem_temp(26)  := std_logic_vector(to_signed(75, 8));
  mem_temp(27)  := std_logic_vector(to_signed(69, 8));
  mem_temp(28)  := std_logic_vector(to_signed(5, 8));
  mem_temp(29)  := std_logic_vector(to_signed(76, 8));
  mem_temp(32)  := std_logic_vector(to_signed(7, 8));
 -- factorial program thread 0
 --   mem_temp(4)  := std_logic_vector(to_signed(4, 8));
 --   mem_temp(5)  := std_logic_vector(to_signed(77, 8));
 --   mem_temp(6)  := std_logic_vector(to_signed(78, 8));
 --   mem_temp(8)  := std_logic_vector(to_signed(3, 8));
 --   mem_temp(9)  := std_logic_vector(to_signed(78, 8));
 --   mem_temp(10)  := std_logic_vector(to_signed(79, 8));
 --   mem_temp(11)  := std_logic_vector(to_signed(76, 8));
 --   mem_temp(12)  := std_logic_vector(to_signed(7, 8));
 --   mem_temp(16)  := std_logic_vector(to_signed(2, 8));
 --   mem_temp(17)  := std_logic_vector(to_signed(78, 8));
 --  mem_temp(18)  := std_logic_vector(to_signed(79, 8));
 --   mem_temp(19)  := std_logic_vector(to_signed(76, 8));
  --  mem_temp(20)  := std_logic_vector(to_signed(7, 8));
  --  mem_temp(25)  := std_logic_vector(to_signed(78, 8));
 --   mem_temp(26)  := std_logic_vector(to_signed(80, 8));
  --  mem_temp(27)  := std_logic_vector(to_signed(78, 8));
 ---   mem_temp(28)  := std_logic_vector(to_signed(1, 8));
 --   mem_temp(29)  := std_logic_vector(to_signed(77, 8));
--	 mem_temp(30)  := std_logic_vector(to_signed(78, 8));
--	 mem_temp(31)  := std_logic_vector(to_signed(77, 8));
 --   mem_temp(32)  := std_logic_vector(to_signed(5, 8));
--	 mem_temp(33)  := std_logic_vector(to_signed(81, 8));
  -- factorial program thread 1
 -- mem_temp(36)  := std_logic_vector(to_signed(4, 8));
 -- mem_temp(37)  := std_logic_vector(to_signed(77, 8));
 -- mem_temp(38)  := std_logic_vector(to_signed(78, 8));
 -- mem_temp(40)  := std_logic_vector(to_signed(3, 8));
 -- mem_temp(41)  := std_logic_vector(to_signed(78, 8));
 -- mem_temp(42)  := std_logic_vector(to_signed(79, 8));
 -- mem_temp(43)  := std_logic_vector(to_signed(76, 8));
 -- mem_temp(44)  := std_logic_vector(to_signed(7, 8));
  --mem_temp(48)  := std_logic_vector(to_signed(2, 8));
 -- mem_temp(49)  := std_logic_vector(to_signed(78, 8));
 -- mem_temp(50)  := std_logic_vector(to_signed(80, 8));
 -- mem_temp(51)  := std_logic_vector(to_signed(76, 8));
 -- mem_temp(52)  := std_logic_vector(to_signed(7, 8));
 --  mem_temp(53)  := std_logic_vector(to_signed(76, 8));
 -- mem_temp(57)  := std_logic_vector(to_signed(78, 8));
  --mem_temp(58)  := std_logic_vector(to_signed(80, 8));
 -- mem_temp(59)  := std_logic_vector(to_signed(78, 8));
 -- mem_temp(60)  := std_logic_vector(to_signed(1, 8));
 -- mem_temp(61)  := std_logic_vector(to_signed(77, 8));
 -- mem_temp(62)  := std_logic_vector(to_signed(78, 8));
--  mem_temp(63)  := std_logic_vector(to_signed(77, 8));
 -- mem_temp(64)  := std_logic_vector(to_signed(5, 8));
 -- mem_temp(65)  := std_logic_vector(to_signed(81, 8));
 -- second Fibonacci thread
  mem_temp(36)  := std_logic_vector(to_signed(3, 8));
  mem_temp(37)  := std_logic_vector(to_signed(69, 8));
  mem_temp(38)  := std_logic_vector(to_signed(70, 8));
  mem_temp(39)  := std_logic_vector(to_signed(71, 8));
  mem_temp(40)  := std_logic_vector(to_signed(2, 8));
  mem_temp(41)  := std_logic_vector(to_signed(69, 8));
  mem_temp(42)  := std_logic_vector(to_signed(70, 8));
  mem_temp(43)  := std_logic_vector(to_signed(71, 8));
  mem_temp(44)  := std_logic_vector(to_signed(4, 8));
  mem_temp(45)  := std_logic_vector(to_signed(72, 8));
  mem_temp(46)  := std_logic_vector(to_signed(73, 8));
  mem_temp(49)  := std_logic_vector(to_signed(73, 8));
  mem_temp(50)  := std_logic_vector(to_signed(74, 8));
  mem_temp(51)  := std_logic_vector(to_signed(73, 8));
  mem_temp(52)  := std_logic_vector(to_signed(4, 8));
  mem_temp(53)  := std_logic_vector(to_signed(74, 8));
  mem_temp(54)  := std_logic_vector(to_signed(72, 8));
  mem_temp(56)  := std_logic_vector(to_signed(0, 8));
  mem_temp(57)  := std_logic_vector(to_signed(69, 8));
  mem_temp(58)  := std_logic_vector(to_signed(75, 8));
  mem_temp(59)  := std_logic_vector(to_signed(69, 8));
  mem_temp(60)  := std_logic_vector(to_signed(5, 8));
  mem_temp(61)  := std_logic_vector(to_signed(76, 8));
  mem_temp(64)  := std_logic_vector(to_signed(7, 8));
  -- data section
  mem_temp(68)  := std_logic_vector(to_signed(34, 8));
  mem_temp(70)  := std_logic_vector(to_signed(10, 8)); -- n
  mem_temp(71)  := std_logic_vector(to_signed(32, 8));
  mem_temp(73)  := std_logic_vector(to_signed(1, 8));
  mem_temp(75)  := std_logic_vector(to_signed(1, 8));
  mem_temp(76)  := std_logic_vector(to_signed(4, 8));
  mem_temp(78)  := std_logic_vector(to_signed(10, 8)); -- N
  mem_temp(80)  := std_logic_vector(to_signed(-1, 8));
  mem_temp(81)  := std_logic_vector(to_signed(36, 8));   
 return mem_temp;
end initialize_ram;
	
end smt_ram;

architecture behavioural of smt_ram is
	shared variable ram : memory_t := initialize_ram;
 

begin

	-- Port 1
						
	process(RAM_CLOCK)
	begin
		if(rising_edge(RAM_CLOCK)) then 
			if(SET0 = '1') then
				ram(to_integer(unsigned(ADDR0))) := DATA0;
			end if;
		end if;
	end process;
	
	-- Port 3
	process(RAM_CLOCK)
	begin
		if(rising_edge(RAM_CLOCK)) then
			if(SET1 = '1') then
				ram(to_integer(unsigned(ADDR1))) := DATA1;
			end if;
		end if;
	end process;
	
	-- Outputs
	process(RAM_CLOCK)
	begin
	  if (rising_edge(RAM_CLOCK)) then
	    OUT0 <= ram(to_integer(unsigned(OUTADDR0)));
		 OUT1 <= ram(to_integer(unsigned(ram(to_integer(unsigned(OUTADDR0)) + 1))));
		 OUT2 <= ram(to_integer(unsigned(ram(to_integer(unsigned(OUTADDR0)) + 2))));
		 OUT3 <= ram(to_integer(unsigned(ram(to_integer(unsigned(OUTADDR0)) + 3))));
		 OUT4 <= ram(to_integer(unsigned(OUTADDR1)));
		 OUT5 <= ram(to_integer(unsigned(ram(to_integer(unsigned(OUTADDR1)) + 1))));
		 OUT6 <= ram(to_integer(unsigned(ram(to_integer(unsigned(OUTADDR1)) + 2))));
		 OUT7 <= ram(to_integer(unsigned(ram(to_integer(unsigned(OUTADDR1)) + 3))));
	  end if;
	end process;

end behavioural;
