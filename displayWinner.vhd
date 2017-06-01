library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity displayWinner is
	port( clk 		      : in  std_logic;
			setPontuacao1  : in  std_logic_vector(1 downto 0);
			setPontuacao2  : in  std_logic_vector(1 downto 0);
			letterJ        : out std_logic_vector(6 downto 0);
			letterO        : out std_logic_vector(6 downto 0);
			letterG        : out std_logic_vector(6 downto 0);
			letterA        : out std_logic_vector(6 downto 0);
			letterD        : out std_logic_vector(6 downto 0);
			letterR        : out std_logic_vector(6 downto 0);
			numberX        : out std_logic_vector(6 downto 0)); 
end displayWinner;

architecture Behavioral of displayWinner is

	signal s_set1 : integer := 0;
	

begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(setPontuacao1 = "11") then -- jogador1
				numberX <= "1111001";
			elsif(setPontuacao2 = "11") then
				numberX <= "0100100";
			end if;
		end if;
	end process;
	
	letterJ <= "1100000"; --
	letterO <= "0100011";
	letterG <= "0000010"; --
	letterA <= "0001000";
	letterD <= "0100001";
	letterR <= "0101111";
end Behavioral;
--  --d--