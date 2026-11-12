----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2026 18:13:41
-- Design Name: 
-- Module Name: apb-system_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity apb-system_tb is
--  Port ( );
end apb-system_tb;

architecture Behavioral of apb-system_tb is
    signal PCLK     : std_logic := '0';
    signal PRESETn  : std_logic := '0';

    signal start    : std_logic := '0';
    signal write_en : std_logic := '0';
    signal addr     : std_logic_vector(7 downto 0) := (others => '0');
    signal wdata    : std_logic_vector(31 downto 0) := (others => '0');

    signal rdata    : std_logic_vector(31 downto 0);
    signal done     : std_logic;
    signal error_out: std_logic;
begin
 -- 10 ns clock
    PCLK <= not PCLK after 5 ns;

    -- DUT
    DUT : entity work.apb_top
        port map (
            PCLK     => PCLK,
            PRESETn  => PRESETn,
            start    => start,
            write_en => write_en,
            addr     => addr,
            wdata    => wdata,
            rdata    => rdata,
            done     => done,
            error    => error_out
        );

    -- Test stimulus
    process
    begin

        -- Reset
        PRESETn <= '0';
        wait for 20 ns;
        wait until falling_edge(PCLK);
        PRESETn <= '1';

        -- Test 1: Write register 0
        wait until falling_edge(PCLK);
        addr <= x"00";
        wdata <= x"12345678";
        write_en <= '1';
        start <= '1';

        wait until falling_edge(PCLK);
        start <= '0';

        wait until done = '1';
        wait for 1 ns;

        assert error_out = '0'
            report "Write operation failed!"
            severity error;

        -- Test 2: Read register 0
        wait until falling_edge(PCLK);
        addr <= x"00";
        write_en <= '0';
        start <= '1';

        wait until falling_edge(PCLK);
        start <= '0';

        wait until done = '1';
        wait for 1 ns;

        assert rdata = x"12345678"
            report "Read data mismatch!"
            severity error;

        -- Test 3: Invalid address write
        wait until falling_edge(PCLK);
        addr <= x"10";
        wdata <= x"FFFFFFFF";
        write_en <= '1';
        start <= '1';

        wait until falling_edge(PCLK);
        start <= '0';

        wait until done = '1';
        wait for 1 ns;

        assert error_out = '1'
            report "Invalid address error not detected!"
            severity error;

        -- Test 4: Verify register 0 remains unchanged
        wait until falling_edge(PCLK);
        addr <= x"00";
        write_en <= '0';
        start <= '1';

        wait until falling_edge(PCLK);
        start <= '0';

        wait until done = '1';
        wait for 1 ns;

        assert rdata = x"12345678"
            report "Invalid write corrupted register 0!"
            severity error;

        report "APB Master-Slave System tests completed!"
            severity note;

        wait;
    end process;


end Behavioral;
