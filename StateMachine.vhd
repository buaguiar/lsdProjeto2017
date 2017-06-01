library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity StateMachine is
	port(clk		        : in  std_logic;
		  resetSetIn     : in  std_logic; --KEY0
		  jogarSetIn     : in  std_logic; --KEY1
		  jogador1Ponto  : in  std_logic; --KEY2
		  jogador2Ponto  : in  std_logic; --KEY3
		  resetJogo      : in  std_logic; --SW0
		  resetSetOutput : out std_logic;
		  resetJogoOutput: out std_logic;
		  jogador1Ganhou : out std_logic;
		  jogador2Ganhou : out std_logic;
		  initialState   : out std_logic);
end StateMachine;

architecture Behavioral of StateMachine is

	type TState is (Inicio, JogarSet);
	signal s_currentState, s_nextState : TState;

begin
	sync_proc : process(clk)
	begin
		if (rising_edge(clk)) then
			if (resetJogo = '1') then
				s_currentState <= Inicio;
			else
				s_currentState <= s_nextState;
			end if;
		end if;
	end process;

	comb_proc : process(s_currentState, resetSetIn, jogarSetIn, jogador1Ponto, jogador2Ponto, resetJogo)
	begin
		resetSetOutput  <= '0';
		resetJogoOutput <= '0';
		jogador1Ganhou  <= '0';
		jogador2Ganhou  <= '0';
		initialState    <= '0';
		
		case (s_currentState) is
		when Inicio =>
			initialState <= '1';
			if(resetJogo = '1') then
				resetSetOutput  <= '1';
				resetJogoOutput <= '1';
				s_nextState <= Inicio;
			elsif (jogarSetIn = '1') then
				initialState <= '0';
				s_nextState <= JogarSet;
			else
				s_nextState <= Inicio;
			end if;

		when JogarSet =>
			if(resetJogo = '1') then
				resetSetOutput  <= '1';
				resetJogoOutput <= '1';
				s_nextState <= Inicio;
			elsif (resetSetIn = '1') then
				resetSetOutput  <= '1';
				s_nextState <= JogarSet;
			elsif (jogador1Ponto = '1') then
				jogador1Ganhou  <= '1';
				s_nextState <= JogarSet;
			elsif (jogador2Ponto = '1') then
				jogador2Ganhou  <= '1';
				s_nextState <= JogarSet;
			else
				s_nextState <= JogarSet;
			end if;
		
		end case;
	end process;
end Behavioral;
