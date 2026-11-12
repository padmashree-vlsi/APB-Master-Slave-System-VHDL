----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2026 18:11:17
-- Design Name: 
-- Module Name: apb_top - Behavioral
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

entity apb_top is
    Port (
        PCLK     : in  std_logic;
        PRESETn  : in  std_logic;
        start    : in  std_logic;
        write_en : in  std_logic;
        addr     : in  std_logic_vector(7 downto 0);
        wdata    : in  std_logic_vector(31 downto 0);
        rdata    : out std_logic_vector(31 downto 0);
        done     : out std_logic;
        error    : out std_logic
    );
end apb_top;

architecture Structural of apb_top is

    signal PSEL_s    : std_logic;
    signal PENABLE_s : std_logic;
    signal PWRITE_s  : std_logic;
    signal PADDR_s   : std_logic_vector(7 downto 0);
    signal PWDATA_s  : std_logic_vector(31 downto 0);
    signal PRDATA_s  : std_logic_vector(31 downto 0);
    signal PREADY_s  : std_logic;
    signal PSLVERR_s : std_logic;

begin

    MASTER_INST : entity work.apb_master
        port map (
            PCLK     => PCLK,
            PRESETn  => PRESETn,
            start    => start,
            write_en => write_en,
            addr     => addr,
            wdata    => wdata,
            rdata    => rdata,
            done     => done,
            error    => error,
            PSEL     => PSEL_s,
            PENABLE  => PENABLE_s,
            PWRITE   => PWRITE_s,
            PADDR    => PADDR_s,
            PWDATA   => PWDATA_s,
            PRDATA   => PRDATA_s,
            PREADY   => PREADY_s,
            PSLVERR  => PSLVERR_s
        );

    SLAVE_INST : entity work.apb_slave
        port map (
            PCLK    => PCLK,
            PRESETn => PRESETn,
            PSEL    => PSEL_s,
            PENABLE => PENABLE_s,
            PWRITE  => PWRITE_s,
            PADDR   => PADDR_s,
            PWDATA  => PWDATA_s,
            PRDATA  => PRDATA_s,
            PREADY  => PREADY_s,
            PSLVERR => PSLVERR_s
        );

end Structural;