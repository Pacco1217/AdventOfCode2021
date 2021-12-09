with text_io; use text_io;
with Utils;

procedure aoc09 is
  type Point is
  record
    int       : Integer := 0;
    low       : Boolean := False;
    bassinNum : Integer := 0;
  end record;
  type PointArray is array (Integer range <>) of Point;

  file     : File_Type;
  fileName : constant string := "/home/Pacco/AdventOfCode2021/09/src/input.txt";
  --fileName : constant string := "/home/Pacco/AdventOfCode2021/09/src/testInput.txt";
  count    : Integer := 0;
  lineSize : Integer := 0;
  
begin
  text_io.put_line("aoc09 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      lineSize := line'last;
      count := count + 1;
    end;
  end loop;
  close(file);

  declare
    type BoardArray is array(Integer range <>) of PointArray(1..lineSize);
    board    : BoardArray(1..count);

    bassinTotal : Integer := 0;

    procedure checkLowPoints(b : in out BoardArray) is
      isLowest : Boolean := True;
    begin
      for I in b'Range loop
        for J in b(I)'Range loop
          isLowest := True;
          -- check Left Value
          if(J-1 in b(I)'Range) then
            if (b(I)(J).int < b(I)(J-1).int) then
              isLowest := isLowest and True;
            else
              isLowest := False;
            end if;
          end if;
          -- check Right Value
          if(J+1 in b(I)'Range) then
            if (b(I)(J).int < b(I)(J+1).int) then
              isLowest := isLowest and True;
            else
              isLowest := False;
            end if;
          end if;
          -- check Up Value
          if(I-1 in b'Range) then
            if (b(I)(J).int < b(I-1)(J).int) then
              isLowest := isLowest and True;
            else
              isLowest := False;
            end if;
          end if;
          -- check Down Value
          if(I+1 in b'Range) then
            if (b(I)(J).int < b(I+1)(J).int) then
              isLowest := isLowest and True;
            else
              isLowest := False;
            end if;
          end if;
          b(I)(J).low := isLowest;        
        end loop;
      end loop;
    end checkLowPoints;

    procedure mark(b    : in out BoardArray;
                   x    : in Integer;
                   y    : in Integer;
                   bNum : in Integer) is
    begin
      --exit if point already in a bassin or is value is 9
      if (b(x)(y).bassinNum /= 0 or b(x)(y).int = 9) then
        return;
      else
        -- mark hiself as a member of a bassin
        b(x)(y).bassinNum := bNum;
        -- check if neighbour are in the same bassin
        -- check Left Value
        if(y-1 in b(x)'Range) then
          mark(b, x, y-1, bNum);
        end if;
        -- check Right Value
        if(y+1 in b(x)'Range) then
          mark(b, x, y+1, bNum);
        end if;
        -- check Up Value
        if(x-1 in b'Range) then
          mark(b, x-1, y, bNum);
        end if;
        -- check Down Value
        if(x+1 in b'Range) then
          mark(b, x+1, y, bNum);
        end if;
      end if;
    end mark;

    function checkBassins(b : in out BoardArray) return Integer is
      bassin : Integer := 0;
    begin
      for I in b'Range loop
        for J in b(I)'Range loop
          if(b(I)(J).bassinNum = 0 and b(I)(J).int /= 9) then
            bassin := bassin + 1;
            mark(b, I, J, bassin);
          end if;
        end loop;
      end loop;
      return bassin;
    end checkBassins;


    function countRiskLevel (b : in BoardArray) return Integer is
      total : Integer := 0;
    begin
      for I in b'Range loop
        for J in b(I)'Range loop
          if (b(I)(J).low) then
            total := total + b(I)(J).int + 1;
          end if;
        end loop;
      end loop;
      return total;
    end countRiskLevel;

    procedure printBoardBassin(b : in BoardArray) is
    begin
      for I in b'Range loop
        for J in b(I)'Range loop
          Text_IO.Put(Integer'Image(b(I)(j).bassinNum));
        end loop;
        Text_IO.Put_Line ("");
      end loop;
    end printBoardBassin;

  begin
    -- INIT data
    count := 1;
    open (file, In_File, fileName);
    while not End_Of_File(file) loop
      declare
        line : String := Get_Line(file);
      begin
        for I in line'range loop
          board(count)(I).int := Character'Pos(line(I)) - 48;
        end loop;
        count := count + 1;
      end;
    end loop;
    close(file);
    -- Process DATA
    checkLowPoints (board);

    Text_IO.Put_Line ("risk level : " & Integer'Image(countRiskLevel(board)));

    text_io.put_line("aoc09 part2");
    bassinTotal := checkBassins(board);
    declare
      bassinArr : Utils.IntegerArray(1..bassinTotal) := (others => 0);
    begin
      -- count Bassin mebers
      for I in board'Range loop
        for J in board(I)'Range loop
          if(board(I)(J).int /= 9) then
            bassinArr(board(I)(J).bassinNum) := bassinArr(board(I)(J).bassinNum) + 1;
          end if;
        end loop;    
      end loop;
      -- sort array
      Utils.Bubble_Sort (bassinArr);
      -- get result
      Text_IO.Put_Line ("Result : " & Integer'Image(Utils.getBiggestNumberProduct(bassinArr, 3)));
    end;
  end;
end aoc09;