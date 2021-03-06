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

-- SMT half adder
-- Michael Lancaster <mjl152@uclive.ac.nz>
-- We don't care about carries at the moment, not really relevant to testing
-- the performance of SMT
-- 4 October 2013

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity smt_adder_unit is
    Port ( ADDER_A : in   STD_LOGIC_VECTOR (7 downto 0);
           ADDER_B : in   STD_LOGIC_VECTOR (7 downto 0);
           ADDER_S : out  STD_LOGIC_VECTOR (7 downto 0));
end smt_adder_unit;

architecture Behavioral of smt_adder_unit is
  component smt_full_adder
    Port (A, B, Cin : in  STD_LOGIC;
	  S, Cout   : out STD_LOGIC);
  end component;
  component smt_half_adder
    Port (A, B      : in  STD_LOGIC;
	  S, Cout   : out STD_LOGIC);
  end component;
  signal CARRIERS   : STD_LOGIC_VECTOR (7 downto 0);
  
  begin
    Half:  smt_half_adder port map (ADDER_A(0), ADDER_B(0), ADDER_S(0),
                                    CARRIERS(0));
    Full1: smt_full_adder port map (ADDER_A(1), ADDER_B(1), CARRIERS(0),
                                    ADDER_S(1), CARRIERS(1));
    Full2: smt_full_adder port map (ADDER_A(2), ADDER_B(2), CARRIERS(1),
                                    ADDER_S(2), CARRIERS(2));
    Full3: smt_full_adder port map (ADDER_A(3), ADDER_B(3), CARRIERS(2),
                                    ADDER_S(3), CARRIERS(3));
    Full4: smt_full_adder port map (ADDER_A(4), ADDER_B(4), CARRIERS(3),
                                    ADDER_S(4), CARRIERS(4));
    Full5: smt_full_adder port map (ADDER_A(5), ADDER_B(5), CARRIERS(4),
                                    ADDER_S(5), CARRIERS(5));
    Full6: smt_full_adder port map (ADDER_A(6), ADDER_B(6), CARRIERS(5),
                                    ADDER_S(6), CARRIERS(6));
    Full7: smt_full_adder port map (ADDER_A(7), ADDER_B(7), CARRIERS(6),
                                    ADDER_S(7), CARRIERS(7));
end Behavioral;

