With text_io; use text_io;
procedure aoc06 is

  type unsigned_64 is mod 2**64;
    
  type fishArray is array(0..8) of unsigned_64;
  
  file     : File_Type;
  fileName : constant string := "/home/Pacco/AdventOfCode2021/06/src/input.txt";
  value    : Integer := 0;
  comma    : boolean := false;
  
  fishArr  : fishArray := (others => 0);
  
  procedure runDay(fishes : in out fishArray) is
  zeros : unsigned_64 := 0;
  begin
    zeros := fishes(0);
    for I in 1 .. fishes'last loop
      fishes(I-1) := fishes(I);
    end loop;
    fishes(6) := fishes(6) + zeros;
    fishes(8) := zeros;
  end runDay;
  
  function countFishes(fishes : in fishArray) return unsigned_64 is
    total : unsigned_64 := 0;
  begin
    for I in fishes'range loop
      text_io.put_line(unsigned_64'image(fishes(I)));
      if (total + fishes(I) < total) then
        text_io.put_line("WRAP " & Integer'Image(I));
      end if;
      total := total + fishes(I);
    end loop;
    return total;
  end countFishes;
begin
  text_io.put_line("aoc06 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      for I in line'range loop
        if (comma) then
          comma := false;
        else
          value := Character'Pos(line(I)) - 16#30#;
          comma := true;
          fishArr(value) := fishArr(value) + 1;
        end if;
      end loop;
    end;
  end loop;
  close(file);
  for I in 1 .. 80 loop
    runDay(fishArr);
  end loop;
  text_io.put_line("After 80 days : " & unsigned_64'Image(countFishes(fishArr)));
  for I in 81 .. 256 loop
    runDay(fishArr);
  end loop;
  text_io.put_line("After 256 days : " & unsigned_64'Image(countFishes(fishArr)));
end aoc06;