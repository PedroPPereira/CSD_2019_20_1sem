----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:02:23 12/06/2019 
-- Design Name: 
-- Module Name:    binary_to_bcd - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


package BCD_package is
	function binary_to_bcd (signal number : in STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR;
end BCD_package;


package body BCD_package is
	function binary_to_bcd (signal number : in STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR is
	variable i : integer := 0;
	variable bcd : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	variable number1 : STD_LOGIC_VECTOR(7 downto 0) := number;
begin
	for i in 0 to 7 loop
		bcd(11 downto 1) := bcd(10 downto 0);
		bcd(0) := number1(7);
		number1(7 downto 1) := number1(6 downto 0);
		number1(0) := '0';
		
		if(i<7 and bcd(3 downto 0) > "0100") then
			bcd(3 downto 0) := bcd(3 downto 0) + "0011";
		end if;
		
		if(i<7 and bcd(7 downto 4) > "0100") then
			bcd(7 downto 4) := bcd(7 downto 4) + "0011";
		end if;		

		if(i<7 and bcd(11 downto 8) > "0100") then
			bcd(11 downto 8) := bcd(11 downto 8) + "0011";
		end if;
	end loop;
return bcd;
end binary_to_bcd;
end BCD_package;
