----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:28:35 12/12/2019 
-- Design Name: 
-- Module Name:    Debounce - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Debounce is
    Port ( clk : in  STD_LOGIC;
         reset : in  STD_LOGIC;
			in_value : IN STD_LOGIC_VECTOR(2 downto 0);
			in_sel : IN STD_LOGIC_VECTOR(2 downto 0);
			out_value : OUT STD_LOGIC_VECTOR(2 downto 0);
			out_sel : OUT STD_LOGIC_VECTOR(2 downto 0)
			);
end Debounce;

architecture Behavioral of Debounce is
		
	constant c_Debounce_LIMIT : integer:=250000;
	signal r_count1,r_count2,r_count3,r_count4,r_count5,r_count6 : integer range 0 to c_Debounce_LIMIT :=0;
	signal r_state1,r_state2,r_state3,r_state4,r_state5,r_state6 : std_logic :='0';

begin

process(reset,clk)
begin
	if(reset='1') then
		out_value(0) <= '0';
	elsif(rising_edge(clk)) then
		if(in_value(0) /= r_state1 and r_count1 < c_Debounce_LIMIT) then
			r_count1 <= r_count1+1;
		elsif r_count1 = c_Debounce_LIMIT then
			r_state1 <= in_value(0);
			r_count1 <= 0;
			out_value(0) <= not r_state1;
		else
			r_count1 <= 0;
		end if;
	end if;	
end process;

process(reset,clk)
begin
	if(reset='1') then
		out_value(1) <= '0';
	elsif(rising_edge(clk)) then
		if(in_value(1) /= r_state2 and r_count2 < c_Debounce_LIMIT) then
			r_count2 <= r_count2+1;
		elsif r_count2 = c_Debounce_LIMIT then
			r_state2 <= in_value(1);
			r_count2 <= 0;
			out_value(1) <= not r_state2;
		else
			r_count2 <= 0;
		end if;
	end if;
end process;

process(reset,clk)
begin
	if(reset='1') then
		out_value(2) <= '0';
	elsif(rising_edge(clk)) then
		if(in_value(2) /= r_state3 and r_count3 < c_Debounce_LIMIT) then
			r_count3 <= r_count3+1;
		elsif r_count3 = c_Debounce_LIMIT then
			r_state3 <= in_value(2);
			r_count3 <= 0;
			out_value(2) <= not r_state3;
		else
			r_count3 <= 0;
		end if;
	end if;
end process;

process(reset,clk)
begin
	if(reset='1') then
		out_sel(0) <= '0';
	elsif(rising_edge(clk)) then
		if(in_sel(0) /= r_state4 and r_count4 < c_Debounce_LIMIT) then
			r_count4 <= r_count4+1;
		elsif r_count4 = c_Debounce_LIMIT then
			r_state4 <= in_sel(0);
			r_count4 <= 0;
			out_sel(0) <= not r_state4;
		else
			r_count4 <= 0;
		end if;
	end if;
end process;

process(reset,clk)
begin
	if(reset='1') then
		out_sel(1) <= '0';
	elsif(rising_edge(clk)) then
		if(in_sel(1) /= r_state5 and r_count5 < c_Debounce_LIMIT) then
			r_count5 <= r_count5+1;
		elsif r_count5 = c_Debounce_LIMIT then
			r_state5 <= in_sel(1);
			r_count5 <= 0;
			out_sel(1) <= not r_state5;
		else
			r_count5 <= 0;
		end if;
	end if;
end process;

process(reset,clk)
begin
	if(reset='1') then
		out_sel(2) <= '0';
	elsif(rising_edge(clk)) then
		if(in_sel(2) /= r_state6 and r_count6 < c_Debounce_LIMIT) then
			r_count6 <= r_count6+1;
		elsif r_count6 = c_Debounce_LIMIT then
			r_state6 <= in_sel(2);
			r_count6 <= 0;
			out_sel(2) <= not r_state6;
		else
			r_count6 <= 0;
		end if;
	end if;
end process;

end Behavioral;

