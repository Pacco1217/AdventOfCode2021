with text_io; use text_io;

procedure aoc05 is
  type Point is
  record
    x : Integer := 0;
    y : Integer := 0;
  end record;
  type Pair is
  record
    src  : Point;
    dest : Point;
  end record;
  
  type PairArray is array (Integer range <>) of Pair;
  
  type BoardArray is array(1..1000, 1..1000) of Integer;
  
  file     : File_Type;
  fileName : constant string := "D:\Install\aoc\05\src\input.txt";
  
  counter : Integer := 1;
  pairArr : PairArray(1 .. 500);
  board   : BoardArray := (others => (others => 0));
  
  result  : Integer := 0;
  
  source : Point;
  destination : Point;
  second    : Integer;
  
  procedure createPair(str : in String;
                       arr : in out PairArray;
                       pos : in Integer) is
  comma     : Integer := 0;
  srcSet    : boolean := false;
  lastSpace : Integer := 0;
  item      : Pair;
  begin
    for I in str'range loop
      if (not srcSet) then
        if( str(I) = ',') then
          arr(pos).src.x := Integer'Value(str(str'first .. I-1));
          comma := I;
        end if;
        if( str(I) = ' ') then
          arr(pos).src.y := Integer'Value(str(comma + 1 .. I - 1));
          lastSpace := I;
          srcSet := true;
        end if;
      else
        if( str(I) = ',') then
          arr(pos).dest.x := Integer'Value(str(lastSpace+1 .. I - 1));
          comma := I;
        end if;
      end if;
      if( str(I) = ' ' ) then
        lastSpace := I;
      end if;
    end loop;
    arr(pos).dest.y := Integer'Value(str(comma+1 .. str'last));
  end createPair;
  
  procedure printPair(p : in Pair) is
  begin
    text_io.put_line(Integer'Image(p.src.x) & "," & Integer'Image(p.src.y) & " -> " & Integer'Image(p.dest.x) & "," & Integer'Image(p.dest.y));
  end printPair;
  
  procedure printBoard(b : in BoardArray) is
  begin
    for I in 1 .. 100 loop 
      for J in 1 .. 80 loop
        text_io.put(Integer'Image(b(I,J)));
      end loop;
      text_io.put_line("");
    end loop;
  end printBoard;
begin
  text_io.put_line("aoc05 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      createPair(line, pairArr, counter);
      counter := counter + 1;
    end;
  end loop;
  close(file);
  for I in pairArr'range loop
    if (pairArr(I).src.x = pairArr(I).dest.x or pairArr(I).src.y = pairArr(I).dest.y) then
      if(pairArr(I).src.x > pairArr(I).dest.x or pairArr(I).src.y > pairArr(I).dest.y) then
        source      := pairArr(I).dest;
        destination := pairArr(I).src;
      else
        source      := pairArr(I).src;
        destination := pairArr(I).dest;
      end if;
      for J in source.x .. destination.x loop
        for K in source.y .. destination.y loop
          board(J,K) := board(J,K) + 1;
        end loop;
      end loop;
    end if;
  end loop;

  for I in 1 .. 1000 loop
    for J in 1 .. 1000 loop
      if (board(I,J) >= 2 ) then
        result := result + 1;
      end if;
    end loop;
  end loop;
  text_io.put_line(Integer'Image(result));
  -- RESET DATA
  result := 0;
  text_io.put_line("aoc05 part2");
  for I in pairArr'range loop
    if(abs(pairArr(I).src.x - pairArr(I).dest.x) = abs(pairArr(I).src.y - pairArr(I).dest.y)) then

      if(pairArr(I).src.x < pairArr(I).dest.x and pairArr(I).src.y < pairArr(I).dest.y) then
        second := pairArr(I).src.y;
        for J in pairArr(I).src.x .. pairArr(I).dest.x loop
          board(J,second) := board(J,second) + 1;
          second := second + 1;
        end loop;
      end if;
      
      if( pairArr(I).src.x < pairArr(I).dest.x and pairArr(I).src.y > pairArr(I).dest.y) then
        second := pairArr(I).src.y;
        for J in pairArr(I).src.x .. pairArr(I).dest.x loop
          board(J,second) := board(J,second) + 1;
          second := second - 1;
        end loop;
      end if;
      
      if( pairArr(I).src.x > pairArr(I).dest.x and pairArr(I).src.y < pairArr(I).dest.y) then
        second := pairArr(I).src.y;
        for J in reverse pairArr(I).dest.x .. pairArr(I).src.x loop
          board(J,second) := board(J,second) + 1;
          second := second + 1;
        end loop;
      end if;
      
      if( pairArr(I).src.x > pairArr(I).dest.x and pairArr(I).src.y > pairArr(I).dest.y) then
        second := pairArr(I).src.y;
        for J in reverse pairArr(I).dest.x .. pairArr(I).src.x loop
          board(J,second) := board(J,second) + 1;
          second := second - 1;
        end loop;
      end if;
    end if;
  end loop;
  for I in 1 .. 1000 loop
    for J in 1 .. 1000 loop
      if (board(I,J) >= 2 ) then
        result := result + 1;
      end if;
    end loop;
  end loop;
  text_io.put_line(Integer'Image(result));
end aoc05;