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

-- SMT test bench
-- Michael Lancaster <mjl152@uclive.ac.nz>
-- 4 October 2013

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY cputestbench IS
END cputestbench;
 
ARCHITECTURE behavior OF cputestbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT smt_control_unit
    PORT(
         CLOCK                  : IN  std_logic;
         INSTRUCTION_0          : OUT  std_logic_vector(7 downto 0);
         INSTRUCTION_1          : OUT  std_logic_vector(7 downto 0);
			   INSTRUCTION_POINTER_0,
         INSTRUCTION_POINTER_1,
         ARG1_0, ARG1_1,
         ARG2_0, ARG2_1,
         ARG3_0, ARG3_1         : OUT std_logic_vector (7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK : std_logic := '0';

 	--Outputs
	signal INSTRUCTION_0, 
         INSTRUCTION_1,
         INSTRUCTION_POINTER_0, 
         INSTRUCTION_POINTER_1, 
         ARG1_0, ARG1_1,
         ARG2_0, ARG2_1,
         ARG3_0, ARG3_1             : std_logic_vector(7 downto 0);
	signal NUM_CYCLES_0, NUM_CYCLES_1 : std_logic_vector (63 downto 0);
  shared variable number_cycles_0, number_cycles_1 : integer := 0;
  -- Clock period definitions
  constant CLOCK_period : time := 10 ps;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: smt_control_unit PORT MAP (
          CLOCK => CLOCK,
          INSTRUCTION_0 => INSTRUCTION_0,
          INSTRUCTION_1 => INSTRUCTION_1,
			    INSTRUCTION_POINTER_0 => INSTRUCTION_POINTER_0,
			    INSTRUCTION_POINTER_1 => INSTRUCTION_POINTER_1,
			    ARG1_0 => ARG1_0,
			    ARG1_1 => ARG1_1,
			    ARG2_0 => ARG2_0,
			    ARG2_1 => ARG2_1,
			    ARG3_0 => ARG3_0,
			    ARG3_1 => ARG3_1
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
	
  -- logic to calculate the number of cycles per thread
	process (INSTRUCTION_0)
	begin
	  if (INSTRUCTION_0 = "00000101") then
	    number_cycles_0 := number_cycles_0 + 1;
	  end if;
     NUM_CYCLES_0 <= std_logic_vector(to_unsigned(number_cycles_0, 64));	  
	end process;
 
	process (INSTRUCTION_1)
	begin
	  if (INSTRUCTION_1 = "00000101") then
	    number_cycles_1 := number_cycles_1 + 1;
	  end if;
	  NUM_CYCLES_1 <= std_logic_vector(to_unsigned(number_cycles_1, 64));	  
	end process;


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLOCK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
