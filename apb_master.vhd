
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity apb_master is
    Port (
        -- System signals
        PCLK     : in  std_logic;
        PRESETn  : in  std_logic;

        -- User interface
        start    : in  std_logic;
        write_en : in  std_logic;
        addr     : in  std_logic_vector(7 downto 0);
        wdata    : in  std_logic_vector(31 downto 0);
        rdata    : out std_logic_vector(31 downto 0);
        done     : out std_logic;
        error    : out std_logic;

        -- APB interface
        PSEL     : out std_logic;
        PENABLE  : out std_logic;
        PWRITE   : out std_logic;
        PADDR    : out std_logic_vector(7 downto 0);
        PWDATA   : out std_logic_vector(31 downto 0);
        PRDATA   : in  std_logic_vector(31 downto 0);
        PREADY   : in  std_logic;
        PSLVERR  : in  std_logic
    );
end apb_master;

architecture Behavioral of apb_master is

    type state_type is (IDLE, SETUP, APB_ACCESS);
    signal state : state_type := IDLE;

    signal addr_reg  : std_logic_vector(7 downto 0);
    signal wdata_reg : std_logic_vector(31 downto 0);
    signal write_reg : std_logic;

    signal rdata_reg : std_logic_vector(31 downto 0);
    signal done_reg  : std_logic;
    signal error_reg : std_logic;

begin

    -- APB output assignments
    PSEL    <= '1' when state = SETUP or state = APB_ACCESS else '0';
    PENABLE <= '1' when state = APB_ACCESS else '0';

    PWRITE  <= write_reg;
    PADDR   <= addr_reg;
    PWDATA  <= wdata_reg;

    rdata <= rdata_reg;
    done  <= done_reg;
    error <= error_reg;

    -- APB Master FSM
    process(PCLK, PRESETn)
    begin
        if PRESETn = '0' then
            state     <= IDLE;
            addr_reg  <= (others => '0');
            wdata_reg <= (others => '0');
            write_reg <= '0';
            rdata_reg <= (others => '0');
            done_reg  <= '0';
            error_reg <= '0';

        elsif rising_edge(PCLK) then

            done_reg <= '0';

            case state is

                when IDLE =>
                    if start = '1' then
                        addr_reg  <= addr;
                        wdata_reg <= wdata;
                        write_reg <= write_en;
                        error_reg <= '0';
                        state <= SETUP;
                    end if;

                when SETUP =>
                    state <= APB_ACCESS;

                when APB_ACCESS =>
                    if PREADY = '1' then

                        if write_reg = '0' then
                            rdata_reg <= PRDATA;
                        end if;

                        error_reg <= PSLVERR;
                        done_reg <= '1';
                        state <= IDLE;

                    end if;

            end case;
        end if;
    end process;

end Behavioral;
