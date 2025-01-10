library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VComponents.all;



--------------------------------------------------------------------------------------------------------------------
-- Ring Oscillator PUF architecture
--
-- clk 	     -> 12 MHz from FPGA
-- leds      -> ?
-- uart_rx   -> serial connection input
-- uart_tx   -> serial connection output
-- reset_btn -> reset state

entity ro_puf_s7 is
    Port (
        clk   		: in std_logic ;
        led1      	: out std_logic:='0';
        led2       	: out std_logic:='0';
        led3        : out std_logic:='0';
        led4        : out std_logic:='0';
        uart_rx     : in STD_LOGIC;
        uart_tx     : out STD_LOGIC;
        reset_btn   : in STD_LOGIC
    );
end ro_puf_s7;

architecture Behavioral of ro_puf_s7 is



--------------------------------------------------------------------------------------------------------------------
-- Internal signals declaration

-- UART RX
signal rx_busy       : STD_LOGIC := '0';
signal received_word : STD_LOGIC_VECTOR(7 downto 0);
signal rdy           : STD_LOGIC;

-- UART Tx
signal tx_en         : STD_LOGIC :='0';
signal tx_busy       : STD_LOGIC;
signal tx_data_in    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

-- PUF architecture
type SHIFT_Transmission_State is (IDLE, SHIFT);
signal shift_state   : SHIFT_Transmission_State := IDLE;
signal cntrl         : STD_LOGIC := '0';
signal str_index     : integer range 0 to 7 := 0;
signal shift_reg     : std_logic_vector(15 downto 0):= (others => '0');
signal output_data   : std_logic_vector(7 downto 0):= (others => '0');
signal Mux_Selection : std_logic_vector(13 downto 0):= (others => '0');
signal temp_result 	 : integer range 0 to 255 :=0;



--------------------------------------------------------------------------------------------------------------------
-- Internal components declaration

component Ros_selection is
    Port (
        challenge : in std_logic_vector(7 downto 0);
        Output    : out std_logic;
        Enable    : in std_logic_vector(255 downto 0)
    );
end component ;

component random_rom is
    Port ( address : in  std_logic_vector (7 downto 0);
           data_out : out std_logic_vector(15 downto 0));
end component;



--------------------------------------------------------------------------------------------------------------------
-- Internal signals declaration
--
-- Internal_Challenge_mux_0 -> Store the challenge mux for (MODE PEAR TO PEAR)
-- Internal_Challenge_mux_1 -> //
-- PUF_Response             -> used to store the key
-- PUF_start                -> used to start counting in Key generation FSM
-- MUX_1_challenge          -> used to link Internal_chal_mux to ROs_selection
-- MUX_2_challenge          -> //
-- MUX_1_OUT                -> output of challenged RO in first column
-- MUX_2_OUT                -> output of challenged RO in second column
-- compteur_cycles          -> clk counter used to compare with timer_size
-- MUX_1_Counter            -> counter from mux1
-- MUX_2_Counter            -> counter from mux2
-- Enable                   -> TODO remove
-- Reset_Comparison         -> TODO explain
-- Reset_Counter            -> TODO explain
-- Enable_Comparison        -> TODO explain
-- Enable_Counter           -> TODO explain
-- full                     -> indicate the register is full
-- data_sent                -> Signal data have been sent
-- Counter_Timer            -> State for cycle_nb from UARTs
-- Timer_size               -> used to precise the nb of cycle to wait

-- ro_filter                -> Used to activate ROs or not POST-FILTERING
-- mode_select              -> Choose between random (1) and pear to pear (0) configuration


-- Change from 9 to 8 (for 256 ROs in ros selection we have 8 at max)
signal Internal_Challenge_mux1  : std_logic_vector(7 downto 0) := "00000000" ;
signal Internal_Challenge_mux2  : std_logic_vector(7 downto 0) := "00000000" ;
signal PUF_Response             : std_logic_vector(63 downto 0):= (others => '0');
signal PUF_start                : STD_LOGIC:='0';
signal MUX_1_challenge          : std_logic_vector(7 downto 0):="00000000";
signal MUX_2_challenge          : std_logic_vector(7 downto 0):="00000000";
signal MUX_1_OUT                : std_logic:='0';
signal MUX_2_OUT                : std_logic:='0';
signal compteur_cycles          : unsigned(28 downto 0):= (others => '0');
signal MUX_1_Counter            : unsigned(30 downto 0) := (others => '0');
signal MUX_2_Counter            : unsigned(30 downto 0) := (others => '0');
-- Change to a 256 bits vector to choose which ROs to activate
signal Enable                   : std_logic_vector(255 downto 0) := (others => '0');
signal Reset_Comparison         : std_logic := '0';
signal Reset_Counter            : std_logic := '0';
signal Enable_Comparison        : std_logic := '0';
signal Enable_Counter           : std_logic := '0';
signal full                     : std_logic := '0';
signal data_sent                : boolean := false;
signal Counter_Timer            : std_logic_vector(2 downto 0);
signal Timer_size               : integer := 0;
signal ro_filter                : std_logic_vector(256 downto 0) := (others => '1');
signal rom_adress               : std_logic_vector (7 downto 0)  := (others => '1');
signal rom_data_out             : std_logic_vector (15 downto 0) := (others => '1');
signal mode_select              : STD_LOGIC:='0';
-- State to process 2 RO comparaison and store 1bit of key
type t_state is (IDLE, COUNTING, COMPARISON, CHALLENGE);
signal state : t_state;



--------------------------------------------------------------------------------------------------------------------
--
--                                              UART SECTION
--
--------------------------------------------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------------------------------------------
begin

-- UART Rx
uart_rx_inst : entity work.uart_rx PORT MAP(
    clk      => clk,
    rx_in    => uart_rx,
    busy_out => rx_busy,
    rdy      => rdy,
    data_out => received_word
);

-- UART Tx
uart_tx_inst : entity work.uart_tx PORT MAP(
    clk      => clk,
    reset    => reset_btn,
    data_in  => tx_data_in,
    en       => tx_en,
    busy_out => tx_busy,
    tx_out   => uart_tx
);

-- UART Tx
process(clk)
    variable byte_counter : integer range 0 to 7 := 0;  -- Compteur pour les 8 octets
begin
    if rising_edge(clk) then
        if full = '1' and tx_busy = '0' and not data_sent then
            tx_en <= '1';

            if byte_counter = 0 then
                tx_data_in <= PUF_Response(63 downto 56);  -- Premier octet
            else
                tx_data_in <= PUF_Response(63 - 8 * byte_counter downto 56 - 8 * byte_counter);
            end if;

            byte_counter := byte_counter + 1;

            if byte_counter = 8 then
                data_sent <= true;         -- Transmission terminée
                byte_counter := 0;        -- Réinitialiser le compteur
                tx_en <= '0';
            end if;

        elsif full = '0' then
            data_sent <= false;  -- Réinitialiser le signal lorsque full revient à 0
        end if;
    end if;
end process;

-- UART Rx
process(clk)
begin
    if rising_edge(clk) then
        if reset_btn = '1' then
-- Réinitialisation de la machine d'état lors du reset
            shift_state <= IDLE;
        else
            case shift_state is
                when IDLE =>
-- Attendre un signal de déclenchement pour passer à l'état SHIFT
                    if rdy = '1' then
                        shift_state <= SHIFT;
                    else
                        shift_state <= IDLE;
                    end if;
-- Enregistrer les 8 premiers bits de received_word dans le registre à décalage
-- puis enregistrer les 8 bits suivants dans le registre à décalage et produire la sortie de 15 bits
                when SHIFT =>
                    output_data <=  received_word;
                    shift_state <= IDLE;
            end case;
        end if;
    end if;
end process;

PUF_start      <= output_data(7);
mode_select    <= output_data(6);
Counter_Timer  <= output_data(2 downto 0);




--------------------------------------------------------------------------------------------------------------------
--
--                                 Ring Oscillator Desclaration
--
--------------------------------------------------------------------------------------------------------------------

uut1 : Ros_selection
port map (
    challenge => MUX_1_challenge,
    Output    => MUX_1_OUT,
    Enable    => Enable
);

uut2 : Ros_selection
port map (
    challenge => MUX_2_challenge,
    Output    => MUX_2_OUT,
    Enable    => Enable
);

rom : random_rom
port map(
    address => rom_adress,
    data_out => rom_data_out
);




--------------------------------------------------------------------------------------------------------------------
--
--                                  TIME to wait for RO pear
--
--------------------------------------------------------------------------------------------------------------------
-- At 12 MHz
-- 12000000  -> 1000 ms
-- 1200000   -> 100  ms
-- 120000    -> 10   ms
-- 12000     -> 1    ms
--------------------------------------------------------------------------------------------------------------------
process(Counter_Timer)
begin
    if Counter_Timer     = "001" then
        Timer_size <= 12000000;
    elsif Counter_Timer  = "010" then
        Timer_size <= 1200000;
    elsif Counter_Timer  = "011" then
        Timer_size <= 120000;
    elsif Counter_Timer  = "100" then
        Timer_size <= 12000;
    end if;
end process;



--------------------------------------------------------------------------------------------------------------------
--
--                                  COUNT at each clock cycle
--
--------------------------------------------------------------------------------------------------------------------
-- reset when reaching the value given above
--------------------------------------------------------------------------------------------------------------------
process(clk,Timer_size)
begin
    if clk'event and clk = '1' then
        if compteur_cycles = Timer_size then
            compteur_cycles <= (others => '0');
        else
            compteur_cycles <= compteur_cycles + 1;
        end if;
    end if;
end process;



--------------------------------------------------------------------------------------------------------------------
--
--                       FSM processing 2 RO comparison store 1bit of key
--
--------------------------------------------------------------------------------------------------------------------
-- Update values of internal_mux
-- IDLE       -> Reset state
-- COUNTING   -> Wait counter
-- COMPARISON -> Send response to UART
-- CHALLENGE  -> Change RO
--------------------------------------------------------------------------------------------------------------------
process(clk)
begin
    if rising_edge(clk) then

         -- PEAR TO PEAR MODE
        if mode_select = 1 then
            MUX_1_challenge <= Internal_Challenge_mux1(7 downto 0) ;
            MUX_2_challenge <= Internal_Challenge_mux1(7 downto 0);
         -- RANDOM MODE
        else
            MUX_1_challenge <= rom_data_out(15 downto 8) ;
            MUX_2_challenge <= rom_data_out(7 downto 0) ;
        end if;

        case state is
            when IDLE =>

                Enable_Comparison <= '0';
                Enable_Counter    <= '0';
                Reset_Comparison  <= '1';
                Reset_Counter     <= '1';
                Enable            <= (others => '0');
                Internal_Challenge_mux1 <= (others => '0');

                if PUF_start = '1' then
                    state <= COUNTING;
                else
                    state <= IDLE;
                end if;

            when COUNTING =>

                Enable_Comparison <= '0';
                Enable_Counter    <= '1';
                Reset_Comparison  <= '1';
                Reset_Counter     <= '0';
                Enable(to_integer(unsigned(Internal_Challenge_mux1))) <= '1';

                if compteur_cycles = Timer_size then
                    state <= COMPARISON;
                else
                    state <= COUNTING;
                end if;

            when COMPARISON =>

                Enable_Comparison <= '1';
                Enable_Counter    <= '0';
                Reset_Comparison  <= '0';
                Reset_Counter     <= '1';
                Enable(to_integer(unsigned(Internal_Challenge_mux1))) <= '0';

                if if mode_select = '0' then
                    if Internal_Challenge_mux1 = "11111111" then -- TODO check
                        state <= IDLE;
                    else
                        state <= CHALLENGE;
                    end if;
				else
                    if rom_adress = '11111111' then
                         state <= IDLE;
                    else
                        state <= CHALLENGE;
                    end if;
                end if;

			when CHALLENGE =>
			    if mode_select = '0' then
                    Internal_Challenge_mux1 <= Internal_Challenge_mux1 + 1;

                    if ro_filter(to_integer(unsigned(Internal_Challenge_mux1))) = '1' then
                        state <= COUNTING;
                    else
                        state <= CHALLENGE;
                    end if;
                else
                    rom_adress = rom_adress + 1;

                    if ro_filter(to_integer(unsigned(Internal_Challenge_mux1))) = '1' then
                        state <= COUNTING;
                    else
                        state <= CHALLENGE;
                    end if;
                end if;

        end case;
    end if;
end process;




--------------------------------------------------------------------------------------------------------------------
--
--                         FSM to process 2 RO comparaison and store 1bit of key
--
--------------------------------------------------------------------------------------------------------------------
-- Update the MUX_1_Counter whenever event occurs at the output of RO
-- Update the MUX_2_Counter whenever event occurs at the output of RO
-- When Enable -> count
-- When Reset  -> clean to '0
--------------------------------------------------------------------------------------------------------------------
process(Enable_Counter,MUX_1_Counter,MUX_2_OUT ,Reset_Counter)
begin

if Reset_Counter = '1' then
    MUX_1_Counter <= (others =>'0');
elsif Enable_Counter = '1' then
    if MUX_1_OUT'event and MUX_1_OUT  ='1' then
        MUX_1_Counter <= MUX_1_Counter + 1;
    end if;
end if;


if Reset_Counter = '1' then
    MUX_2_Counter <= (others =>'0');
elsif Enable_Counter = '1' then
    if MUX_2_OUT'event and MUX_2_OUT  ='1' then
        MUX_2_Counter <= MUX_2_Counter + 1;
    end if;
end if;

end process;



--------------------------------------------------------------------------------------------------------------------
--
--                      Write FREQUENCIES on PUF_RESPONSE before SENDING
--
--------------------------------------------------------------------------------------------------------------------
-- [63]     bit_comparison
-- [62]     NOT USED
-- [61:31]  MUX1_cpt
-- [30:0]   MUX2_cpt
-- led3 used for key == 1 (mux1 > mux2)
-- led4 used for key == 0 (mux1 < mux2)
-- do the comparison when Enable_Comparison
-- when register dumped, activate full to send on Tx
--------------------------------------------------------------------------------------------------------------------
process(clk, Reset_Comparison)
begin
    if Reset_Comparison = '1' then
        led4 <= '0';
        led3 <= '0';
        full <= '0';
        PUF_Response <= (others => '0');
    elsif rising_edge(clk) then
        if Enable_Comparison = '1' then  -- TODO check enough time given
            if MUX_1_Counter < MUX_2_Counter then
                led4 <= '1';
                PUF_Response(63) <= '0';
                PUF_Response(61 downto 31) <= std_logic_vector(MUX_1_Counter);
                PUF_Response(30 downto 0)  <= std_logic_vector(MUX_2_Counter);
            else
                led3 <= '1';
                PUF_Response(63) <= '1';
                PUF_Response(61 downto 31) <= std_logic_vector(MUX_1_Counter);
                PUF_Response(30 downto 0)  <= std_logic_vector(MUX_2_Counter);
            end if;
            full <= '1';
        else
            full <= '0';
        end if;
    end if;
end process;

end Behavioral;






