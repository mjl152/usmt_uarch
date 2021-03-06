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

-- SMT control unit
-- Michael Lancaster <mjl152@uclive.ac.nz>
-- 4 October 2013

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity smt_control_unit is
  Port ( CLOCK                 : in   STD_LOGIC;
         INSTRUCTION_0         : out STD_LOGIC_VECTOR (7 downto 0) := "00000110";
         INSTRUCTION_1         : out STD_LOGIC_VECTOR (7 downto 0) := "00000111";
         INSTRUCTION_POINTER_0 : out STD_LOGIC_VECTOR (7 downto 0) := "00000000";
         INSTRUCTION_POINTER_1 : out STD_LOGIC_VECTOR (7 downto 0) := "00000000";
         ARG1_0                : out STD_LOGIC_VECTOR (7 downto 0) := "01000100";
         ARG1_1                : out STD_LOGIC_VECTOR (7 downto 0) := "00000000";
         ARG2_0                : out STD_LOGIC_VECTOR (7 downto 0) := "00000000";
         ARG2_1                : out STD_LOGIC_VECTOR (7 downto 0) := "00000000";
         ARG3_0                : out STD_LOGIC_VECTOR (7 downto 0 ):= "00000000";
         ARG3_1                : out STD_LOGIC_VECTOR (7 downto 0) := "00000000");
  type smt_thread_register is array (1 downto 0) of std_logic_vector(7 downto 0);
  function is_instruction(INSTRUCTION_REGISTER : in std_logic_vector(7 downto 0);
                          INSTRUCTION          : in integer range 0 to 7)
                          return STD_LOGIC is
  begin
    if (INSTRUCTION_REGISTER = std_logic_vector(to_unsigned(INSTRUCTION, 8))) then
      return '1';
    end if;
    return '0';
  end is_instruction;
	
  function initialize_register_1 return smt_thread_register is
  variable temp : smt_thread_register;
  begin
    temp(0) := std_logic_vector(to_signed(6, 8));
    temp(1) := std_logic_vector(to_signed(7, 8));
    return temp;
  end initialize_register_1;

  function initialize_register_2 return smt_thread_register is
  variable temp : smt_thread_register;
  begin
    temp(0) := std_logic_vector(to_signed(36, 8));
    temp(1) := std_logic_vector(to_signed(0, 8));
    return temp;
  end initialize_register_2;

  function initialize_zeros return smt_thread_register is
  variable temp : smt_thread_register;
  begin
    temp(0) := std_logic_vector(to_signed(0, 8));
    temp(1) := std_logic_vector(to_signed(0, 8));
    return temp;
  end initialize_zeros;

  function increment_instruction_pointer(instruction_pointer : in std_logic_vector (7 downto 0))
                                         return std_logic_vector is
  begin
    return std_logic_vector(signed(instruction_pointer) + 4);
  end increment_instruction_pointer;
end smt_control_unit;


architecture Behavioral of smt_control_unit is
  component smt_adder_unit
      Port ( ADDER_A, ADDER_B : in   STD_LOGIC_VECTOR (7 downto 0);
             ADDER_S          : out  STD_LOGIC_VECTOR (7 downto 0));
  end component;
  component smt_multiplier_unit
      Port (MULTIPLIER_A, MULTIPLIER_B  : in   STD_LOGIC_VECTOR (7 downto 0);
		        MULTIPLIER_C                : out  STD_LOGIC_VECTOR (7 downto 0));
  end component;
	component smt_ram is
		port 
		(	
      DATA0      : in  std_logic_vector(7 downto 0);
      DATA1      : in  std_logic_vector(7 downto 0);
      ADDR0      : in  std_logic_vector(7 downto 0);
      ADDR1      : in  std_logic_vector(7 downto 0);
      SET0       : in  std_logic := '1';
      SET1       : in  std_logic := '1';
      RAM_CLOCK  : in  std_logic;
      OUT0       : out std_logic_vector(7 downto 0);
      OUT1       : out std_logic_vector(7 downto 0);
      OUT2       : out std_logic_vector(7 downto 0);
      OUT3       : out std_logic_vector(7 downto 0);
      OUT4       : out std_logic_vector(7 downto 0) := "00000111";
      OUT5       : out std_logic_vector(7 downto 0);
      OUT6       : out std_logic_vector(7 downto 0);
      OUT7       : out std_logic_vector(7 downto 0);
      OUTADDR0   : in  std_logic_vector(7 downto 0);
      OUTADDR1   : in  std_logic_vector(7 downto 0)
		);
		
	end component;
  component smt_instruction_handler
  Port (HANDLER_INSTRUCTION          : in  std_logic_vector(7 downto 0);
        HANDLER_INSTRUCTION_POINTER  : in  std_logic_vector(7 downto 0);
        HANDLER_ADDR1                : in  std_logic_vector(7 downto 0);
        HANDLER_ADDR2                : in  std_logic_vector(7 downto 0);
        HANDLER_ADDR3                : in  std_logic_vector(7 downto 0);
        HANDLER_CLOCK                : in  std_logic;
        HANDLER_OUTPUT               : out std_logic_vector(7 downto 0);
        HANDLER_INDEX                : out std_logic_vector(7 downto 0);
        HANDLER_SET                  : out std_logic;
        HANDLER_INSTRUCTION_POINTER_INTERMEDIATE : out std_logic_vector(7 downto 0));
  end component;
  shared variable smt_thread_instruction_pointer : smt_thread_register := initialize_zeros;
  shared variable smt_thread_instruction         : smt_thread_register := initialize_register_1;
  shared variable smt_thread_arg1                : smt_thread_register := initialize_register_2;
  shared variable smt_thread_arg2                : smt_thread_register := initialize_zeros;
  shared variable smt_thread_arg3                : smt_thread_register := initialize_zeros;
  shared variable starting : std_logic := '1';
  signal ADDER_A, ADDER_B, ADDER_S, MULTIPLIER_A, MULTIPLIER_B, MULTIPLIER_C,
         HANDLER_INSTRUCTION, HANDLER_INSTRUCTION_POINTER, HANDLER_ADDR1, HANDLER_ADDR2,
		     HANDLER_ADDR3, HANDLER_OUTPUT, HANDLER_INDEX, DATA0, DATA1, ADDR0, ADDR1, OUT0,
			   OUT1, OUT2, OUT3, OUT4, OUT5, OUT6, OUT7, OUTADDR0, OUTADDR1 : std_logic_vector(7 downto 0);
  signal SET0, SET1, RAM_CLOCK, HANDLER_SET, MULTIPLIER_CLOCK, ADDER_C, HANDLER_CLOCK : std_logic;
  signal HANDLER_INSTRUCTION_POINTER_INTERMEDIATE : std_logic_vector(7 downto 0);
  begin
    adder1 : smt_adder_unit Port Map (ADDER_A => ADDER_A, ADDER_B => ADDER_B, ADDER_S => ADDER_S);
    multiplier1 : smt_multiplier_unit Port Map (MULTIPLIER_A => MULTIPLIER_A,
                                                MULTIPLIER_B => MULTIPLIER_B,
                                                MULTIPLIER_C => MULTIPLIER_C);
    handler1    : smt_instruction_handler Port Map (HANDLER_INSTRUCTION => HANDLER_INSTRUCTION,
                                                    HANDLER_INSTRUCTION_POINTER => HANDLER_INSTRUCTION_POINTER,
                                                    HANDLER_ADDR1 => HANDLER_ADDR1,
                                                    HANDLER_ADDR2 => HANDLER_ADDR2,
                                                    HANDLER_ADDR3 => HANDLER_ADDR3,
                                                    HANDLER_CLOCK => HANDLER_CLOCK,
                                                    HANDLER_OUTPUT => HANDLER_OUTPUT,
                                                    HANDLER_INDEX => HANDLER_INDEX,
                                                    HANDLER_SET => HANDLER_SET,
                                                    HANDLER_INSTRUCTION_POINTER_INTERMEDIATE =>
                                                    HANDLER_INSTRUCTION_POINTER_INTERMEDIATE);
    ram1   : smt_ram Port Map (DATA0 => DATA0, DATA1=>DATA1, ADDR0 => ADDR0,
                               ADDR1 => ADDR1, SET0 => SET0, SET1 => SET1,
                               RAM_CLOCK => RAM_CLOCK, OUT0 => OUT0,
                               OUT1 => OUT1, OUT2 => OUT2, OUT3 => OUT3,
                               OUT4 => OUT4, OUT5 => OUT5, OUT6 => OUT6,
                               OUT7 => OUT7, OUTADDR0 => OUTADDR0,
                               OUTADDR1 => OUTADDR1);
  process (CLOCK) is
  begin
    RAM_CLOCK <= CLOCK;
    HANDLER_CLOCK <= CLOCK;
    if rising_edge(CLOCK) then
      if starting = '0' then
        smt_thread_instruction(0) := OUT0;
        smt_thread_instruction(1) := OUT4;
        smt_thread_arg1(0)        := OUT1;
        smt_thread_arg2(0)        := OUT2;
        smt_thread_arg3(0)        := OUT3;
        smt_thread_arg1(1)        := OUT5;
        smt_thread_arg2(1)        := OUT6;
        smt_thread_arg3(1)        := OUT7;
		  else
        starting := '0';
		  end if;
     INSTRUCTION_0 <= smt_thread_instruction(0);
     INSTRUCTION_1 <= smt_thread_instruction(1);
     INSTRUCTION_POINTER_0 <= smt_thread_instruction_pointer(0);
     INSTRUCTION_POINTER_1 <= smt_thread_instruction_pointer(1);
     ARG1_0 <= smt_thread_arg1(0);
     ARG1_1 <= smt_thread_arg1(1);
     ARG2_0 <= smt_thread_arg2(0);
     ARG2_1 <= smt_thread_arg2(1);
     ARG3_0 <= smt_thread_arg3(0);
     ARG3_1 <= smt_thread_arg3(1);
     case smt_thread_instruction(0) is
       when "00000000" =>
         ADDER_A <= smt_thread_arg1(0);
         ADDER_B <= smt_thread_arg2(0);
         ADDR0   <= smt_thread_arg3(0);
         DATA0   <= ADDER_S;
         SET0    <= '1';
         smt_thread_instruction_pointer(0) := increment_instruction_pointer(smt_thread_instruction_pointer(0));
         case smt_thread_instruction(1) is
           when "00000010" =>
             -- thread 0 ifeq
             if smt_thread_arg1(1) = smt_thread_arg2(1) then
               smt_thread_instruction_pointer(1) := smt_thread_arg3(1);
             else
               smt_thread_instruction_pointer(1) := increment_instruction_pointer(smt_thread_instruction_pointer(1));
             end if;		  
           when "00000011" =>
             -- thread 0 ifgt
             if smt_thread_arg1(1) > smt_thread_arg2(1) then
               smt_thread_instruction_pointer(1) := smt_thread_arg3(1);
             else
               smt_thread_instruction_pointer(1) := increment_instruction_pointer(smt_thread_instruction_pointer(1));
             end if;		  
           when "00000100" =>
             -- thread 0 set
             DATA1 <= smt_thread_arg2(1);
             ADDR1 <= smt_thread_arg1(1);
             SET1  <= '1';
             smt_thread_instruction_pointer(1) := increment_instruction_pointer(smt_thread_instruction_pointer(1));		  
           when "00000101" =>
             smt_thread_instruction_pointer(1) := smt_thread_arg1(1);  
           when others =>
         end case;
       when "00000001" =>			
         MULTIPLIER_A <= smt_thread_arg1(0);
         MULTIPLIER_B <= smt_thread_arg2(0);
         ADDR0        <= smt_thread_arg3(0);
         DATA0        <= MULTIPLIER_C;
         SET0         <= '1';
         smt_thread_instruction_pointer(0) := increment_instruction_pointer(smt_thread_instruction_pointer(0));	 
       when others =>
         case smt_thread_instruction(0) is
           when "00000010" =>
             -- thread 0 ifeq
             if smt_thread_arg1(0) = smt_thread_arg2(0) then
               smt_thread_instruction_pointer(0) := smt_thread_arg3(0);
             else
               smt_thread_instruction_pointer(0) := increment_instruction_pointer(smt_thread_instruction_pointer(0));
             end if;		  
           when "00000011" =>
             -- thread 0 ifgt
             if smt_thread_arg1(0) > smt_thread_arg2(0) then
               smt_thread_instruction_pointer(0) := smt_thread_arg3(0);
             else
               smt_thread_instruction_pointer(0) := increment_instruction_pointer(smt_thread_instruction_pointer(0));
             end if;		  
           when "00000100" =>
             -- thread 0 set
             DATA0 <= smt_thread_arg2(0);
             ADDR0 <= smt_thread_arg1(0);
             SET0  <= '1';
             smt_thread_instruction_pointer(0) := increment_instruction_pointer(smt_thread_instruction_pointer(0));		  
           when "00000101" =>
             smt_thread_instruction_pointer(0) := smt_thread_arg1(0);
           when "00000110" =>
             smt_thread_instruction_pointer(1) := smt_thread_arg1(0);
             smt_thread_instruction_pointer(0) := increment_instruction_pointer(smt_thread_instruction_pointer(0));		  
           when "00000111" =>		  
           when others =>
         end case;
         if smt_thread_instruction(1) = "00000000" then
           ADDER_A <= smt_thread_arg1(1);
           ADDER_B <= smt_thread_arg2(1);
           ADDR1   <= smt_thread_arg3(1);
           DATA1   <= ADDER_S;
           SET1    <= '1';
           smt_thread_instruction_pointer(1) := increment_instruction_pointer(smt_thread_instruction_pointer(1));				
         elsif smt_thread_instruction(1) = "00000001" then
           MULTIPLIER_A <= smt_thread_arg1(1);
           MULTIPLIER_B <= smt_thread_arg2(1);
           ADDR1        <= smt_thread_arg3(1);
           DATA1        <= MULTIPLIER_C;
           SET1         <= '1';
           smt_thread_instruction_pointer(1) := increment_instruction_pointer(smt_thread_instruction_pointer(1));			  
         end if;
       end case;
     end if;
   OUTADDR0 <= smt_thread_instruction_pointer(0);
	 OUTADDR1 <= smt_thread_instruction_pointer(1);
	 
  end process;

end Behavioral;

