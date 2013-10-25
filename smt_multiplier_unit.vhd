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

-- SMT multiplier unit
-- Michael Lancaster <mjl152@uclive.ac.nz>
-- 4 October 2013


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity smt_multiplier_unit is
    Port ( MULTIPLIER_A : in   STD_LOGIC_VECTOR (7 downto 0);
           MULTIPLIER_B : in   STD_LOGIC_VECTOR (7 downto 0);
           MULTIPLIER_C : out  STD_LOGIC_VECTOR (7 downto 0));
end smt_multiplier_unit;

architecture Behavioral of smt_multiplier_unit is
	signal result : std_logic_vector (15 downto 0);
begin
  result <= std_logic_vector (signed(MULTIPLIER_A) * signed (MULTIPLIER_B));
  MULTIPLIER_C <= result(7 downto 0);

end Behavioral;

