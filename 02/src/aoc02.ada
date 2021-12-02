with text_io; use text_io;

procedure aoc02 is
  file : File_Type;
  fileName : constant string := "D:\Install\aoc\02\src\input.txt";
  horizontalPos : Integer := 0;
  verticalPos   : Integer := 0;
  val           : Integer := 0;
  aim           : Integer := 0;
begin
  text_io.put_line("aoc02 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      val := Character'Pos(line((line'last))) - 48;
      case line(line'first) is
        when 'f' =>
          horizontalPos := horizontalPos + val;
        when 'd' =>
          verticalPos := verticalPos + val;
        when 'u' =>
          verticalPos := verticalPos - val;
        when others =>
          null;
      end case;
    end;
  end loop;
  close(file);
  text_io.put_line("Result : " & Integer'Image(horizontalPos * verticalPos));
  -- RESET
  horizontalPos := 0;
  verticalPos   := 0;
  
  text_io.put_line("aoc02 part2");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      val := Character'Pos(line((line'last))) - 48;
      case line(line'first) is
        when 'f' =>
          horizontalPos := horizontalPos + val;
          verticalPos   := verticalPos + (aim * val);
        when 'd' =>
          aim := aim + val;
        when 'u' =>
          aim := aim - val;
        when others =>
          null;
      end case;
    end;
  end loop;
  close(file);
  text_io.put_line("Result : " & Integer'Image(horizontalPos * verticalPos));
end aoc02;