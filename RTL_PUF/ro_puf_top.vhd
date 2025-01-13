library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

--library UNISIM;
--use UNISIM.VComponents.all;



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
        reset_btn   : in STD_LOGIC;
        ledR_1      : out STD_LOGIC;
        ledG_1      : out STD_LOGIC;
        ledB_1      :  out STD_LOGIC
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
    Port ( address : in integer range 0 to 255 ;
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
-- Reset_Counter            -> TODO explain
-- Enable_Comparison        -> TODO explain
-- Enable_Counter           -> TODO explain
-- data_valid               -> indicate the register is data_valid
-- tx_available             -> Signal data have been sent
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
signal Enable_1                   : std_logic_vector(255 downto 0) := (others => '0');
signal Enable_2                 : std_logic_vector(255 downto 0) := (others => '0');
signal Reset_Counter            : std_logic := '0';
signal Enable_Comparison        : std_logic := '0';
signal Enable_Counter           : std_logic := '0';

signal data_valid               : std_logic := '1';
signal tx_available             : std_logic := '1';
signal Counter_Timer            : std_logic_vector(2 downto 0);
signal Timer_size               : integer := 0;

signal ro_filter                : std_logic_vector(256 downto 0) := (others => '1');
signal rom_address              : integer range 0 to 255 := 0;
signal rom_data_out             : std_logic_vector (15 downto 0);
signal mode_select              : STD_LOGIC:='0';

-- State to process 2 RO comparaison and store 1bit of key
type t_state is (IDLE, COUNTING, WAIT_SEND, COMPARISON, CHALLENGE_INCREMENTATION , CHALLENGE);
signal state : t_state;

type uart_state is (uart_IDLE, uart_State_0, uart_State_1, uart_State_2, uart_State_3, uart_State_4,uart_State_5, uart_State_6, uart_State_7, uart_State_8, uart_State_9, uart_State_10, uart_State_11, uart_State_12, uart_State_13, uart_State_14, uart_State_15);
signal Transmission_State       : uart_state := uart_IDLE;
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

-- UART TxEnable
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
begin
    if rising_edge(clk) then
        if tx_busy = '0' then    
            case Transmission_State is
                -- Wait for full to start sending
                when uart_IDLE =>
                    tx_available <= '1';
                    tx_en        <= '0';
                    if data_valid = '1' then
                        Transmission_state <= uart_State_0;
                    else
                        Transmission_state <= uart_IDLE;
                    end if;
                when uart_State_0 =>
                    tx_available        <= '0';
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(63 downto 56); -- Transmit the first 8 bits
                    Transmission_State  <= uart_State_1;
                when uart_State_1 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_State_2;
                when uart_State_2 =>
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(55 downto 48); -- Transmit the next 8 bits
                    Transmission_State  <= uart_State_3;
                when uart_State_3 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_State_4;
                when uart_State_4 =>
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(47 downto 40); -- Transmit the next 8 bits
                    Transmission_State  <= uart_State_5;
                when uart_State_5 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_State_6;
                when uart_State_6 =>
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(39 downto 32); -- Transmit the next 8 bits
                    Transmission_State  <= uart_State_7;
                when uart_State_7 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_State_8;
                when uart_State_8 =>
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(31 downto 24); -- Transmit the next 8 bits
                    Transmission_State  <= uart_State_9;
                when uart_State_9 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_State_10;
                when uart_State_10 =>
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(23 downto 16); -- Transmit the next 8 bits
                    Transmission_State  <= uart_State_11;
                when uart_State_11 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_State_12;
                when uart_State_12 =>
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(15 downto 8);  -- Transmit the next 8 bits
                    Transmission_State  <= uart_State_13;
                when uart_State_13 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_State_14;
                when uart_State_14 =>
                    tx_en               <= '1';
                    tx_data_in          <= PUF_Response(7 downto 0);   -- Transmit the last 8 bits
                    Transmission_State  <= uart_State_15;
		when uart_State_15 =>
                    tx_en               <= '0';  -- Wait in this state, no transmission
                    Transmission_State  <= uart_IDLE;
                when others   =>
                    Transmission_State <= uart_IDLE;
            end case;          
        end if;
    end if;
end process;

-- UART Rx
process(clk)
begin
    if rising_edge(clk) then
        if reset_btn = '0' then
-- Réinitialisation de la machine d'état lors du reset
            shift_state <= IDLE;
            led1 <= '0';
            led2 <= '0';
        else
            case shift_state is
                when IDLE =>
-- Attendre un signal de déclenchement pour passer à l'état SHIFT
                    if rdy = '1' then
                        shift_state <= SHIFT;
                    else
                        shift_state <= IDLE;
                    end if;
                    led1 <= '0';
                    led2 <= '1';
                    output_data(7) <= '0';
-- Enregistrer les 8 premiers bits de received_word dans le registre à décalage
-- puis enregistrer les 8 bits suivants dans le registre à décalage et produire la sortie de 15 bits
                when SHIFT =>
                    output_data <=  received_word;
                    shift_state <= IDLE;
                    led1 <= '1';
                    led2 <= '1';
            end case;
        end if;
    end if;
end process;

PUF_start      <= output_data(7);
mode_select    <= output_data(6);
Counter_Timer  <= output_data(2 downto 0);

led3 <= '0';
led4 <= '0';


--------------------------------------------------------------------------------------------------------------------
--
--                                 Ring Oscillator Desclaration
--
--------------------------------------------------------------------------------------------------------------------

uut1 : Ros_selection
port map (
    challenge => MUX_1_challenge,
    Output    => MUX_1_OUT,
    Enable    => Enable_1
);


uut2 : Ros_selection
port map (
    challenge => MUX_2_challenge,
    Output    => MUX_2_OUT,
    Enable    => Enable_2
);

rom : random_rom
port map(
    address => rom_address,
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
        if Enable_Counter = '1' then
            compteur_cycles <= compteur_cycles + 1;
        else
            compteur_cycles <= (others => '0');
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
-- COMPARISON -> WAIT_SEND response to UART
-- CHALLENGE  -> Change RO
--------------------------------------------------------------------------------------------------------------------
process(clk)
begin
    if rising_edge(clk) then

        if mode_select = '0' then                                       -- PEAR TO PEAR MODE
            MUX_1_challenge <=  Internal_Challenge_mux1(7 downto 0) ;
            MUX_2_challenge  <= Internal_Challenge_mux1(7 downto 0);
        else                                                            -- RANDOM MODE
            MUX_1_challenge <=  rom_data_out(15 downto 8) ;
            MUX_2_challenge  <= rom_data_out(7 downto 0) ;
        end if;

        case state is
            when IDLE =>
                ledR_1            <= '1';
                ledG_1            <= '1';
                ledB_1            <= '1';
                
                
                Enable_Comparison <= '0';
                Enable_Counter    <= '0';
                Reset_Counter     <= '1';
                Enable_1            <= (others => '0');
                Enable_2            <= (others => '0');
                
                -- reset challenges
                rom_address             <= 0;
                Internal_Challenge_mux1 <= (others => '0');
                
                if PUF_start = '1' then
                    if mode_select = '0' then
                        if ro_filter(to_integer(unsigned(Internal_Challenge_mux1))) = '1' then
                            state <= COUNTING; 
                        else
                            state <= CHALLENGE_INCREMENTATION;
                        end if;
                    else
                        if ro_filter(rom_address) = '1' then
                            state <= COUNTING; 
                        else
                            state <= CHALLENGE_INCREMENTATION;
                        end if;
                    end if;
                else
                    state <= IDLE;
                end if;


            when COUNTING =>
                ledR_1            <= '1';
                ledG_1            <= '0';
                ledB_1            <= '0';
                 
                Enable_Comparison <= '0';
                Enable_Counter    <= '1';
                Reset_Counter     <= '0';
                
                if mode_select = '0' then
                    Enable_1(to_integer(unsigned(Internal_Challenge_mux1))) <= '1';
                    Enable_2(to_integer(unsigned(Internal_Challenge_mux1))) <= '1';
                else 
                    Enable_1(to_integer(unsigned(rom_data_out(15 downto 8)))) <= '1';
                    Enable_2(to_integer(unsigned(rom_data_out(7 downto 0)))) <= '1';
                end if;
                
                
                if compteur_cycles = Timer_size then
                    state <= WAIT_SEND;
                else 
                    state <= COUNTING;
                end if;
                
            when WAIT_SEND => 
                ledR_1            <= '1';
                ledG_1            <= '0';
                ledB_1            <= '1';
                 
                Enable_Comparison <= '0';
                Enable_Counter    <= '0';
                Reset_Counter     <= '0';
                Enable_1 <= (others => '0');
                Enable_2 <= (others => '0');
                
                
                if tx_available = '1' then
                    state <= COMPARISON;
                else
                    state <= WAIT_SEND;
                end if;
         
            when COMPARISON =>
                ledR_1            <= '0';
                ledG_1            <= '0';
                ledB_1            <= '1';
                
                Enable_Comparison <= '1';
                Enable_Counter    <= '0';
                Reset_Counter     <= '0';
                
                if mode_select = '0' then
                    if Internal_Challenge_mux1 = "11111111" then
                        state <= IDLE;
                    else
                        state <= CHALLENGE_INCREMENTATION;
                    end if;
			    else
                    if rom_address = 255 then
                         state <= IDLE;
                    else
                        state <= CHALLENGE_INCREMENTATION;
                    end if;
                end if;
			
			when CHALLENGE_INCREMENTATION => 
				if mode_select = '0'then
					Internal_Challenge_mux1 <= Internal_Challenge_mux1 + 1;
				else 
					rom_address <= rom_address + 1;
				end if;

				state <= CHALLENGE;


            when CHALLENGE =>
				ledR_1            <= '0';
                ledG_1            <= '1';
                ledB_1            <= '0';
                
                Enable_Comparison <= '0';
                Enable_Counter    <= '0';
                Reset_Counter     <= '1';
					
                if mode_select = '0' then
                    if ro_filter(to_integer(unsigned(Internal_Challenge_mux1))) = '1' then
                        state <= COUNTING;
                    else
                        if Internal_Challenge_mux1 = "11111111" then 
                            state <= IDLE;
                        else 
                            state <= CHALLENGE_INCREMENTATION;
                        end if;
                    end if;
                else
                    if ro_filter(rom_address) = '1' then
                        state <= COUNTING;
                    else 
                        if rom_address = 255 then
                            state <= IDLE;
                        else
                            state <= CHALLENGE_INCREMENTATION;
                        end if;
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
process(Enable_Counter, MUX_1_Counter, MUX_2_Counter, MUX_1_OUT, MUX_2_OUT, Reset_Counter)
begin

if Reset_Counter = '1' then  
    MUX_2_Counter <= (others =>'0');
elsif Enable_Counter = '1' then 
    if MUX_2_OUT'event and MUX_2_OUT  ='1' then 
        MUX_2_Counter <= MUX_2_Counter + 1;
    end if;
end if;

if Reset_Counter = '1' then  
    MUX_1_Counter <= (others =>'0');
elsif Enable_Counter = '1' then 
    if MUX_1_OUT'event and MUX_1_OUT  ='1' then 
        MUX_1_Counter <= MUX_1_Counter + 1;
    end if;
end if;

end process;



--------------------------------------------------------------------------------------------------------------------
--
--                      Write FREQUENCIES on PUF_RESPONSE before WAIT_SENDING
-- 
--------------------------------------------------------------------------------------------------------------------
-- [63]     bit_comparison
-- [62]     NOT USED
-- [61:31]  MUX1_cpt
-- [30:0]   MUX2_cpt
-- led3 used for key == 1 (mux1 > mux2)
-- led4 used for key == 0 (mux1 < mux2)
-- do the comparison when Enable_Comparison
-- when register dumped, activate data_valid to WAIT_SEND on Tx
--------------------------------------------------------------------------------------------------------------------
process(clk)
begin
    if rising_edge(clk) then
        if Enable_Comparison = '1' then
            if MUX_1_Counter < MUX_2_Counter then
                --led3 <= '0';
                --led4 <= '1';
                PUF_Response(63) <= '0';
                PUF_Response(61 downto 31) <= std_logic_vector(MUX_1_Counter);
                PUF_Response(30 downto 0)  <= std_logic_vector(MUX_2_Counter);
            else
                --led3 <= '1';
                --led4 <= '0';
                PUF_Response(63) <= '1';
                PUF_Response(61 downto 31) <= std_logic_vector(MUX_1_Counter);
                PUF_Response(30 downto 0)  <= std_logic_vector(MUX_2_Counter);
            end if;
            data_valid <= '1';
        else
            data_valid <= '0';
        end if;
    end if;
end process;



end Behavioral;






