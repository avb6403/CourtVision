library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity XCentroidFinder is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        finished: out std_logic
    );
end XCentroidFinder;

architecture Behavioral of XCentroidFinder is
    type img_ram is array (natural range <>, natural range <>) of std_logic;

    signal img : img_ram(0 to 4, 0 to 4) := (	('0', '0', '1', '0', '0'),
                                                ('0', '1', '0', '1', '0'),
                                                ('1', '1', '0', '1', '1'),
                                                ('0', '1', '0', '1', '0'),
                                                ('0', '0', '1', '0', '0')
                                            );
                                        
    type accu_arr is array (natural range <>) of unsigned(15 downto 0);
    signal x_array : accu_arr(4 downto 0) := (others => (others => '0'));
    
    constant width : unsigned(15 downto 0) := to_unsigned(5, 16);
    constant height : unsigned(15 downto 0) := to_unsigned(5, 16);
    
	signal left_edge : unsigned(15 downto 0) := x"0000";
    signal right_edge : unsigned(15 downto 0) := x"0001";
    signal row : unsigned(15 downto 0) := x"0000";
    signal center : unsigned(15 downto 0) := x"0000";
    
    signal left_pixel : std_logic := '0';
    signal right_pixel : std_logiC := '0';
    
    signal fin : std_logic := '0';
    
begin
    process(clk, rst)
    begin
      if rst = '1' then
          left_edge <= (others => '0');
          right_edge <= (0=>'1', others => '0');
          row <= (others => '0');
      elsif rising_edge(clk) and fin = '0' then
          if row < height - 1 then
              row <= row + 1;
          else
              row <= (others => '0');
              if right_edge < width - 1 then
                  right_edge <= right_edge + 1;
              else
                  if left_edge < width - 1 then
                      left_edge <= left_edge + 1;
                      if left_edge < width - 2 then
                        right_edge <= left_edge + 2;
                      else
                      	right_edge <= left_edge + 1;
                      end if;
                  else
                      left_edge <= (others => '0');
                      right_edge <= (0=>'1', others => '0');
                      row <= (others => '0');
                      fin <= '1';
                  end if;
              end if;
          end if;
      end if; 
    end process;
    
    process(fin, left_pixel, right_pixel)
    begin
    	if fin = '0' then
        	x_array(to_integer(center)) <= x_array(to_integer(center)) +  ("" & (left_pixel and right_pixel));
            report "x array index " & to_string(to_integer(center)) & ": " & to_string(to_integer(x_array(to_integer(center))));
        end if;
    end process;
	
    finished <= fin;
    center <= (left_edge + right_edge) / 2;
    left_pixel <= img(to_integer(row), to_integer(left_edge));
    right_pixel <= img(to_integer(row), to_integer(right_edge));
end Behavioral;

