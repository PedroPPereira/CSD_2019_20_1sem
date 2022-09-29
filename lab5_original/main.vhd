----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:49:07 10/24/2019 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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
use work.BCD_package.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( CLK : in  STD_LOGIC;
         RESET : in  STD_LOGIC;
		   --button1 : in STD_LOGIC;
			enabled : IN STD_LOGIC;
         sel : in STD_LOGIC_VECTOR (2 downto 0);
         value : in STD_LOGIC_VECTOR (2 downto 0);
         RGB : out STD_LOGIC_VECTOR (2 downto 0);
         HS : out  STD_LOGIC;
         VS : out  STD_LOGIC;
		   ld4 : out  STD_LOGIC;
		   ld3 : out  STD_LOGIC;
		   ld2 : out  STD_LOGIC;
		   ld1 : out  STD_LOGIC;
		   ld0 : out  STD_LOGIC);
end main;


architecture Behavioral of main is
	 component Debounce is Port( 
			clk : in  STD_LOGIC;
         reset : in  STD_LOGIC;
			in_value : IN STD_LOGIC_VECTOR(2 downto 0);
			in_sel : IN STD_LOGIC_VECTOR(2 downto 0);
			out_value : OUT STD_LOGIC_VECTOR(2 downto 0);
			out_sel : OUT STD_LOGIC_VECTOR(2 downto 0)
			);
	 end component;
	 
    component Parque is Port( --vhd file with petri nets model
        Clk : IN STD_LOGIC;
        PRES1_IN : IN STD_LOGIC;
        PRES2_IN : IN STD_LOGIC;
        TICKET_IN : IN STD_LOGIC;
        PRES1_OUT : IN STD_LOGIC;
        PRES2_OUT : IN STD_LOGIC;
        TICKET_OUT : IN STD_LOGIC;
        PRES1_IN_c : IN STD_LOGIC;
        PRES2_IN_c : IN STD_LOGIC;
        TICKET_IN_c : IN STD_LOGIC;
        PRES1_OUT_c : IN STD_LOGIC;
        PRES2_OUT_c : IN STD_LOGIC;
        TICKET_OUT_c : IN STD_LOGIC;
        AND_Y_up : IN STD_LOGIC;
        AND_X_up : IN STD_LOGIC;
        AND_X_down : IN STD_LOGIC;
        AND_Y_down : IN STD_LOGIC;
        CANC_IN : OUT STD_LOGIC;
        CANC_OUT : OUT STD_LOGIC;
        CANC_IN_c : OUT STD_LOGIC;
        CANC_OUT_c : OUT STD_LOGIC;
		  occupied_1 : OUT INTEGER RANGE 0 TO 100;
		  occupied_2 : OUT INTEGER RANGE 0 TO 100;
		  p1 : OUT STD_LOGIC_VECTOR(5 downto 0);
	     p2 : OUT STD_LOGIC_VECTOR(5 downto 0);
		  p3 : OUT STD_LOGIC_VECTOR(5 downto 0);
		  p4 : OUT STD_LOGIC_VECTOR(5 downto 0);
		  p5 : OUT STD_LOGIC_VECTOR(5 downto 0);
        ENABLE : IN STD_LOGIC;
        Reset : IN STD_LOGIC);
    end component;
	 
	signal clk25 : STD_LOGIC :='0';
	--constants for horizontal sync
	constant MAX_H_DISP : INTEGER := 639;
	constant MAX_H_FP : INTEGER := 655;
	constant MAX_H_RETRACE : INTEGER := 751;
	constant MAX_H_BP : INTEGER := 799;
	--constants for vertical sync
	constant MAX_V_DISP : INTEGER := 479;
	constant MAX_V_FP : INTEGER := 489;
	constant MAX_V_RETRACE : INTEGER := 491;
	constant MAX_V_BP : INTEGER := 520;
	--counters
	signal counter_hs : INTEGER range 0 to MAX_H_BP;
	signal counter_vs : INTEGER range 0 to MAX_V_BP;
	signal count_n1, count_n2, count_n3, count_n4 : INTEGER range 0 to 127:= 127;
	--numbers vectors 
	signal number1,number2,number3,number4 : STD_LOGIC_VECTOR (127 downto 0) := x"0000386cc6c6d6d6c6c66c3800000000";
	constant CONST_TEN : INTEGER := 10;
	signal bin_CAP_F1, bin_CAP_F2 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal int_num1, int_num2, int_num3, int_num4 : INTEGER := 0;
	signal temp_CAP_F1, temp_CAP_F2 : STD_LOGIC_VECTOR(11 downto 0);
	--background, number and park colours
	signal RGBbackground : STD_LOGIC_VECTOR (2 downto 0) := "000";
	signal RGBsides : STD_LOGIC_VECTOR (2 downto 0) := "111";
	signal RGBnumber1, RGBnumber2, RGBnumber3, RGBnumber4 : STD_LOGIC_VECTOR (2 downto 0) := "111";
	signal RGBpress1_in, RGBpress2_in, RGBpress1_out, RGBpress2_out, RGBticket_out, RGBticket_in, RGBgate_in, RGBgate_out : STD_LOGIC_VECTOR (2 downto 0) := "001";
	signal RGBpress1_in_c, RGBpress2_in_c, RGBpress1_out_c, RGBpress2_out_c, RGBticket_out_c, RGBticket_in_c, RGBgate_in_c, RGBgate_out_c : STD_LOGIC_VECTOR (2 downto 0) := "001";
	signal RGBand_y_up, RGBand_x_up, RGBand_x_down, RGBand_y_down  : STD_LOGIC_VECTOR (2 downto 0) := "001";
	--parking
	signal PRES1_IN, PRES2_IN, TICKET_IN, PRES1_OUT, PRES2_OUT, TICKET_OUT : STD_LOGIC := '0';
	signal PRES1_IN_c, PRES2_IN_c, TICKET_IN_c, PRES1_OUT_c, PRES2_OUT_c, TICKET_OUT_c : STD_LOGIC := '0';
	signal AND_Y_up, AND_X_up, AND_X_down, AND_Y_down : STD_LOGIC := '0';
	signal CANC_IN, CANC_OUT, CANC_IN_c, CANC_OUT_c : STD_LOGIC := '0';
	signal CAP_F1, CAP_F2 : INTEGER RANGE 0 TO 100;	
	signal p1,p2,p3,p4,p5 : STD_LOGIC_VECTOR(5 downto 0);
	--bool
	signal display_enabled : STD_LOGIC :='0';
	--debounce
	signal sg_value, sg_sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal r_switch_1,r_switch_2,r_switch_3,r_switch_4,r_switch_5,r_switch_6 : std_logic :='0';

begin
	

clock25M : process(CLK) --to work with 25MHz
begin
	if(CLK'event and CLK='1') then
		clk25 <= not clk25;
	end if;
end process;

HVS_counter : process(CLK, RESET)
begin
	if(RESET='1') then
		counter_hs <= 0;
		counter_vs <= 0;
	elsif(CLK'event and CLK='1') then 
		if(clk25='1') then
			if(counter_hs /= MAX_H_BP) then
				counter_hs <= counter_hs + 1;
			else
				counter_hs <= 0;
				counter_vs <= counter_vs + 1;
				if(counter_vs = MAX_V_BP) then
					counter_vs <= 0;
				end if;
			end if;
		end if;
	end if;
end process;
				
HS <= '0' when (counter_hs>MAX_H_FP and counter_hs<=MAX_H_RETRACE) else '1';
VS <= '0' when (counter_vs>MAX_V_FP and counter_vs<=MAX_V_RETRACE) else '1';
display_enabled <= '1' when (counter_hs<=MAX_H_DISP and counter_vs<=MAX_V_DISP) else '0';


sel_opts : process (CAP_F1,CAP_F2,CLK)
begin 
	if(CLK'event and CLK='1') then 
		if(clk25 = '1') then
			bin_CAP_F1 <= STD_LOGIC_VECTOR(to_unsigned(CAP_F1,bin_CAP_F1'length));
			bin_CAP_F2 <= STD_LOGIC_VECTOR(to_unsigned(CAP_F2,bin_CAP_F2'length));
			temp_CAP_F1 <= binary_to_bcd(bin_CAP_F1);
			temp_CAP_F2 <= binary_to_bcd(bin_CAP_F2);
			int_num2 <= to_integer(unsigned(temp_CAP_F2(3 downto 0)));
			int_num1 <= to_integer(unsigned(temp_CAP_F2(7 downto 4)));
			int_num4 <= to_integer(unsigned(temp_CAP_F1(3 downto 0)));
			int_num3 <= to_integer(unsigned(temp_CAP_F1(7 downto 4)));
			case int_num1 is			
				when 0 => number1 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
				when 1 => number1 <= x"00001838781818181818187e00000000"; --1
				when 2 => number1 <= x"00007cc6060c183060c0c6fe00000000"; --2
				when 3 => number1 <= x"00007cc606063c060606c67c00000000"; --3
				when 4 => number1 <= x"00000c1c3c6cccfe0c0c0c1e00000000"; --4
				when 5 => number1 <= x"0000fec0c0c0fc060606c67c00000000"; --5
				when 6 => number1 <= x"00003860c0c0fcc6c6c6c67c00000000"; --6
				when 7 => number1 <= x"0000fec606060c183030303000000000"; --7
				when 8 => number1 <= x"00007cc6c6c67cc6c6c6c67c00000000"; --8
				when 9 => number1 <= x"00007cc6c6c67e0606060c7800000000"; --9
				when others => number1 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
			end case;
			case int_num2 is			
				when 0 => number2 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
				when 1 => number2 <= x"00001838781818181818187e00000000"; --1
				when 2 => number2 <= x"00007cc6060c183060c0c6fe00000000"; --2
				when 3 => number2 <= x"00007cc606063c060606c67c00000000"; --3
				when 4 => number2 <= x"00000c1c3c6cccfe0c0c0c1e00000000"; --4
				when 5 => number2 <= x"0000fec0c0c0fc060606c67c00000000"; --5
				when 6 => number2 <= x"00003860c0c0fcc6c6c6c67c00000000"; --6
				when 7 => number2 <= x"0000fec606060c183030303000000000"; --7
				when 8 => number2 <= x"00007cc6c6c67cc6c6c6c67c00000000"; --8
				when 9 => number2 <= x"00007cc6c6c67e0606060c7800000000"; --9
				when others => number2 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
			end case;
			case int_num3 is			
				when 0 => number3 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
				when 1 => number3 <= x"00001838781818181818187e00000000"; --1
				when 2 => number3 <= x"00007cc6060c183060c0c6fe00000000"; --2
				when 3 => number3 <= x"00007cc606063c060606c67c00000000"; --3
				when 4 => number3 <= x"00000c1c3c6cccfe0c0c0c1e00000000"; --4
				when 5 => number3 <= x"0000fec0c0c0fc060606c67c00000000"; --5
				when 6 => number3 <= x"00003860c0c0fcc6c6c6c67c00000000"; --6
				when 7 => number3 <= x"0000fec606060c183030303000000000"; --7
				when 8 => number3 <= x"00007cc6c6c67cc6c6c6c67c00000000"; --8
				when 9 => number3 <= x"00007cc6c6c67e0606060c7800000000"; --9
				when others => number3 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
			end case;
			case int_num4 is			
				when 0 => number4 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
				when 1 => number4 <= x"00001838781818181818187e00000000"; --1
				when 2 => number4 <= x"00007cc6060c183060c0c6fe00000000"; --2
				when 3 => number4 <= x"00007cc606063c060606c67c00000000"; --3
				when 4 => number4 <= x"00000c1c3c6cccfe0c0c0c1e00000000"; --4
				when 5 => number4 <= x"0000fec0c0c0fc060606c67c00000000"; --5
				when 6 => number4 <= x"00003860c0c0fcc6c6c6c67c00000000"; --6
				when 7 => number4 <= x"0000fec606060c183030303000000000"; --7
				when 8 => number4 <= x"00007cc6c6c67cc6c6c6c67c00000000"; --8
				when 9 => number4 <= x"00007cc6c6c67e0606060c7800000000"; --9
				when others => number4 <= x"0000386cc6c6d6d6c6c66c3800000000"; --0
			end case;
	end if;
	end if;
end process;


--multiplexer with all inputs
all_inputs : process (CLK, Reset)
begin
	if(RESET='1') then 
		PRES1_IN <= '0';
		TICKET_IN <= '0';
		PRES2_IN <= '0';
		PRES1_OUT <= '0';
		TICKET_OUT <= '0';
		PRES2_OUT <= '0';
		PRES1_IN_c <= '0';
		TICKET_IN_c <= '0'; 
		PRES2_IN_c <= '0';
		PRES1_OUT_c <= '0';
		TICKET_OUT_c <= '0';
		PRES2_OUT_c <= '0';
		AND_Y_up <= '0';
		AND_X_up <= '0';
		AND_X_down <= '0';
		AND_Y_down <= '0';	
	elsif(CLK'event and CLK='1') then 		
		if sg_sel="000" then
			if sg_value(2)='1' then
				PRES1_IN <= '1';
			else
				PRES1_IN <= '0';
			end if;
			if sg_value(1)='1' then
				TICKET_IN <= '1';
			else
				TICKET_IN <= '0';
			end if;
			if sg_value(0)='1' then 
				PRES2_IN <= '1';
			else
				PRES2_IN <= '0';
			end if;
		elsif sg_sel="001" then		
			if sg_value(2)='1' then
				PRES1_OUT <= '1';
			else
				PRES1_OUT <= '0';
			end if;
			if sg_value(1)='1' then
				TICKET_OUT <= '1';
			else
				TICKET_OUT <= '0';
			end if;
			if sg_value(0)='1' then
				PRES2_OUT <= '1';
			else
				PRES2_OUT <= '0';
			end if;
		elsif sg_sel="010" then
			if sg_value(2)='1' then
				PRES1_IN_c <= '1';
			else
				PRES1_IN_c <= '0';
			end if;
			if sg_value(1)='1' then
				TICKET_IN_c <= '1';
			else
				TICKET_IN_c <= '0';
			end if;
			if sg_value(0)='1' then
				PRES2_IN_c <= '1';
			else
				PRES2_IN_c <= '0';
			end if;
		elsif sg_sel="011" then
			if sg_value(2)='1' then
				PRES1_OUT_c <= '1';
			else
				PRES1_OUT_c <= '0';
			end if;
			if sg_value(1)='1' then
				TICKET_OUT_c <= '1';
			else
				TICKET_OUT_c <= '0';
			end if;
			if sg_value(0)='1' then
				PRES2_OUT_c <= '1';
			else
				PRES2_OUT_c <= '0';
			end if;
		elsif sg_sel="100" then
			if sg_value(0)='1' then
				AND_Y_up <= '1';
			else
				AND_Y_up <= '0';
			end if;
			if sg_value(1)='1' then
				AND_X_up <= '1';
			else
				AND_X_up <= '0';
			end if;
		elsif sg_sel="101" then
			if sg_value(0)='1' then
				AND_X_down <= '1';
			else
				AND_X_down <= '0';
			end if;
			if sg_value(1)='1' then
				AND_Y_down <= '1';
			else
				AND_Y_down <= '0';
			end if;
		end if;
	end if;
end process;

--change park colour
RGBpress1_in <= "100" when PRES1_IN='1' else "001";
RGBpress2_in <= "100" when PRES2_IN='1' else "001";
RGBticket_in <= "100" when TICKET_IN='1' else "001";
RGBpress1_out <= "100" when PRES1_OUT='1' else "001";
RGBpress2_out <= "100" when PRES2_OUT='1' else "001";
RGBticket_out <= "100" when TICKET_OUT='1' else "001";
RGBgate_in <= "100" when CANC_IN='1' else "001";
RGBgate_out <= "100" when CANC_OUT='1' else "001";
RGBpress1_in_c <= "100" when PRES1_IN_c='1' else "001";
RGBpress2_in_c <= "100" when PRES2_IN_c='1' else "001";
RGBticket_in_c <= "100" when TICKET_IN_c='1' else "001";
RGBpress1_out_c <= "100" when PRES1_OUT_c='1' else "001";
RGBpress2_out_c <= "100" when PRES2_OUT_c='1' else "001";
RGBticket_out_c <= "100" when TICKET_OUT_c='1' else "001";
RGBgate_in_c <= "100" when CANC_IN_c='1' else "001";
RGBgate_out_c <= "100" when CANC_OUT_c='1' else "001";
RGBand_y_up <= "100" when AND_Y_up='1' else "001";
RGBand_x_up <= "100" when AND_X_up='1' else "001";
RGBand_x_down <= "100" when AND_X_down='1' else "001";
RGBand_y_down <= "100" when AND_Y_down='1' else "001";   
RGBnumber1 <= "100" when CAP_F2>49 else "111";
RGBnumber2 <= "100" when CAP_F2>49 else "111";
RGBnumber3 <= "100" when CAP_F1>49 else "111";
RGBnumber4 <= "100" when CAP_F1>49 else "111";

ld0 <= p1(to_integer(unsigned(sg_sel)));
ld1 <= p2(to_integer(unsigned(sg_sel)));
ld2 <= p3(to_integer(unsigned(sg_sel)));
ld3 <= p4(to_integer(unsigned(sg_sel)));
ld4 <= p5(to_integer(unsigned(sg_sel)));		
		
------------------------------------------------------------------------------------------------------------------------------				
draw: process(CLK, RESET)
begin
	if(RESET='1') then
		RGB <= "000";
		count_n1 <= 127;count_n2 <= 127;count_n3 <= 127;count_n4 <= 127;
	elsif(CLK'event and CLK='1') then
		if(clk25='1') then
		if(display_enabled='1') then
			--draw background
			RGB <= RGBbackground;	

			--SIDES and WALLS
			if((counter_hs>=40 and counter_hs<=600 and counter_vs=60)or(counter_hs>=40 and counter_hs<=600 and counter_vs=420)) then
				RGB <= RGBsides;
			elsif((counter_vs>=60 and counter_vs<=120 and counter_hs=40)or(counter_vs>=160 and counter_vs<=320 and counter_hs=40)or(counter_vs>=360 and counter_vs<=420 and counter_hs=40)) then
				RGB <= RGBsides;
			elsif((counter_vs>=60 and counter_vs<=120 and counter_hs=600)or(counter_vs>=160 and counter_vs<=320 and counter_hs=600)or(counter_vs>=360 and counter_vs<=420 and counter_hs=600)) then
				RGB <= RGBsides;
			elsif((counter_hs>=40 and counter_hs<=290 and counter_vs=240)or(counter_hs>=350 and counter_hs<=600 and counter_vs=240)) then
				RGB <= RGBsides;
			elsif((counter_vs>=180 and counter_vs<=300 and counter_hs=290)or(counter_vs>=180 and counter_vs<=300 and counter_hs=350)) then
				RGB <= RGBsides;					
			elsif(counter_vs>=180 and counter_vs<=300 and counter_hs=320) then
				RGB <= RGBsides;	
			elsif((counter_vs>=210 and counter_vs<=270 and counter_hs=305) or (counter_vs>=210 and counter_vs<=270 and counter_hs=335)) then
				RGB <= RGBsides;		
				
			elsif((counter_vs=213 and counter_hs=302)or(counter_vs=212 and counter_hs=303)or(counter_vs=211 and counter_hs=304)) then
				RGB <= RGBsides;	
			elsif((counter_vs=213 and counter_hs=308)or(counter_vs=212 and counter_hs=307)or(counter_vs=211 and counter_hs=306)) then
				RGB <= RGBsides;
			elsif((counter_vs=267 and counter_hs=332)or(counter_vs=268 and counter_hs=333)or(counter_vs=269 and counter_hs=334)) then
				RGB <= RGBsides;	
			elsif((counter_vs=267 and counter_hs=338)or(counter_vs=268 and counter_hs=337)or(counter_vs=269 and counter_hs=336)) then
				RGB <= RGBsides;		
				
			--GATES	
			elsif(counter_vs>=120 and counter_vs<=160 and counter_hs>=39 and counter_hs<=41) then
				RGB <= RGBgate_in_c;
			elsif(counter_vs>=320 and counter_vs<=360 and counter_hs>=39 and counter_hs<=41) then
				RGB <= RGBgate_in;	
			elsif(counter_vs>=120 and counter_vs<=160 and counter_hs>=599 and counter_hs<=601) then
				RGB <= RGBgate_out_c;
			elsif(counter_vs>=320 and counter_vs<=360 and counter_hs>=599 and counter_hs<=601) then
				RGB <= RGBgate_out;		
				
			--TICKETS 
			elsif(counter_vs>=110 and counter_vs<=120 and counter_hs>=35 and counter_hs<=40) then
				RGB <= RGBticket_in_c;
			elsif(counter_vs>=310 and counter_vs<=320 and counter_hs>=35 and counter_hs<=40) then
				RGB <= RGBticket_in;	
			elsif(counter_vs>=110 and counter_vs<=120 and counter_hs>=595 and counter_hs<=600) then
				RGB <= RGBticket_out_c;
			elsif(counter_vs>=310 and counter_vs<=320 and counter_hs>=595 and counter_hs<=600) then
				RGB <= RGBticket_out;	
			
			--PRESSES 
			elsif(counter_vs>=120 and counter_vs<=160 and counter_hs>=15 and counter_hs<=35) then
				RGB <= RGBpress1_in_c;
			elsif(counter_vs>=320 and counter_vs<=360 and counter_hs>=15 and counter_hs<=35) then
				RGB <= RGBpress1_in;	
			elsif(counter_vs>=120 and counter_vs<=160 and counter_hs>=45 and counter_hs<=65) then
				RGB <= RGBpress2_in_c;
			elsif(counter_vs>=320 and counter_vs<=360 and counter_hs>=45 and counter_hs<=65) then
				RGB <= RGBpress2_in;					
			elsif(counter_vs>=120 and counter_vs<=160 and counter_hs>=575 and counter_hs<=595) then
				RGB <= RGBpress1_out_c;
			elsif(counter_vs>=320 and counter_vs<=360 and counter_hs>=575 and counter_hs<=595) then
				RGB <= RGBpress1_out;	
			elsif(counter_vs>=120 and counter_vs<=160 and counter_hs>=605 and counter_hs<=625) then
				RGB <= RGBpress2_out_c;
			elsif(counter_vs>=320 and counter_vs<=360 and counter_hs>=605 and counter_hs<=625) then
				RGB <= RGBpress2_out;
				
			--SLOPE SENSORS 
			elsif(counter_vs>=180 and counter_vs<=185 and counter_hs>=290 and counter_hs<=295) then
				RGB <= RGBand_y_up;				
			elsif(counter_vs>=295 and counter_vs<=300 and counter_hs>=290 and counter_hs<=295) then
				RGB <= RGBand_x_up;	
			elsif(counter_vs>=180 and counter_vs<=185 and counter_hs>=345 and counter_hs<=350) then
				RGB <= RGBand_x_down;				
			elsif(counter_vs>=295 and counter_vs<=300 and counter_hs>=345 and counter_hs<=350) then
				RGB <= RGBand_y_down;	
				
			--NUMBER1
			elsif((counter_hs>=312 and counter_hs<320) and (counter_vs>=132 and counter_vs<148)) then
				if(count_n1>=0) then
					if(number1(count_n1)='1') then
						RGB <= RGBnumber1;
					end if;
					count_n1 <= count_n1 - 1;
				else
					count_n1<=127;
				end if;
			--NUMBER2
			elsif((counter_hs>=320 and counter_hs<328) and (counter_vs>=132 and counter_vs<148)) then
				if(count_n2>=0) then
					if(number2(count_n2)='1') then
						RGB <= RGBnumber2;
					end if;
					count_n2 <= count_n2 - 1;
				else
					count_n2<=127;
				end if;
			--NUMBER3
			elsif((counter_hs>=312 and counter_hs<320) and (counter_vs>=332 and counter_vs<348)) then
				if(count_n3>=0) then
					if(number3(count_n3)='1') then
						RGB <= RGBnumber3;
					end if;
					count_n3 <= count_n3 - 1;
				else
					count_n3<=127;
				end if;
			--NUMBER4
			elsif((counter_hs>=320 and counter_hs<328) and (counter_vs>=332 and counter_vs<348)) then
				if(count_n4>=0) then
					if(number4(count_n4)='1') then
						RGB <= RGBnumber4;
					end if;
					count_n4 <= count_n4 - 1;
				else
					count_n4<=127;
				end if;
			end if;
		else
			RGB <= "000";
		end if;
		end if;
	end if;
end process;

    U_Parque : Parque Port Map(
        Clk => CLK,
        PRES1_IN => PRES1_IN,
        PRES2_IN => PRES2_IN,
        TICKET_IN => TICKET_IN,
        PRES1_OUT => PRES1_OUT,
        PRES2_OUT => PRES2_OUT,
        TICKET_OUT => TICKET_OUT,
        PRES1_IN_c => PRES1_IN_c,
        PRES2_IN_c => PRES2_IN_c,
        TICKET_IN_c => TICKET_IN_c,
        PRES1_OUT_c => PRES1_OUT_c,
        PRES2_OUT_c => PRES2_OUT_c,
        TICKET_OUT_c => TICKET_OUT_c,
        AND_Y_up => AND_Y_up,
        AND_X_up => AND_X_up,
        AND_X_down => AND_X_down,
        AND_Y_down => AND_Y_down,
        CANC_IN => CANC_IN,
        CANC_OUT => CANC_OUT,
        CANC_IN_c => CANC_IN_c,
        CANC_OUT_c => CANC_OUT_c,
		  occupied_1 => CAP_F1,
		  occupied_2 => CAP_F2,
        Enable => '1',
		  p1 => p1,
	     p2 => p2,
	     p3 => p3,
		  p4 => p4,
		  p5 => p5,
        Reset => RESET
    );
	 
	 Deb : Debounce Port Map(
	      clk => CLK,
         reset => RESET,
			in_value => value,
			in_sel => sel,
			out_value => sg_value, 
			out_sel => sg_sel
	);
end Behavioral;