----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- LSD.TOS, May 2017 (DO NOT REMOVE THIS LINE), VHDL 2008
--
-- LCD controller "bare-bones" example
--
-- Project files:
--   lcd_tl.vhd
--   lcd_controller.vhd
--   debouncer.vhd
--   master.sdc
--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use	  ieee.std_logic_arith.all;

entity lcd_tl is
  port
  (
    clock_50 : in std_logic;
	 initialState : in std_logic;
	 everySet : in std_logic; 
	 winner   : in std_logic; 
	 j, o, g, a, d, r, nX, n, h, u, s, e, t, y, i, m, b, p, k, barra, c, nUM,   pontoExclamacao : in std_logic_vector(7 downto 0);
    lcd_on   : out   std_logic;
    lcd_blon : out   std_logic;
    lcd_rw   : out   std_logic;
    lcd_en   : out   std_logic;
    lcd_rs   : out   std_logic;
    lcd_data : inout std_logic_vector(7 downto 0);

    i2c_sclk : inout std_logic;
    i2c_sdat : inout std_logic
  );
end lcd_tl;

architecture v1 of lcd_tl is
  constant clock_frequency : real := 50.0e6;
  signal clock : std_logic;
  --
  -- Events related to key presses
  --
  signal key_pressed_pulse : std_logic_vector(3 downto 0);
  --
  -- LCD interface
  --
  signal txd_rs_and_data : std_logic_vector(8 downto 0);
  signal txd_request     : std_logic;
  signal txd_accepted    : std_logic := '0';
  --
  -- LCD initialization/refresh stage
  --
  signal index : integer range 0 to 51 := 0;
  --
  -- Contents of the two lines of the LCD display (the display is initially blank: the ASCII code of a space is x"20")
  --
  signal line0 : std_logic_vector(127 downto 0) := x"20_20_20_20_20_20_20_20_20_20_20_20_20_20_20_20" ; -- 16 ASCII codes for the top line of the LCD display
  signal line1 : std_logic_vector(127 downto 0) := x"20_20_20_20_20_20_20_20_20_20_20_20_20_20_20_20"; -- 16 ASCII codes for the bottom line of the LCD display
  
  
 begin
  clock <= clock_50;
  --
  -- Debounce keys
  --
  
  ca : entity work.lcd_controller(v1)
             generic map(clock_frequency => clock_frequency)
             port map(clock => clock,reset => '0',
                      lcd_on => lcd_on,lcd_blon => lcd_blon,lcd_rw => lcd_rw,lcd_en => lcd_en,lcd_rs => lcd_rs,lcd_data => lcd_data,
                      txd_rs_and_data => txd_rs_and_data,txd_request => txd_request,txd_accepted => txd_accepted);
  --
  -- Deal with key presses
  --
  process(clock) is
  begin
	
	if(rising_edge(clock)) then
		if (winner = '1') then
			line0 <= j & o & g & a & d & o & r & nX & x"20" & g & a & n & h & o & u  & x"20";
			line1 <= o & x"20" & j & o & g & o & pontoExclamacao & pontoExclamacao & pontoExclamacao & x"20_20_20_20_20_20_20";
	
		elsif (initialState = '1') then
			line0 <= p & r & i & m & a & x"20" & o & x"20" & b & o & t & a & o & x"20_20_20";
			line1 <= k & e & y & nUM & x"20" & p & barra & x"20" & c & o & m & e & c & a & r & x"20";
		elsif (everySet = '1') then
			line0 <= j & o & g & a & d & o & r & nX & x"20" & g & a & n & h & o & u  & x"20";
			line1 <= o & x"20" & s & e & t & pontoExclamacao & pontoExclamacao & pontoExclamacao & x"20_20_20_20_20_20_20_20";
		
		end if;
	end if;
  end process;
  --
  -- LCD initialization (done once) and refresh (done all the time)
  --
  process(clock) is
  begin
    if rising_edge(clock) then
      txd_request <= '1'; -- we are always attempting to write
      case index is
        -- redefine the image of character 0 (circle)
        when  0 => txd_rs_and_data <= b"0_01_000_000"; -- set CGRAM address
        when  1 => txd_rs_and_data <= b"1_000_00000";
        when  2 => txd_rs_and_data <= b"1_000_00000";
        when  3 => txd_rs_and_data <= b"1_000_01110";
        when  4 => txd_rs_and_data <= b"1_000_10001";
        when  5 => txd_rs_and_data <= b"1_000_10001";
        when  6 => txd_rs_and_data <= b"1_000_10001";
        when  7 => txd_rs_and_data <= b"1_000_01110";
        when  8 => txd_rs_and_data <= b"1_000_00000";
        -- redefine the image of character 1 (disc)
        when  9 => txd_rs_and_data <= b"0_01_001_000"; -- set CGRAM address
        when 10 => txd_rs_and_data <= b"1_000_00000";
        when 11 => txd_rs_and_data <= b"1_000_00000";
        when 12 => txd_rs_and_data <= b"1_000_01110";
        when 13 => txd_rs_and_data <= b"1_000_11111";
        when 14 => txd_rs_and_data <= b"1_000_11111";
        when 15 => txd_rs_and_data <= b"1_000_11111";
        when 16 => txd_rs_and_data <= b"1_000_01110";
        when 17 => txd_rs_and_data <= b"1_000_00000";
        -- refresh the top line
        when 18 => txd_rs_and_data <= b"0_1_000_0000"; -- set write address command
        when 19 => txd_rs_and_data <= '1' & line0(127 downto 120);
        when 20 => txd_rs_and_data <= '1' & line0(119 downto 112);
        when 21 => txd_rs_and_data <= '1' & line0(111 downto 104);
        when 22 => txd_rs_and_data <= '1' & line0(103 downto  96);
        when 23 => txd_rs_and_data <= '1' & line0( 95 downto  88);
        when 24 => txd_rs_and_data <= '1' & line0( 87 downto  80);
        when 25 => txd_rs_and_data <= '1' & line0( 79 downto  72);
        when 26 => txd_rs_and_data <= '1' & line0( 71 downto  64);
        when 27 => txd_rs_and_data <= '1' & line0( 63 downto  56);
        when 28 => txd_rs_and_data <= '1' & line0( 55 downto  48);
        when 29 => txd_rs_and_data <= '1' & line0( 47 downto  40);
        when 30 => txd_rs_and_data <= '1' & line0( 39 downto  32);
        when 31 => txd_rs_and_data <= '1' & line0( 31 downto  24);
        when 32 => txd_rs_and_data <= '1' & line0( 23 downto  16);
        when 33 => txd_rs_and_data <= '1' & line0( 15 downto   8);
        when 34 => txd_rs_and_data <= '1' & line0(  7 downto   0);
        -- refresh the bottom line
        when 35 => txd_rs_and_data <= b"0_1_100_0000"; -- set write address command
        when 36 => txd_rs_and_data <= '1' & line1(127 downto 120);
        when 37 => txd_rs_and_data <= '1' & line1(119 downto 112);
        when 38 => txd_rs_and_data <= '1' & line1(111 downto 104);
        when 39 => txd_rs_and_data <= '1' & line1(103 downto  96);
        when 40 => txd_rs_and_data <= '1' & line1( 95 downto  88);
        when 41 => txd_rs_and_data <= '1' & line1( 87 downto  80);
        when 42 => txd_rs_and_data <= '1' & line1( 79 downto  72);
        when 43 => txd_rs_and_data <= '1' & line1( 71 downto  64);
        when 44 => txd_rs_and_data <= '1' & line1( 63 downto  56);
        when 45 => txd_rs_and_data <= '1' & line1( 55 downto  48);
        when 46 => txd_rs_and_data <= '1' & line1( 47 downto  40);
        when 47 => txd_rs_and_data <= '1' & line1( 39 downto  32);
        when 48 => txd_rs_and_data <= '1' & line1( 31 downto  24);
        when 49 => txd_rs_and_data <= '1' & line1( 23 downto  16);
        when 50 => txd_rs_and_data <= '1' & line1( 15 downto   8);
        when 51 => txd_rs_and_data <= '1' & line1(  7 downto   0);
      end case;
      if txd_accepted = '1' then
        if index < 51 then
          index <= index+1; -- advance to the next initialization/refresh stage
        else
          index <= 18; -- restart at the first refresh stage
        end if;
      end if;
    end if;
  end process;
end v1;