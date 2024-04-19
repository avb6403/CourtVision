-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 19.4.2024 20:02:32 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_XCentroidFinder is
end tb_XCentroidFinder;

architecture tb of tb_XCentroidFinder is

    component XCentroidFinder
        port (clk      : in std_logic;
              rst      : in std_logic;
              finished : out std_logic);
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal finished : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : XCentroidFinder
    port map (clk      => clk,
              rst      => rst,
              finished => finished);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_XCentroidFinder of tb_XCentroidFinder is
    for tb
    end for;
end cfg_tb_XCentroidFinder;